import 'package:flutter/foundation.dart';

/// 무결성 증명 (Play Integrity 토큰 또는 App Attest assertion).
class IntegrityProof {
  const IntegrityProof._(this._fields);

  /// Android: [nonce]로 요청한 Play Integrity 토큰.
  factory IntegrityProof.android({required String nonce, required String token}) =>
      IntegrityProof._({'integrity_nonce': nonce, 'integrity_token': token});

  /// iOS: 등록된 App Attest 키로 [nonce]에 대해 만든 assertion(base64).
  factory IntegrityProof.ios({required String nonce, required String keyId, required String assertion}) =>
      IntegrityProof._({'integrity_nonce': nonce, 'attest_key_id': keyId, 'attest_assertion': assertion});

  final Map<String, String> _fields;
  Map<String, String> toJson() => Map.of(_fields);
}

/// 서버가 준 nonce로 무결성 증명을 만들어 돌려주는 호스트 앱 콜백.
/// null을 돌려주면 증명 없이 진행합니다 (서버 정책이 ENFORCE면 거절됨).
typedef IntegrityProvider = Future<IntegrityProof?> Function(String nonce);

/// SDK 설정.
class Ars2faConfig {
  const Ars2faConfig({
    required this.apiKey,
    required this.mobileAppName,
    this.packageName,
    this.bundleId,
    this.platform,
    this.baseUrl = 'https://ars2fa.baro.me',
    this.purpose,
    this.expectedPhone,
    this.appsid,
    this.type,
    this.integrityProvider,
    this.pollInterval = const Duration(milliseconds: 1500),
    this.requestTimeout = const Duration(seconds: 15),
    this.useDirectCall = true,
  });

  /// 발급받은 API Key. 소스에 그대로 넣지 말고 빌드 설정/원격 설정으로 주입하세요.
  final String apiKey;

  /// 신청 시 등록한 앱 이름 (mobile_app_name).
  final String mobileAppName;

  /// Android 패키지명 (등록값과 같아야 함).
  final String? packageName;

  /// iOS 번들 ID (등록값과 같아야 함).
  final String? bundleId;

  /// 'ANDROID' | 'IOS'. 생략하면 실행 플랫폼으로 정함.
  final String? platform;

  final String baseUrl;

  /// 인증 목적 (40자 이내, 관리 화면에 표시).
  final String? purpose;

  /// 이미 아는 회원 번호를 확인할 때만. 다른 번호로 걸면 phone_mismatch.
  final String? expectedPhone;
  final String? appsid;

  /// 통화 방식. 0 = 1번 누르기 없이 연결되면 바로 완료, 1 = 안내 후 1번 누르기.
  /// null이면 ars2fa 콘솔의 앱 설정을 따릅니다.
  final int? type;
  final IntegrityProvider? integrityProvider;
  final Duration pollInterval;
  final Duration requestTimeout;

  /// Android: 전화 권한(CALL_PHONE)을 요청해 허용되면 다이얼러를 거치지 않고 바로 발신합니다.
  /// 거부되면 다이얼러가 열리고 사용자가 통화 버튼을 누릅니다. false면 항상 다이얼러.
  final bool useDirectCall;

  String get clientPlatform =>
      platform ?? (defaultTargetPlatform == TargetPlatform.iOS ? 'IOS' : 'ANDROID');

  /// 모든 요청에 붙는 앱 식별 정보 (api_key 는 Authorization 헤더로 보냄).
  Map<String, dynamic> identity() => {
        'mobile_app_name': mobileAppName,
        'client_platform': clientPlatform,
        if (clientPlatform == 'ANDROID' && packageName != null) 'package_name': packageName,
        if (clientPlatform == 'IOS' && bundleId != null) 'bundle_id': bundleId,
      };
}
