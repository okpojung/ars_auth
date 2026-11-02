import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'config.dart';
import 'models.dart';

/// ars2fa API 호출 오류.
class Ars2faException implements Exception {
  Ars2faException(this.code, this.message, {this.statusCode});

  /// 예: NO_NUMBER_AVAILABLE, CARRIER_UNAVAILABLE, APP_INTEGRITY_FAILED, SESSION_NOT_FOUND, HTTP_401, NETWORK_ERROR
  final String code;
  final String message;
  final int? statusCode;

  @override
  String toString() => 'Ars2faException($code${statusCode == null ? '' : ', $statusCode'})';
}

/// `/v1/ars/*` 고객 API 클라이언트. UI 없이 직접 쓸 수도 있습니다.
class Ars2faClient {
  Ars2faClient(this.config, {http.Client? httpClient, DateTime Function()? clock})
      : _http = httpClient ?? http.Client(),
        _clock = clock ?? DateTime.now;

  final Ars2faConfig config;
  final http.Client _http;
  final DateTime Function() _clock;

  Uri _uri(String path) => Uri.parse('${config.baseUrl.replaceAll(RegExp(r'/+$'), '')}$path');

  Future<Map<String, dynamic>> _post(String path, Map<String, dynamic> body) async {
    final payload = {...config.identity(), ...body}..removeWhere((_, v) => v == null);
    http.Response r;
    try {
      r = await _http
          .post(
            _uri(path),
            headers: {
              'content-type': 'application/json; charset=utf-8',
              'accept': 'application/json',
              // api_key 는 본문 대신 헤더로 보냄
              'authorization': 'Bearer ${config.apiKey}',
            },
            body: jsonEncode(payload),
          )
          .timeout(config.requestTimeout);
    } on TimeoutException {
      throw Ars2faException('NETWORK_ERROR', 'timeout');
    } catch (e) {
      throw Ars2faException('NETWORK_ERROR', e.runtimeType.toString());
    }
    Map<String, dynamic>? json;
    try {
      final decoded = jsonDecode(utf8.decode(r.bodyBytes));
      if (decoded is Map<String, dynamic>) json = decoded;
    } catch (_) {}
    if (r.statusCode >= 200 && r.statusCode < 300 && json != null) return json;
    throw errorFrom(r.statusCode, json);
  }

  /// Nest 오류 본문 `{code, message}` / `{message: 'NO_NUMBER_AVAILABLE'}` / `{message: [...]}` 를 해석.
  static Ars2faException errorFrom(int status, Map<String, dynamic>? json) {
    final msg = json?['message'];
    final msgText = msg is List ? msg.join(', ') : msg?.toString() ?? '';
    String code;
    if (json?['code'] is String) {
      code = json!['code'] as String;
    } else if (RegExp(r'^[A-Z][A-Z0-9_]+$').hasMatch(msgText)) {
      code = msgText;
    } else {
      code = 'HTTP_$status';
    }
    return Ars2faException(code, msgText, statusCode: status);
  }

  /// 무결성 증명용 1회용 nonce.
  Future<String> integrityChallenge() async {
    final j = await _post('/v1/ars/integrity/challenge', {});
    return (j['nonce'] ?? j['integrity_nonce']) as String;
  }

  /// iOS App Attest 키 등록 (앱 설치 후 1회).
  Future<Map<String, dynamic>> registerIosAttestKey({
    required String keyId,
    required String attestation,
    required String nonce,
  }) =>
      _post('/v1/ars/integrity/ios/attest',
          {'key_id': keyId, 'attestation': attestation, 'integrity_nonce': nonce});

  /// 인증 세션 생성 (APP 모드). 응답의 번호로 바로 발신하세요.
  Future<ArsSession> createSession({
    String? purpose,
    String? expectedPhone,
    String? appsid,
    int? type,
    IntegrityProof? proof,
  }) async {
    final t = type ?? config.type;
    final j = await _post('/v1/ars/sessions', {
      'mode': 'APP',
      'purpose': purpose ?? config.purpose,
      'expected_phone': expectedPhone ?? config.expectedPhone,
      'appsid': appsid ?? config.appsid,
      if (t == 0 || t == 1) 'type': t,
      ...?proof?.toJson(),
    });
    return ArsSession.fromJson(j, receivedAt: _clock());
  }

  Future<ArsSessionState> status(String sessionId) async =>
      ArsSessionState.fromJson(await _post('/v1/ars/sessions/status', {'session_id': sessionId}));

  Future<ArsSessionState> cancel(String sessionId) async =>
      ArsSessionState.fromJson(await _post('/v1/ars/sessions/cancel', {'session_id': sessionId}));

  void close() => _http.close();
}
