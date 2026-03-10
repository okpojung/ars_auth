# WebView 빈 화면 문제 해결 가이드

## 🐛 문제 증상
- 약관 동의 화면에서 "이용약관" 또는 "개인정보 처리방침" 클릭 시 빈 화면만 표시됨
- WebView가 로딩은 되지만 내용이 보이지 않음

## 🔍 원인 분석

### 1. **네트워크 보안 정책 (Android 9+)**
Android 9 (API 28) 이상에서는 기본적으로 HTTP 통신이 차단됩니다.
HTTPS URL이더라도 일부 리소스가 HTTP인 경우 차단될 수 있습니다.

### 2. **WebView 설정 문제**
- `transparentBackground` 설정으로 인한 렌더링 이슈
- 캐시 설정 문제
- JavaScript 실행 오류

### 3. **iOS App Transport Security (ATS)**
iOS에서는 ATS 정책으로 인해 특정 도메인의 HTTP 통신이 차단될 수 있습니다.

## ✅ 적용된 해결 방법

### 1. WebView 설정 개선 (`lib/widgets/terms.dart`)

```dart
// 변경 전
transparentBackground: true,

// 변경 후
transparentBackground: false,
backgroundColor: Colors.white,
useHybridComposition: true,
clearCache: false,
cacheEnabled: true,
mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
```

### 2. 에러 처리 추가

```dart
// 로딩 완료 후 실제 내용 확인
onLoadStop: (controller, url) async {
  final html = await controller.evaluateJavascript(
    source: 'document.body.innerHTML',
  );
  if (html == null || html.toString().isEmpty) {
    setState(() {
      errorMessage = '페이지 내용을 불러올 수 없습니다.';
    });
  }
}

// HTTP 에러 처리
onReceivedHttpError: (controller, request, errorResponse) {
  setState(() {
    errorMessage = 'HTTP 에러: ${errorResponse.statusCode}';
  });
}
```

### 3. Android 네트워크 보안 설정

**파일**: `example/android/app/src/main/res/xml/network_security_config.xml`

```xml
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <base-config cleartextTrafficPermitted="false">
        <trust-anchors>
            <certificates src="system" />
        </trust-anchors>
    </base-config>
    
    <domain-config cleartextTrafficPermitted="true">
        <domain includeSubdomains="true">mobile.barosvc.com</domain>
        <domain includeSubdomains="true">barocall.baro.so</domain>
    </domain-config>
</network-security-config>
```

**AndroidManifest.xml** 수정:
```xml
<application
    android:networkSecurityConfig="@xml/network_security_config"
    android:usesCleartextTraffic="true">
```

### 4. iOS ATS 설정

**파일**: `example/ios/Runner/Info.plist`

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <false/>
    <key>NSExceptionDomains</key>
    <dict>
        <key>mobile.barosvc.com</key>
        <dict>
            <key>NSIncludesSubdomains</key>
            <true/>
            <key>NSExceptionAllowsInsecureHTTPLoads</key>
            <true/>
        </dict>
    </dict>
</dict>
```

### 5. 디버깅 로그 추가

```dart
onWebViewCreated: (controller) {
  print('✅ WebView 생성됨: ${widget.termsType.url}');
}

onLoadStart: (controller, url) {
  print('🔄 로딩 시작: $url');
}

onLoadStop: (controller, url) async {
  print('✅ 로딩 완료: $url');
}

onReceivedError: (controller, request, error) {
  print('❌ WebView 에러: ${error.description}');
}

onConsoleMessage: (controller, consoleMessage) {
  print('🖥️ [Console] ${consoleMessage.message}');
}
```

## 🔧 문제 해결 체크리스트

### Android
- [x] `INTERNET` 권한 확인 (AndroidManifest.xml)
- [x] `network_security_config.xml` 생성
- [x] AndroidManifest에 네트워크 보안 설정 추가
- [x] `usesCleartextTraffic="true"` 추가

### iOS
- [x] Info.plist에 ATS 설정 추가
- [x] 예외 도메인 설정 (`mobile.barosvc.com`, `barocall.baro.so`)

### Flutter 코드
- [x] WebView 설정 최적화
- [x] 에러 핸들링 추가
- [x] 디버깅 로그 추가
- [x] 에러 UI 추가

## 🧪 테스트 방법

### 1. 로그 확인
```bash
# Android
flutter run --verbose
adb logcat | grep -E "WebView|Console"

# iOS
flutter run --verbose
# Xcode Console에서 로그 확인
```

### 2. 테스트 순서
1. 앱 실행
2. "약관동의" 섹션에서 "이용약관" 클릭
3. WebView 화면이 표시되는지 확인
4. 로그에서 에러 메시지 확인
5. "개인정보 처리방침"도 동일하게 테스트

### 3. 예상 로그
```
✅ WebView 생성됨: https://mobile.barosvc.com/info/use_info2.html
🔄 로딩 시작: https://mobile.barosvc.com/info/use_info2.html
📊 로딩 진행: 50%
📊 로딩 진행: 100%
✅ 로딩 완료: https://mobile.barosvc.com/info/use_info2.html
```

## 🚨 추가 문제 발생 시

### 1. 여전히 빈 화면인 경우
```dart
// terms.dart의 onLoadStop에서 HTML 내용 출력
onLoadStop: (controller, url) async {
  final html = await controller.evaluateJavascript(
    source: 'document.body.innerHTML',
  );
  print('📄 HTML 내용: $html');
}
```

### 2. SSL 인증서 오류
```dart
// WebView 설정에 추가 (개발 환경만!)
onReceivedSslError: (controller, error) async {
  // 개발 환경에서만 SSL 에러 무시 (프로덕션에서는 절대 사용 금지!)
  if (kDebugMode) {
    return SslErrorAction.PROCEED;
  }
  return SslErrorAction.CANCEL;
}
```

### 3. 네트워크 연결 확인
```dart
import 'package:connectivity_plus/connectivity_plus.dart';

final connectivityResult = await Connectivity().checkConnectivity();
if (connectivityResult == ConnectivityResult.none) {
  print('❌ 네트워크 연결 없음');
}
```

## 📱 플랫폼별 주의사항

### Android
- minSdkVersion 21 이상 필요
- Android 9 (API 28) 이상에서는 네트워크 보안 설정 필수
- 일부 중국 제조사 기기에서는 추가 권한 필요 가능

### iOS
- iOS 12.0 이상 필요
- 시뮬레이터에서는 일부 기능 제한
- ATS 설정 누락 시 네트워크 요청 차단

## 🔗 관련 URL
- 이용약관: https://mobile.barosvc.com/info/use_info2.html
- 개인정보 처리방침: https://mobile.barosvc.com/info/privacy2.html

## 📝 변경 파일 목록
1. `lib/widgets/terms.dart` - WebView 설정 및 에러 처리 개선
2. `example/android/app/src/main/AndroidManifest.xml` - 네트워크 보안 설정 추가
3. `example/android/app/src/main/res/xml/network_security_config.xml` - 신규 생성
4. `example/ios/Runner/Info.plist` - ATS 설정 추가

## 🎯 다음 단계
1. 앱 재빌드: `flutter clean && flutter pub get`
2. 실제 기기에서 테스트
3. 로그 확인하여 추가 문제 진단
4. 필요시 네트워크 패킷 분석 (Charles Proxy, Wireshark)
