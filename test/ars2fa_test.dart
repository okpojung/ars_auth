import 'dart:convert';

import 'package:ars_login/ars_login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const cfg = Ars2faConfig(
  apiKey: 'test_key_123',
  mobileAppName: 'BS Point',
  packageName: 'com.example.bspoint',
  platform: 'ANDROID',
  baseUrl: 'https://ars2fa.test/',
  pollInterval: Duration(milliseconds: 10),
);

class FakeDialer implements ArsDialer {
  FakeDialer([this.ok = true]);
  final bool ok;
  final dialed = <String>[];
  @override
  Future<bool> dial(String telUri) async {
    dialed.add(telUri);
    return ok;
  }
}

http.Response j(Object body, [int status = 200]) =>
    http.Response.bytes(utf8.encode(jsonEncode(body)), status, headers: {'content-type': 'application/json'});

Map<String, dynamic> sessionJson({String? serverTime}) {
  final st = serverTime ?? '2026-10-31T08:00:00.000Z';
  return {
      'session_id': 'ars_abcdefghijkl',
      'status': 'PENDING',
      'mode': 'APP',
      'dial_number': '0507-1289-1030',
      'dial_uri': 'tel:0507-1289-1030',
      'expires_at': DateTime.parse(st).add(const Duration(seconds: 30)).toUtc().toIso8601String(),
      'expires_in': 30,
      'display_name': '바로포인트',
      'integrity': 'NOT_PROVIDED',
      'notice': '바로포인트 인증 전화입니다.',
      'server_time': st,
    };
}

void main() {
  group('Ars2faClient', () {
    test('createSession sends identity, bearer key and mode APP; parses session', () async {
      late http.Request seen;
      final client = Ars2faClient(cfg,
          httpClient: MockClient((req) async {
            seen = req;
            return j(sessionJson(), 201);
          }),
          clock: () => DateTime.parse('2026-10-31T08:00:02.000Z'));
      final s = await client.createSession(purpose: '로그인');
      expect(seen.url.toString(), 'https://ars2fa.test/v1/ars/sessions');
      expect(seen.headers['authorization'], 'Bearer test_key_123');
      final body = jsonDecode(seen.body) as Map<String, dynamic>;
      expect(body, {
        'mobile_app_name': 'BS Point',
        'client_platform': 'ANDROID',
        'package_name': 'com.example.bspoint',
        'mode': 'APP',
        'purpose': '로그인',
      });
      expect(body.containsKey('api_key'), isFalse);
      expect(s.sessionId, 'ars_abcdefghijkl');
      expect(s.dialUri, 'tel:0507-1289-1030');
      expect(s.status, ArsSessionStatus.pending);
      // device clock is 2 s ahead of the server
      expect(s.clockOffset, const Duration(seconds: -2));
      expect(s.remaining(DateTime.parse('2026-10-31T08:00:12.000Z')), const Duration(seconds: 20));
      expect(s.toString(), isNot(contains('0507')));
    });

    test('integrity proof fields are sent', () async {
      late Map<String, dynamic> body;
      final client = Ars2faClient(cfg, httpClient: MockClient((req) async {
        body = jsonDecode(req.body) as Map<String, dynamic>;
        return j(sessionJson(), 201);
      }));
      await client.createSession(proof: IntegrityProof.android(nonce: 'n1', token: 't1'));
      expect(body['integrity_nonce'], 'n1');
      expect(body['integrity_token'], 't1');
    });

    test('error bodies map to codes', () {
      expect(Ars2faClient.errorFrom(503, {'code': 'CARRIER_UNAVAILABLE', 'message': '...'}).code, 'CARRIER_UNAVAILABLE');
      expect(Ars2faClient.errorFrom(503, {'statusCode': 503, 'message': 'NO_NUMBER_AVAILABLE'}).code, 'NO_NUMBER_AVAILABLE');
      expect(Ars2faClient.errorFrom(400, {'message': ['purpose must be shorter'], 'error': 'Bad Request'}).code, 'HTTP_400');
      expect(Ars2faClient.errorFrom(500, null).code, 'HTTP_500');
    });

    test('status parsing', () {
      final st = ArsSessionState.fromJson({
        'session_id': 'ars_x', 'status': 'VERIFIED', 'phone': '01097111104', 'phone_masked': '010****1104', 'fail_reason': null,
      });
      expect(st.status, ArsSessionStatus.verified);
      expect(st.status.isFinal, isTrue);
      expect(st.phone, '01097111104');
      expect(st.toString(), isNot(contains('01097111104')));
      expect(ArsSessionStatus.parse('CALL_CONFIRMED'), ArsSessionStatus.callConfirmed);
      expect(ArsSessionStatus.parse('???'), ArsSessionStatus.unknown);
    });
  });

  group('ArsAuthController', () {
    test('create -> dial -> poll until VERIFIED', () async {
      var polls = 0;
      final dialer = FakeDialer();
      final c = ArsAuthController(
        config: cfg,
        dialer: dialer,
        client: Ars2faClient(cfg, httpClient: MockClient((req) async {
          if (req.url.path.endsWith('/sessions')) return j(sessionJson(serverTime: DateTime.now().toUtc().toIso8601String()), 201);
          if (req.url.path.endsWith('/status')) {
            polls++;
            return j(polls < 3
                ? {'session_id': 'ars_abcdefghijkl', 'status': 'PENDING'}
                : {'session_id': 'ars_abcdefghijkl', 'status': 'VERIFIED', 'phone': '01097111104', 'phone_masked': '010****1104'});
          }
          return j({}, 404);
        })),
      );
      final r = await c.start().timeout(const Duration(seconds: 5));
      expect(dialer.dialed, ['tel:0507-1289-1030']);
      expect(r.success, isTrue);
      expect(r.phone, '01097111104');
      expect(c.phase, ArsAuthPhase.finished);
      c.dispose();
    });

    test('failure reason is returned', () async {
      final c = ArsAuthController(
        config: cfg,
        dialer: FakeDialer(),
        client: Ars2faClient(cfg, httpClient: MockClient((req) async {
          if (req.url.path.endsWith('/sessions')) return j(sessionJson(serverTime: DateTime.now().toUtc().toIso8601String()), 201);
          return j({'session_id': 'ars_abcdefghijkl', 'status': 'FAILED', 'fail_reason': 'multiple_calls'});
        })),
      );
      final r = await c.start().timeout(const Duration(seconds: 5));
      expect(r.success, isFalse);
      expect(r.reason, 'multiple_calls');
      expect(r.message, contains('여러 통'));
      c.dispose();
    });

    test('API error (no number) and dial failure', () async {
      final c1 = ArsAuthController(
        config: cfg,
        dialer: FakeDialer(),
        client: Ars2faClient(cfg, httpClient: MockClient((req) async => j({'statusCode': 503, 'message': 'NO_NUMBER_AVAILABLE'}, 503))),
      );
      final r1 = await c1.start();
      expect(r1.errorCode, 'NO_NUMBER_AVAILABLE');
      c1.dispose();

      final calls = <String>[];
      final c2 = ArsAuthController(
        config: cfg,
        dialer: FakeDialer(false),
        client: Ars2faClient(cfg, httpClient: MockClient((req) async {
          calls.add(req.url.path);
          if (req.url.path.endsWith('/sessions')) return j(sessionJson(), 201);
          return j({'session_id': 'ars_abcdefghijkl', 'status': 'CANCELED', 'fail_reason': 'canceled_by_client'});
        })),
      );
      final r2 = await c2.start();
      expect(r2.reason, 'dial_failed');
      expect(calls, contains('/v1/ars/sessions/cancel'));
      c2.dispose();
    });

    test('user cancel calls the cancel API', () async {
      final calls = <String>[];
      final c = ArsAuthController(
        config: cfg,
        dialer: FakeDialer(),
        client: Ars2faClient(cfg, httpClient: MockClient((req) async {
          calls.add(req.url.path);
          if (req.url.path.endsWith('/sessions')) return j(sessionJson(serverTime: DateTime.now().toUtc().toIso8601String()), 201);
          if (req.url.path.endsWith('/cancel')) return j({'session_id': 'ars_abcdefghijkl', 'status': 'CANCELED'});
          return j({'session_id': 'ars_abcdefghijkl', 'status': 'PENDING'});
        })),
      );
      final f = c.start();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await c.cancel();
      final r = await f;
      expect(r.reason, 'canceled_by_client');
      expect(calls, contains('/v1/ars/sessions/cancel'));
      c.dispose();
    });
  });
}
