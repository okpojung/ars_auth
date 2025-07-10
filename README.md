# ARS Login Package

한국의 ARS(자동응답시스템) 인증을 위한 Flutter 패키지입니다.

## ✨ 주요 기능

- 🔐 **ARS 자동 인증**: 전화 수신을 통한 자동 인증
- 📱 **수동 전화번호 입력**: ARS 실패 시 수동 인증 지원  
- 📋 **약관 동의 UI**: 이용약관 및 개인정보처리방침 동의
- 🔒 **권한 관리**: 필요한 권한들의 자동 요청 및 관리
- 🎨 **커스터마이징**: 콜백 함수를 통한 완전한 커스텀 처리
- 📱 **Portrait 모드 고정**: 화면 회전 시 UI 깨짐 방지

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
      url: https://github.com/your-username/ars_login.git
      ref: main
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
<uses-permission android:name="android.permission.CALL_PHONE" />
<uses-permission android:name="android.permission.READ_PHONE_STATE" />
<uses-permission android:name="android.permission.INTERNET" />
```

### 3. iOS 권한 설정

`ios/Runner/Info.plist`:
```xml
<key>NSMicrophoneUsageDescription</key>
<string>ARS 인증을 위해 마이크 권한이 필요합니다.</string>
<key>NSContactsUsageDescription</key>
<string>연락처 접근을 위해 권한이 필요합니다.</string>
```

## 📖 사용법

### 기본 사용 (자동 화면 이동)

```dart
import 'package:ars_login/ars_login.dart';

// 기본 ARS 로그인
// 인증 완료 시 자동으로 완료 화면으로 이동
const LoginARS()
```

### 콜백과 함께 사용 (커스텀 처리)

```dart
LoginARS(
  onAuthStart: () {
    print('🚀 ARS 인증 시작');
    // 로딩 UI 표시 등
  },
  onAuthComplete: (response) {
    print('✅ 인증 완료!');
    print('전화번호: ${response['app_cid']}');
    print('앱 UUID: ${response['appuuid']}');
    print('추천인: ${response['prnts_phone_no'] ?? '없음'}');
    
    // 사용자 정의 로직
    saveUserData(response);
    
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
```

## 📚 API 레퍼런스

### LoginARS 위젯

```dart
LoginARS({
  ArsAuthStartCallback? onAuthStart,           // 인증 시작 시
  ArsAuthCompleteCallback? onAuthComplete,     // 인증 완료 시  
  ArsAuthFailureCallback? onAuthFailure,       // 인증 실패 시
  ArsManualInputCallback? onManualInputRequired, // 수동 입력 필요 시
})
```

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
flutter pub add flutter_riverpod
```

```yaml
# pubspec.yaml
dependencies:
  ars_login:
    git:
      url: https://github.com/your-username/ars_login.git
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
              MaterialPageRoute(builder: (context) => const LoginARS())),
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
- **콜백 있음**: 인증 완료 시 콜백 함수 호출, 커스텀 처리 가능

### 화면 방향 고정
- 패키지 사용 중에는 자동으로 portrait 모드로 고정
- 패키지 화면을 벗어나면 자동으로 원래 상태로 복원

## 🔧 문제 해결

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

### Q: 화면이 회전하면 UI가 깨져요
A: 패키지 내부에서 portrait 모드로 자동 고정됩니다. 최신 버전 사용 확인.

### Q: ProviderScope 에러가 나요
A: main.dart에서 앱을 `ProviderScope`로 감싸는 것을 빼먹었습니다.

## 📱 플랫폼별 특이사항

### Android
- API 21+ 필수
- 통화 권한 필수
- 백그라운드 앱 종료 시 인증 실패할 수 있음

### iOS 
- iOS 12.0+ 필수
- 시뮬레이터에서는 통화 기능 제한
- 앱스토어 심사 시 통화 권한 사용 이유 명시 필요

## 📱 예제

완전한 예제는 [example](./example/) 폴더를 참조하세요.

## 📄 라이센스

이 프로젝트는 MIT 라이센스 하에 배포됩니다.

## 📝 변경사항

[CHANGELOG.md](CHANGELOG.md) 참조

## 🤝 기여하기

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request
