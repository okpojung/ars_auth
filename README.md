# ars_login (ars2fa 발신 ARS 인증 SDK) 2.0

앱에서 **[ARS 인증] 버튼 하나로** 휴대폰 본인 번호를 확인하는 Flutter SDK입니다.

1. SDK가 ars2fa 서버(`https://ars2fa.baro.me`)에 인증을 요청하면, 서버가 이번 인증에만 쓸 0507 번호를 빌려줍니다(30초).
2. SDK가 그 번호로 **바로 전화를 겁니다.** 번호는 어느 화면에도 표시하지 않습니다.
3. 통화가 연결되면 음성 안내에 따라 진행합니다. 서버의 앱별 설정(`confirm_key`)이 켜져 있으면 대기 화면에 "안내가 나오면 1번을 누르세요", 꺼져 있으면 "전화가 연결되면 잠시 기다려 주세요"가 표시됩니다.
4. 서버는 **통신사 기록(발신번호)**으로 휴대폰 번호를 확인하고, SDK는 결과(성공 시 번호)를 앱에 돌려줍니다.

사용자는 번호를 입력하지 않습니다. 발신번호 숨김·유선전화·같은 번호로 2통 이상 걸린 경우 등은 실패합니다.

> 1.x(구 `install_app.php` / `confirm_auth.php`, 약관·권한 화면 포함)와 호환되지 않습니다. 아래 [1.x에서 옮기기](#1x에서-옮기기)를 보세요.

## 설치

```yaml
dependencies:
  ars_login:
    git:
      url: https://github.com/okpojung/ars_auth.git
      ref: main
```

### Android

`android/app/src/main/AndroidManifest.xml`

```xml
<uses-permission android:name="android.permission.INTERNET" />
<!-- 필수(권장): 버튼을 누르면 바로 발신 -->
<uses-permission android:name="android.permission.CALL_PHONE" />

<queries>
  <intent>
    <action android:name="android.intent.action.DIAL" />
    <data android:scheme="tel" />
  </intent>
</queries>
```

- 인증 버튼을 누르면 **바로 발신**합니다(번호가 화면에 머물지 않음). 처음 한 번은 시스템이 **전화 권한 창**을 띄우고, 허용하면 그대로 발신합니다.
- 필요한 권한은 `CALL_PHONE` 하나입니다(`READ_PHONE_STATE` 불필요).
- 사용자가 권한을 거부하면 다이얼러가 열리고 사용자가 통화 버튼을 누릅니다.
- 권한을 묻지 않게 하려면 `ArsAuthController(dialer: DefaultArsDialer(requestPermission: false))`, 항상 다이얼러를 쓰려면 `useDirectCall: false`.

### iOS

`ios/Runner/Info.plist`

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>tel</string>
</array>
```

iOS는 시스템이 "전화 걸기" 확인 창을 띄웁니다. 창에 번호가 보이는 것은 iOS 정책상 막을 수 없습니다.

## 사용

```dart
import 'package:ars_login/ars_login.dart';

const config = Ars2faConfig(
  apiKey: String.fromEnvironment('ARS2FA_API_KEY'), // 소스에 직접 쓰지 마세요
  mobileAppName: 'BS Point',                        // 신청 시 등록한 앱 이름
  packageName: 'com.example.bspoint',              // Android (등록값과 같아야 함)
  bundleId: 'com.example.bsPoint',                 // iOS (등록값과 같아야 함)
  purpose: '로그인',                                // 선택, 40자 이내
);

// 1) 가장 간단: 화면을 띄우고 결과 받기
final result = await Ars2fa.authenticate(context, config);
if (result != null && result.success) {
  print(result.phoneMasked); // 010****1104
  // result.phone (01097111104) 은 서버로 보내 회원 확인에 쓰세요.
}

// 2) 위젯으로 직접 배치
LoginARS(
  config: config,
  autoStart: false,          // true면 화면이 열리자마자 발신
  onAuthStart: () {},
  onAuthComplete: (r) { /* r.phone */ },
  onAuthFailure: (r) { /* r.reason, r.errorCode, r.message */ },
);

// 3) UI 없이 (자체 화면을 만들 때)
final c = ArsAuthController(config: config);
c.addListener(() { /* c.phase, c.remaining */ });
final r = await c.start();   // 취소: c.cancel()
```

이미 아는 회원의 번호가 맞는지만 확인하려면 `expectedPhone: '01012345678'`을 넣으세요. 다른 번호로 걸면 `phone_mismatch`로 실패합니다.

### 통화 방식 `type`

| `type` | 통화 흐름 |
|---|---|
| `0` | 연결되면 바로 판정 → "발신 ARS 인증 서비스입니다. 휴대폰 인증이 완료되었습니다. 감사합니다." (약 7초) |
| `1` | "발신 ARS 인증 서비스입니다. 휴대폰 인증을 하시려면 1번을 누르세요." → 1번 → "인증이 완료되었습니다. 감사합니다." |
| 생략 | ars2fa 콘솔의 앱 설정(1번 누르기 켜기/끄기)을 따름 |

`Ars2faConfig(type: 0, ...)`처럼 설정합니다.

## 결과 `ArsResult`

| 필드 | 설명 |
|---|---|
| `success` | 인증 성공 여부 |
| `phone` | 통신사가 확인한 휴대폰 번호(숫자만). 성공 시에만 |
| `phoneMasked` | `010****1104` |
| `sessionId` | `ars_...` (고객 서버에서 상태 재확인 시 사용) |
| `reason` | 실패 사유 코드 (아래) |
| `errorCode` | API 오류 코드 (아래) |
| `message` | 사용자에게 보여줄 한국어 문구 |

### 실패 사유 `reason`

| 코드 | 뜻 |
|---|---|
| `hidden_caller` | 발신번호 숨김 |
| `not_mobile` | 휴대폰이 아님 |
| `not_confirmed` | 안내에 따라 1번을 누르지 않음 |
| `no_authlog` | 통신사 기록 없음 |
| `no_session` | 진행 중인 인증 없음 |
| `multiple_calls` | 같은 번호로 2통 이상(다른 사람이 먼저 걸었을 수 있음) |
| `second_call` | 이미 처리된 인증 |
| `phone_mismatch` | `expectedPhone`과 다른 번호 |
| `timeout` | 시간 초과(전화하지 않음) |
| `canceled_by_client` | 사용자가 취소 |
| `pool_mismatch` | 회선 불일치 |
| `dial_failed` | (SDK) 전화를 걸 수 없음 |

### API 오류 `errorCode`

| 코드 | 뜻 |
|---|---|
| `NO_NUMBER_AVAILABLE` (503) | 빌려줄 번호가 없음(요청 폭주). 잠시 후 재시도 |
| `CARRIER_UNAVAILABLE` (503) | 통신사 착신 설정 실패. 잠시 후 재시도 |
| `APP_INTEGRITY_FAILED` | 앱 무결성 확인 실패(서버 정책 ENFORCE) |
| `HTTP_401` / `HTTP_403` | API Key·앱 이름·패키지명 불일치, 키 중지 |
| `NETWORK_ERROR` | 네트워크 오류 |

## 앱 위조 방지 (선택)

서버가 앱별로 `OFF / MONITOR / ENFORCE` 정책을 둡니다. 증명을 넣으려면 `integrityProvider`를 주세요. SDK가 1회용 nonce를 받아 넘겨 줍니다.

```dart
Ars2faConfig(
  ...,
  integrityProvider: (nonce) async {
    // Android: Play Integrity (예: 공식 Integrity API를 플랫폼 채널로 호출)
    final token = await myPlayIntegrity.requestToken(nonce: nonce);
    return IntegrityProof.android(nonce: nonce, token: token);

    // iOS: App Attest — 설치 후 1회 키 등록:
    //   final n = await Ars2faClient(config).integrityChallenge();
    //   await Ars2faClient(config).registerIosAttestKey(keyId: keyId, attestation: att, nonce: n);
    // 이후 매 인증:
    //   final assertion = await myAppAttest.generateAssertion(keyId, clientDataHash: sha256(nonce));
    //   return IntegrityProof.ios(nonce: nonce, keyId: keyId, assertion: assertion);
  },
);
```

`null`을 돌려주면 증명 없이 진행합니다(정책이 ENFORCE면 거절).

## 보안 안내

- 0507 번호는 SDK 화면·로그 어디에도 표시하지 않습니다. 번호를 앱 화면에 보여주지 마세요(먼저 걸어 가로채는 공격 방지).
- `toString()`은 번호를 가립니다. 전체 번호(`result.phone`)는 로그에 남기지 마세요.
- API Key는 Authorization 헤더로만 보냅니다. 앱에 키가 들어가면 추출될 수 있으므로 원격 설정/빌드 주입을 쓰고, 서버 정책(앱 무결성, 패키지명·번들 ID 등록)을 함께 켜세요.
- 결과를 고객 서버에서 다시 확인하려면 `session_id`로 `POST /v1/ars/sessions/status`를 호출하세요.

## API (참고)

| 경로 | 설명 |
|---|---|
| `POST /v1/ars/sessions` | 세션 생성(APP). `dial_uri`, `expires_at`, `server_time`, `notice`, `confirm_key`(1번 누르기 여부, 없으면 true) |
| `POST /v1/ars/sessions/status` | `PENDING / CALL_CONFIRMED / VERIFIED / FAILED / EXPIRED / CANCELED` |
| `POST /v1/ars/sessions/cancel` | 취소 |
| `POST /v1/ars/integrity/challenge` | 1회용 nonce |
| `POST /v1/ars/integrity/ios/attest` | iOS App Attest 키 등록 |

공통 본문: `mobile_app_name`, `client_platform`(ANDROID/IOS), `package_name` 또는 `bundle_id`. 헤더: `Authorization: Bearer <API Key>`.

## 1.x에서 옮기기

- `LoginARS()` → `LoginARS(config: Ars2faConfig(...))` (필수 인자 추가)
- `onAuthComplete(Map response)` → `onAuthComplete(ArsResult r)`: `response['app_cid']` 대신 `r.phone`
- `onManualInputRequired`, 약관·권한 화면, `useOnlyCallPermission`, Riverpod provider는 제거됐습니다. 약관 동의는 앱에서 처리하세요.

## 예제

`example/` — `flutter run --dart-define=ARS2FA_API_KEY=... --dart-define=ARS2FA_APP_NAME=... --dart-define=ARS2FA_PACKAGE=...`
