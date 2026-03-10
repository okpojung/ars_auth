# ARS Login Package

한국의 ARS(자동응답시스템) 인증을 위한 Flutter 패키지입니다.

## 🆕 v1.2.0 업데이트 (2026-03)

- **📱 로컬 HTML 전환**: 약관/개인정보처리방침을 네트워크에서 로컬 assets으로 변경
- **🎨 폰트 최적화**: HTML 폰트 크기 및 WebView 설정 최적화
- **🔧 WebView 안정화**: 빈 화면 문제 해결 및 에러 처리 강화
- **🌐 네트워크 보안**: Android 9+ 및 iOS ATS 설정 추가
- **📚 문서 개선**: 상세한 트러블슈팅 가이드 추가
- **⚡ 오프라인 지원**: 네트워크 없이도 약관 표시 가능

## 🆕 v1.1.0 업데이트 (2024-01)

- **🔥 Breaking Changes**: Hive 로컬 저장소 의존성 제거
- **⚡ 경량화**: 콜백 전용 아키텍처로 전환하여 패키지 크기 감소
- **🎯 유연성 향상**: 데이터 저장 방법을 개발자가 직접 선택 가능
- **📱 새로운 옵션**: `useOnlyCallPermission` 프로퍼티 추가
- **🐛 버그 수정**: iOS/Android 플랫폼별 권한 처리 개선

### 📱 v1.1.0 마이그레이션 가이드

**이전 (v1.0.x):**
```dart
// 자동으로 Hive에 데이터 저장됨
const LoginARS()
```

**현재 (v1.1.0+):**
```dart
// 콜백을 통해 데이터를 받아 원하는 방식으로 저장
LoginARS(
  onAuthComplete: (userInfo) {
    // SharedPreferences 사용
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('phoneNumber', userInfo['app_cid']);
    });
    
    // 또는 Hive 사용
    // Hive.box('user').put('phoneNumber', userInfo['app_cid']);
    
    // 또는 서버에 저장
    // ApiService.saveUserInfo(userInfo);
  },
)
```

## ✨ 주요 기능

- 🔐 **ARS 자동 인증**: 전화 수신을 통한 자동 인증
- 📱 **수동 전화번호 입력**: ARS 실패 시 수동 인증 지원  
- 📋 **약관 동의 UI**: 이용약관 및 개인정보처리방침 동의 (로컬 HTML)
- 🌐 **오프라인 지원**: 네트워크 없이도 약관 표시
- 🔒 **권한 관리**: 필요한 권한들의 자동 요청 및 관리
- 🎨 **콜백 전용**: 완전한 콜백 기반 데이터 처리
- 📱 **Portrait 모드 고정**: 화면 회전 시 UI 깨짐 방지
- ⚡ **경량화**: Hive 의존성 제거로 패키지 크기 최적화
- 🎯 **폰트 최적화**: 약관 페이지 가독성 개선

## 📋 요구사항

- **Flutter**: >= 1.17.0
- **Dart**: ^3.7.2
- **Android**: API 21+ (Android 5.0+)
- **iOS**: 12.0+

## 🚀 설치

### 1. 종속성 추가

```yaml
dependencies:
  flutter_riverpod: ^2.6.1  # 필수!
  ars_login:
    git:
      url: https://github.com/okpojung/ars_auth.git
      ref: main  # 또는 특정 커밋: 060b1bc
```

### 2. 패키지 설치

```bash
flutter pub get
```

## ⚙️ 필수 설정

### 1. Riverpod 설정 (꼭 필요!)

```dart
// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp())); // ProviderScope 필수!
}
```

### 2. Android 권한 설정

`android/app/src/main/AndroidManifest.xml`:
```xml
<manifest>
  <!-- 필수 권한 -->
  <uses-permission android:name="android.permission.CALL_PHONE" />
  <uses-permission android:name="android.permission.READ_PHONE_STATE" />
  <uses-permission android:name="android.permission.INTERNET" />
  
  <application
    android:networkSecurityConfig="@xml/network_security_config"
    android:usesCleartextTraffic="true">
    <!-- ... -->
  </application>
</manifest>
```

네트워크 보안 설정 파일 생성:
`android/app/src/main/res/xml/network_security_config.xml`
```xml
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <base-config cleartextTrafficPermitted="true">
        <trust-anchors>
            <certificates src="system" />
        </trust-anchors>
    </base-config>
    <domain-config cleartextTrafficPermitted="true">
        <domain includeSubdomains="true">mobile.barosvc.com</domain>
    </domain-config>
</network-security-config>
```

### 3. iOS 권한 설정

`ios/Runner/Info.plist`:
```xml
<dict>
  <!-- 기본 권한 설명 -->
  <key>NSMicrophoneUsageDescription</key>
  <string>ARS 인증을 위해 마이크 권한이 필요합니다.</string>
  <key>NSContactsUsageDescription</key>
  <string>연락처 접근을 위해 권한이 필요합니다.</string>
  
  <!-- ATS (App Transport Security) 예외 설정 -->
  <key>NSAppTransportSecurity</key>
  <dict>
    <key>NSAllowsArbitraryLoads</key>
    <false/>
    <key>NSExceptionDomains</key>
    <dict>
      <key>mobile.barosvc.com</key>
      <dict>
        <key>NSExceptionAllowsInsecureHTTPLoads</key>
        <true/>
        <key>NSIncludesSubdomains</key>
        <true/>
      </dict>
    </dict>
  </dict>
</dict>
```

## 📖 사용법

### 기본 사용 (자동 화면 이동)

```dart
import 'package:ars_login/ars_login.dart';

// 기본 ARS 로그인 - 모든 권한 요청
const LoginARS()

// 통화 권한만 요청 (마이크, 연락처 권한 제외)
const LoginARS(useOnlyCallPermission: true)
```

### 콜백과 함께 사용 (커스텀 처리) - **v1.1.0 권장**

```dart
LoginARS(
  useOnlyCallPermission: true, // 통화 권한만 요청
  onAuthStart: () {
    print('🚀 ARS 인증 시작');
    // 로딩 UI 표시 등
  },
  onAuthComplete: (response) {
    print('✅ 인증 완료!');
    print('전화번호: ${response['app_cid']}');
    print('앱 UUID: ${response['appuuid']}');
    print('추천인: ${response['prnts_phone_no'] ?? '없음'}');
    
    // 데이터 저장 방법 선택:
    
    // 1. SharedPreferences 사용
    _saveToSharedPreferences(response);
    
    // 2. Hive 사용 (별도 설치 필요)
    // _saveToHive(response);
    
    // 3. 서버에 저장
    // _saveToServer(response);
    
    // 원하는 화면으로 이동
    Navigator.pushReplacement(context, 
      MaterialPageRoute(builder: (context) => MainScreen()));
  },
  onAuthFailure: (error) {
    print('❌ 인증 실패: $error');
    showDialog(context: context, builder: (context) => 
      AlertDialog(title: Text('인증 실패'), content: Text(error)));
  },
  onManualInputRequired: () {
    print('📝 수동 입력 필요');
    // 커스텀 수동 입력 UI 표시 가능
  },
)

// SharedPreferences 저장 예시
Future<void> _saveToSharedPreferences(Map<String, dynamic> userInfo) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('phoneNumber', userInfo['app_cid']);
  await prefs.setString('appUuid', userInfo['appuuid']);
  await prefs.setString('referrer', userInfo['prnts_phone_no'] ?? '');
}
```

### 데이터 저장 방법 선택 가이드

#### 1. SharedPreferences (가장 간단)
```dart
dependencies:
  shared_preferences: ^2.2.2

// 사용법
final prefs = await SharedPreferences.getInstance();
await prefs.setString('phoneNumber', userInfo['app_cid']);
```

#### 2. Hive (빠른 로컬 저장소)
```dart
dependencies:
  hive: ^2.2.3
  hive_flutter: ^1.1.0

// 사용법
await Hive.initFlutter();
final box = await Hive.openBox('userBox');
await box.put('phoneNumber', userInfo['app_cid']);
```

#### 3. 서버 저장 (권장)
```dart
dependencies:
  dio: ^5.4.0

// 사용법
await ApiService.post('/user/save', data: userInfo);
```

## 📚 API 레퍼런스

### LoginARS 위젯

```dart
LoginARS({
  bool useOnlyCallPermission = false,          // 통화 권한만 요청 여부
  ArsAuthStartCallback? onAuthStart,           // 인증 시작 시
  ArsAuthCompleteCallback? onAuthComplete,     // 인증 완료 시  
  ArsAuthFailureCallback? onAuthFailure,       // 인증 실패 시
  ArsManualInputCallback? onManualInputRequired, // 수동 입력 필요 시
})
```

### 프로퍼티 설명

| 프로퍼티 | 타입 | 기본값 | 설명 |
|---------|------|-------|------|
| `useOnlyCallPermission` | `bool` | `false` | `true`: 통화 권한만 요청<br/>`false`: 모든 권한 요청 (통화+마이크+연락처) |
| `onAuthStart` | `Function?` | `null` | ARS 인증 시작 시 호출 |
| `onAuthComplete` | `Function?` | `null` | 인증 완료 시 호출 (userInfo 전달) |
| `onAuthFailure` | `Function?` | `null` | 인증 실패 시 호출 (error 메시지 전달) |
| `onManualInputRequired` | `Function?` | `null` | 수동 입력 필요 시 호출 |

### 콜백 함수 타입들

```dart
typedef ArsAuthStartCallback = void Function();
typedef ArsAuthCompleteCallback = void Function(Map<String, dynamic> userInfo);
typedef ArsAuthFailureCallback = void Function(String error);
typedef ArsManualInputCallback = void Function();
```

### userInfo 응답 데이터

```dart
{
  'app_cid': '01012345678',        // 사용자 전화번호
  'appuuid': 'UUID-STRING',        // 앱 고유 식별자
  'appsid': 'SESSION-ID',          // 세션 식별자  
  'now': '2024-01-01 12:00:00',    // 인증 완료 시간
  'prnts_phone_no': '01087654321', // 추천인 전화번호 (없으면 null)
}
```

## 🚀 5분 퀵스타트

### 1단계: 설치
```bash
flutter pub add flutter_riverpod shared_preferences
```

```yaml
# pubspec.yaml
dependencies:
  ars_login:
    git:
      url: https://github.com/okpojung/ars_auth.git
```

### 2단계: main.dart 설정
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ars_login/ars_login.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => 
                LoginARS(
                  useOnlyCallPermission: true, // 권한 최소화
                  onAuthComplete: (userInfo) {
                    // 데이터 저장 및 화면 이동
                    print('인증 완료: $userInfo');
                  },
                ))),
            child: const Text('ARS 로그인'),
          ),
        ),
      ),
    );
  }
}
```

### 3단계: 권한 설정 (위의 Android/iOS 설정 참조)

### 4단계: 실행!
```bash
flutter run
```

**끝!** 🎉 이제 ARS 로그인이 작동합니다.

## ⚠️ 중요 사항

### 필수 종속성
- **flutter_riverpod**: 상태관리를 위해 반드시 필요
- **ProviderScope**: main.dart에서 앱을 감싸야 함

### 자동 vs 커스텀 처리
- **콜백 없음**: 인증 완료 시 기본 완료 화면으로 자동 이동
- **콜백 있음**: 인증 완료 시 콜백 함수 호출, 커스텀 처리 가능 (v1.1.0+ 권장)

### 권한 옵션
- **useOnlyCallPermission: false** (기본값): 통화, 마이크, 연락처 권한 모두 요청
- **useOnlyCallPermission: true**: 통화 권한만 요청 (권한 최소화)

### 화면 방향 고정
- 패키지 사용 중에는 자동으로 portrait 모드로 고정
- 패키지 화면을 벗어나면 자동으로 원래 상태로 복원

### v1.1.0 데이터 저장
- **Breaking Change**: 더 이상 자동으로 로컬에 저장되지 않음
- **콜백 필수**: `onAuthComplete` 콜백에서 직접 데이터 처리 필요
- **유연성**: SharedPreferences, Hive, 서버 등 원하는 방법 선택 가능

## 🔧 문제 해결

### Q: 약관 페이지가 빈 화면으로 나와요
A: 
1. 패키지를 최신 버전으로 업데이트 (v1.2.0+)
2. `flutter pub cache clean && flutter pub get` 실행
3. 앱을 완전히 종료 후 재실행
4. 로그 확인: `🔍 로드 시도: packages/ars_login/assets/html/...`

자세한 가이드: [WEBVIEW_TROUBLESHOOTING.md](WEBVIEW_TROUBLESHOOTING.md)

### Q: 약관 페이지 폰트가 너무 크거나 작아요
A:
1. HTML 파일의 `font-size` 조정
2. WebView의 `textZoom` 설정 조정

자세한 가이드: [FONT_SIZE_GUIDE.md](FONT_SIZE_GUIDE.md)

### Q: 네트워크 에러 (ERR_CLEARTEXT_NOT_PERMITTED)가 나요
A:
1. Android: `network_security_config.xml` 파일 추가
2. iOS: `NSAppTransportSecurity` 설정 추가

자세한 가이드: [PACKAGE_ASSETS_FIX.md](PACKAGE_ASSETS_FIX.md)

### Q: "통화 기능을 사용할 수 없습니다" 에러가 나요
A: 
1. 통화 권한이 허용되었는지 확인
2. 시뮬레이터가 아닌 실제 기기에서 테스트
3. `PhoneChecker.checkPhoneCapability()`로 통화 가능 여부 확인

### Q: ARS 전화가 오지 않아요
A:
1. 네트워크 연결 상태 확인
2. 전화번호 형식이 올바른지 확인 (010-1234-5678)
3. 스팸차단 앱이 차단했는지 확인

### Q: v1.1.0 업데이트 후 데이터가 저장되지 않아요
A: 
1. `onAuthComplete` 콜백 함수를 추가했는지 확인
2. 콜백 내에서 직접 데이터 저장 로직 구현 필요
3. SharedPreferences 등 저장소 라이브러리 설치 확인

### Q: 화면이 회전하면 UI가 깨져요
A: 패키지 내부에서 portrait 모드로 자동 고정됩니다. 최신 버전 사용 확인.

### Q: ProviderScope 에러가 나요
A: main.dart에서 앱을 `ProviderScope`로 감싸는 것을 빼먹었습니다.

### Q: useOnlyCallPermission을 true로 해도 다른 권한을 요청해요
A: iOS는 시스템 설정에서 권한을 직접 설정해야 할 수 있습니다.

## 📱 플랫폼별 특이사항

### Android
- API 21+ 필수
- 통화 권한 필수
- 백그라운드 앱 종료 시 인증 실패할 수 있음
- `useOnlyCallPermission: true`로 권한 최소화 권장

### iOS 
- iOS 12.0+ 필수
- 시뮬레이터에서는 통화 기능 제한
- 앱스토어 심사 시 통화 권한 사용 이유 명시 필요
- `useOnlyCallPermission: true` 사용 시 마이크/연락처 권한 요청 안 함

## 📝 변경 이력

### v1.2.0 (2026-03-10)
- **로컬 HTML 전환**: 약관을 네트워크에서 로컬 assets으로 변경
- **WebView 최적화**: 빈 화면 문제 해결 및 에러 처리 강화
- **폰트 최적화**: HTML 폰트 크기 및 WebView textZoom 조정
- **네트워크 보안**: Android 9+ cleartext traffic 및 iOS ATS 설정 추가
- **오프라인 지원**: 인터넷 없이도 약관 표시 가능
- **문서 추가**: FONT_SIZE_GUIDE, LOCAL_HTML_GUIDE, WEBVIEW_TROUBLESHOOTING 등

### v1.1.0 (2024-01-07)
- **BREAKING CHANGE**: Hive 로컬 저장소 의존성 제거
- 콜백 전용 아키텍처로 전환
- `useOnlyCallPermission` 프로퍼티 추가
- iOS/Android 플랫폼별 권한 처리 개선
- 패키지 크기 최적화

### v1.0.0 (2024-01-01)
- 초기 릴리스
- ARS 자동 인증 기능
- Hive 기반 로컬 저장소

## 📚 추가 문서

프로젝트에는 다음과 같은 상세 가이드 문서들이 포함되어 있습니다:

- **[FONT_SIZE_GUIDE.md](FONT_SIZE_GUIDE.md)** - 약관 페이지 폰트 크기 조정 완벽 가이드
- **[LOCAL_HTML_GUIDE.md](LOCAL_HTML_GUIDE.md)** - 로컬 HTML assets 사용 가이드
- **[PACKAGE_ASSETS_FIX.md](PACKAGE_ASSETS_FIX.md)** - 패키지 assets 경로 문제 해결
- **[WEBVIEW_TROUBLESHOOTING.md](WEBVIEW_TROUBLESHOOTING.md)** - WebView 관련 문제 해결
- **[pubspec_bs_point.yaml](pubspec_bs_point.yaml)** - 사용자 앱 pubspec 예시

## 🤝 기여

기여는 언제나 환영합니다! 이슈나 PR을 자유롭게 제출해 주세요.

## 📄 라이선스

이 프로젝트는 MIT 라이선스를 따릅니다.

## 📞 지원

- **GitHub Issues**: https://github.com/okpojung/ars_auth/issues
- **Pull Requests**: https://github.com/okpojung/ars_auth/pulls
