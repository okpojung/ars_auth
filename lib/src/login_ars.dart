import 'dart:async';

import 'package:flutter/material.dart';

import 'ars_auth_controller.dart';
import 'config.dart';
import 'models.dart';

typedef ArsAuthStartCallback = void Function();
typedef ArsAuthCompleteCallback = void Function(ArsResult result);
typedef ArsAuthFailureCallback = void Function(ArsResult result);

/// 발신 ARS 인증 화면.
///
/// [ARS 인증] 버튼 → 서버에서 인증 번호를 받아 **바로 발신**(번호는 화면에 표시하지 않음) →
/// 대기 화면(안내 문구, 남은 시간) → 결과를 콜백으로 돌려주고, [popOnFinish]가 true면
/// `Navigator.pop(ArsResult)` 합니다.
class LoginARS extends StatefulWidget {
  const LoginARS({
    super.key,
    required this.config,
    this.onAuthStart,
    this.onAuthComplete,
    this.onAuthFailure,
    this.autoStart = false,
    this.popOnFinish = true,
    this.title = '휴대폰 인증',
    this.controller,
  });

  final Ars2faConfig config;
  final ArsAuthStartCallback? onAuthStart;
  final ArsAuthCompleteCallback? onAuthComplete;
  final ArsAuthFailureCallback? onAuthFailure;

  /// 화면이 열리자마자 인증 시작.
  final bool autoStart;
  final bool popOnFinish;
  final String title;

  /// 테스트나 커스텀 발신기를 쓸 때 주입.
  final ArsAuthController? controller;

  @override
  State<LoginARS> createState() => _LoginARSState();
}

class _LoginARSState extends State<LoginARS> with WidgetsBindingObserver {
  late final ArsAuthController _c = widget.controller ?? ArsAuthController(config: widget.config);
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _c.addListener(_onChange);
    _tick = Timer.periodic(const Duration(milliseconds: 250), (_) {
      if (_c.phase == ArsAuthPhase.waitingCall && mounted) setState(() {});
    });
    if (widget.autoStart) WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // back from the phone app: check right away
    if (state == AppLifecycleState.resumed) _c.checkNow();
  }

  void _onChange() {
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _start() async {
    widget.onAuthStart?.call();
    final r = await _c.start();
    if (!mounted) return;
    if (r.success) {
      widget.onAuthComplete?.call(r);
    } else {
      widget.onAuthFailure?.call(r);
    }
    if (widget.popOnFinish && r.success && Navigator.of(context).canPop()) {
      Navigator.of(context).pop(r);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tick?.cancel();
    _c.removeListener(_onChange);
    if (_c.phase == ArsAuthPhase.waitingCall || _c.phase == ArsAuthPhase.starting) {
      unawaited(_c.cancel());
    }
    if (widget.controller == null) _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopScope(
      canPop: _c.phase != ArsAuthPhase.waitingCall,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop && _c.phase == ArsAuthPhase.waitingCall) {
          await _c.cancel();
          if (context.mounted && Navigator.of(context).canPop()) Navigator.of(context).pop(_c.result);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: switch (_c.phase) {
              ArsAuthPhase.idle => _idle(theme),
              ArsAuthPhase.starting => const Center(child: CircularProgressIndicator()),
              ArsAuthPhase.waitingCall => _waiting(theme),
              ArsAuthPhase.finished => _finished(theme),
            },
          ),
        ),
      ),
    );
  }

  Widget _idle(ThemeData theme) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('발신 ARS 휴대폰 인증', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 16),
          Text(
            '아래 버튼을 누르면 인증 전화가 바로 걸립니다.\n'
            '통화가 연결되면 음성 안내에 따라 진행해 주세요.\n'
            '휴대폰 번호는 통신사 기록으로 자동 확인되므로 입력할 필요가 없습니다.',
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
          ),
          const Spacer(),
          FilledButton(
            onPressed: _start,
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
            child: const Text('ARS 인증', style: TextStyle(fontSize: 18)),
          ),
        ],
      );

  Widget _waiting(ThemeData theme) {
    final s = _c.session;
    final left = _c.remaining?.inSeconds ?? 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('인증 전화 진행 중', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 16),
        if ((s?.displayName ?? '').isNotEmpty)
          Text('요청한 서비스: ${s!.displayName}', style: theme.textTheme.bodyMedium),
        const SizedBox(height: 8),
        Text(
          (s?.confirmKey ?? true) ? '안내가 나오면 1번을 누르세요' : '전화가 연결되면 잠시 기다려 주세요',
          style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
        ),
        if ((s?.notice ?? '').isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(s!.notice, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error)),
        ],
        const SizedBox(height: 24),
        Center(
          child: Text(
            left > 0 ? '전화를 걸 수 있는 남은 시간 $left초' : '결과를 확인하는 중입니다…',
            style: theme.textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: 12),
        const Center(child: CircularProgressIndicator()),
        const Spacer(),
        OutlinedButton(onPressed: _c.cancel, child: const Text('인증 취소')),
      ],
    );
  }

  Widget _finished(ThemeData theme) {
    final r = _c.result;
    final ok = r?.success ?? false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(ok ? Icons.check_circle : Icons.error, size: 72, color: ok ? Colors.green : theme.colorScheme.error),
        const SizedBox(height: 16),
        Text(ok ? '인증되었습니다' : '인증에 실패했습니다', textAlign: TextAlign.center, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(ok ? (r?.phoneMasked ?? '') : (r?.message ?? ''), textAlign: TextAlign.center, style: theme.textTheme.bodyLarge),
        const Spacer(),
        if (!ok)
          FilledButton(
            onPressed: _start,
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
            child: const Text('다시 시도'),
          ),
        if (!ok && Navigator.of(context).canPop())
          TextButton(onPressed: () => Navigator.of(context).pop(r), child: const Text('닫기')),
      ],
    );
  }
}
