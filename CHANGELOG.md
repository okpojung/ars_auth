# 변경사항

## [1.0.0] - 2024-01-10

### 추가됨
- 🔐 ARS 자동 인증 기능
- 📱 수동 전화번호 입력 인증
- 📋 약관 동의 UI (이용약관, 개인정보처리방침)
- 🔒 권한 관리 시스템
- 🎨 4가지 콜백 함수 지원
  - `onAuthStart`: 인증 시작 시
  - `onAuthComplete`: 인증 완료 시  
  - `onAuthFailure`: 인증 실패 시
  - `onManualInputRequired`: 수동 입력 필요 시
- 📱 Portrait 모드 자동 고정
- 🌐 인앱 웹뷰를 통한 약관 표시
- 📞 통화 기능 확인 유틸리티
- 🔍 전화번호 형식 검증 및 포맷팅
- 💾 Hive를 통한 로컬 데이터 저장
- 🎯 Riverpod을 활용한 상태 관리

### 기술 스택
- **상태 관리**: Riverpod (annotation 기반)
- **UI**: Material Design 3
- **로컬 DB**: Hive
- **네트워크**: Dio
- **권한**: Permission Handler
- **데이터 모델**: Freezed + JSON Annotation
- **웹뷰**: InAppWebView
- **애니메이션**: Lottie

### 지원 플랫폼
- **Android**: API 21+ (Android 5.0+)
- **iOS**: 12.0+

### 알려진 제한사항
- Android 시뮬레이터에서 통화 기능 제한
- iOS 시뮬레이터에서 통화 기능 완전 제한
- 백그라운드 앱 종료 시 인증 세션 만료 가능
