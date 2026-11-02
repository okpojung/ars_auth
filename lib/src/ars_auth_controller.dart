import 'dart:async';

import 'package:flutter/foundation.dart';

import 'ars2fa_client.dart';
import 'config.dart';
import 'dialer.dart';
import 'models.dart';

/// 진행 단계.
enum ArsAuthPhase { idle, starting, waitingCall, finished }

/// 인증 흐름: 세션 생성 → 바로 발신 → 상태 폴링 → 결과.
/// UI와 분리되어 있어 직접 써도 되고 [LoginARS] 위젯이 내부에서 씁니다.
class ArsAuthController extends ChangeNotifier {
  ArsAuthController({
    required this.config,
    Ars2faClient? client,
    ArsDialer? dialer,
    DateTime Function()? clock,
  })  : client = client ?? Ars2faClient(config),
        dialer = dialer ?? DefaultArsDialer(directCall: config.useDirectCall),
        _clock = clock ?? DateTime.now;

  final Ars2faConfig config;
  final Ars2faClient client;
  final ArsDialer dialer;
  final DateTime Function() _clock;

  ArsAuthPhase phase = ArsAuthPhase.idle;
  ArsSession? session;
  ArsSessionState? lastState;
  ArsResult? result;

  Timer? _poll;
  bool _polling = false;
  Completer<ArsResult>? _done;
  bool _disposed = false;

  /// 남은 시간 (서버 시계 기준). 대기 중이 아니면 null.
  Duration? get remaining => phase == ArsAuthPhase.waitingCall ? session?.remaining(_clock()) : null;

  /// 인증을 시작하고 최종 결과를 기다린다.
  Future<ArsResult> start() {
    if (phase == ArsAuthPhase.starting || phase == ArsAuthPhase.waitingCall) return _done!.future;
    _done = Completer<ArsResult>();
    result = null;
    lastState = null;
    session = null;
    _set(ArsAuthPhase.starting);
    unawaited(_run());
    return _done!.future;
  }

  Future<void> _run() async {
    try {
      IntegrityProof? proof;
      if (config.integrityProvider != null) {
        final nonce = await client.integrityChallenge();
        proof = await config.integrityProvider!(nonce);
      }
      final s = await client.createSession(proof: proof);
      session = s;
      _set(ArsAuthPhase.waitingCall);
      final dialed = await dialer.dial(s.dialUri);
      if (!dialed) {
        await _safeCancel();
        _finish(ArsResult.failed(sessionId: s.sessionId, reason: 'dial_failed'));
        return;
      }
      _poll = Timer.periodic(config.pollInterval, (_) => checkNow());
    } on Ars2faException catch (e) {
      _finish(ArsResult.failed(sessionId: session?.sessionId, errorCode: e.code));
    } catch (_) {
      _finish(ArsResult.failed(sessionId: session?.sessionId, errorCode: 'NETWORK_ERROR'));
    }
  }

  /// 즉시 상태를 확인한다 (앱이 포그라운드로 돌아왔을 때 등).
  Future<void> checkNow() async {
    final s = session;
    if (s == null || phase != ArsAuthPhase.waitingCall || _polling) return;
    // safety net: the server decides within ~20 s after the window; never poll forever
    if (_clock().add(s.clockOffset).isAfter(s.expiresAt.add(const Duration(seconds: 90)))) {
      _finish(ArsResult.failed(sessionId: s.sessionId, reason: 'timeout'));
      return;
    }
    _polling = true;
    try {
      final st = await client.status(s.sessionId);
      lastState = st;
      if (st.status == ArsSessionStatus.verified) {
        _finish(ArsResult.verified(st));
      } else if (st.status.isFinal) {
        _finish(ArsResult.failed(sessionId: s.sessionId, reason: st.failReason ?? st.status.name));
      } else {
        _notify();
      }
    } on Ars2faException catch (e) {
      if (e.statusCode == 404 || e.statusCode == 401 || e.statusCode == 403) {
        _finish(ArsResult.failed(sessionId: s.sessionId, errorCode: e.code));
      }
      // 일시적 네트워크 오류는 다음 폴링에서 재시도
    } finally {
      _polling = false;
    }
  }

  /// 사용자가 중단. 서버 세션도 취소한다.
  Future<void> cancel() async {
    if (phase == ArsAuthPhase.finished || phase == ArsAuthPhase.idle) return;
    final id = session?.sessionId;
    await _safeCancel();
    _finish(ArsResult.failed(sessionId: id, reason: 'canceled_by_client'));
  }

  Future<void> _safeCancel() async {
    final s = session;
    if (s == null) return;
    try {
      await client.cancel(s.sessionId);
    } catch (_) {}
  }

  void _finish(ArsResult r) {
    if (phase == ArsAuthPhase.finished) return;
    _poll?.cancel();
    result = r;
    _set(ArsAuthPhase.finished);
    if (!(_done?.isCompleted ?? true)) _done!.complete(r);
  }

  void _set(ArsAuthPhase p) {
    phase = p;
    _notify();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _poll?.cancel();
    super.dispose();
  }
}
