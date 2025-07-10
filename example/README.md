# ARS 로그인 패키지 예제 앱

이 앱은 `ars_login` 패키지의 사용법을 보여주는 예제 앱입니다.

## 📱 기능

- **ARS 로그인**: 투채널 폰인증 ARS 시스템을 통한 안전한 자동인증
- **권한 관리**: 앱에서 필요한 권한들을 관리하고 요청
- **사용자 정보 확인**: 로그인된 사용자의 정보를 확인

## 🚀 실행 방법

### 1. 의존성 설치
```bash
cd example
flutter pub get
```

### 2. 앱 실행
```bash
# Android 실행
flutter run

# iOS 실행 (macOS에서만)
flutter run -d ios

# 특정 디바이스에서 실행
flutter devices  # 연결된 디바이스 확인
flutter run -d [device-id]
```

### 3. APK 빌드
```bash
# 디버그 APK 빌드
flutter build apk --debug

# 릴리즈 APK 빌드
flutter build apk --release
```

## 📋 필요한 권한

앱에서 다음 권한들을 사용합니다:

### Android
- `RECORD_AUDIO`: 음성인식 기능
- `CALL_PHONE`: 전화 걸기
- `READ_PHONE_STATE`: 전화 상태 감지
- `READ_CONTACTS`: 연락처 검색
- `CAMERA`: QR 코드 스캔
- `ACCESS_FINE_LOCATION`: 위치 기반 서비스
- `READ_EXTERNAL_STORAGE`: 파일 읽기
- `WRITE_EXTERNAL_STORAGE`: 파일 쓰기
- `INTERNET`: 네트워크 통신

### iOS
- `NSMicrophoneUsageDescription`: 마이크 접근
- `NSCameraUsageDescription`: 카메라 접근
- `NSContactsUsageDescription`: 연락처 접근
- `NSLocationWhenInUseUsageDescription`: 위치 접근
- `NSPhotoLibraryUsageDescription`: 사진 라이브러리 접근

## 🔧 주요 구성 요소

### 1. 메인 화면 (`main.dart`)
- 로그인 상태 표시
- ARS 로그인 시작 버튼
- 권한 관리 버튼
- 사용자 정보 확인 버튼

### 2. ARS 로그인 화면
- 약관 동의 체크박스들
- ARS 인증 프로세스 시작
- 권한 요청 및 확인

### 3. 권한 관리 화면
- 필요한 권한들의 설명
- 권한 요청 실행

### 4. 로그인 완료 화면
- 인증 성공 표시
- 사용자 전화번호 및 추천인 정보 표시

## 💡 사용법

1. **앱 시작**: 메인 화면에서 현재 로그인 상태를 확인할 수 있습니다.

2. **권한 설정**: "권한 관리" 버튼을 눌러 필요한 권한들을 허용합니다.

3. **ARS 로그인**: 
   - "ARS 로그인 시작" 버튼을 누릅니다
   - 약관들에 동의합니다 (필수 약관들은 모두 체크해야 합니다)
   - "ARS 인증 시작" 버튼을 누릅니다
   - 자동으로 전화가 걸리고 통화 종료 후 인증이 완료됩니다

4. **사용자 정보 확인**: "사용자 정보 확인" 버튼으로 저장된 정보를 확인할 수 있습니다.

## ⚠️ 주의사항

- **실제 전화 연결**: ARS 인증은 실제 전화번호로 연결되므로 테스트 시 주의하세요.
- **권한 필요**: 대부분의 기능이 시스템 권한을 필요로 하므로 권한을 허용해야 합니다.
- **네트워크 연결**: 인증 서버와의 통신을 위해 인터넷 연결이 필요합니다.

## 🔗 관련 링크

- [ARS 로그인 패키지 소스코드](../)
- [Flutter 공식 문서](https://docs.flutter.dev/)
- [Riverpod 문서](https://riverpod.dev/)

## 🐛 문제 해결

### 빌드 오류
- `flutter clean && flutter pub get`을 실행해보세요
- Android NDK 버전 경고는 무시해도 됩니다

### 권한 관련 오류
- Android: `android/app/src/main/AndroidManifest.xml` 확인
- iOS: `ios/Runner/Info.plist` 확인

### 네트워크 오류
- 인터넷 연결 상태를 확인하세요
- Android에서 HTTP 통신 허용 설정을 확인하세요
