# 변경사항

## [2.0.1] - 2026-11-02

### 고침
- Android: 전화 권한이 없을 때 다이얼러만 열리던 문제. 이제 권한을 먼저 요청하고 허용되면 바로 발신합니다(1.x와 같은 동작).

## [2.0.0] - 2026-10-31

ars2fa 새 API(`https://ars2fa.baro.me`, `/v1/ars/*`)로 다시 작성했습니다. **1.x와 호환되지 않습니다.**

### 바뀜
- 구 PHP 엔드포인트(`install_app.php`, `confirm_auth.php`) 제거
- 세션 생성 → 0507 번호로 즉시 발신(화면 비표시) → 상태 폴링(1.5초, 앱 복귀 시 즉시) → 결과
- 남은 시간은 서버 시계(`server_time`) 기준으로 계산
- `confirm_key`(앱별 1번 누르기 설정) 반영: 대기 화면 문구 "안내가 나오면 1번을 누르세요" / "전화가 연결되면 잠시 기다려 주세요"
- `LoginARS(config: ...)`, `Ars2fa.authenticate()`, UI 없는 `ArsAuthController`, `Ars2faClient`
- 결과 `ArsResult`(phone, phoneMasked, reason, errorCode, message)
- 선택적 앱 무결성 훅(`integrityProvider`: Play Integrity / App Attest)
- Android: CALL_PHONE 권한이 있으면 바로 발신, 없으면 다이얼러(`tel:`)

### 제거
- 약관/권한/수동 번호 입력 화면, Riverpod·Freezed·Dio·InAppWebView·Lottie 의존성, 관련 문서

## [1.1.0] - 2024-01-10

### 제거됨 🗑️
- 💾 Hive 로컬 데이터 저장 제거
- 📦 hive, hive_flutter 의존성 제거
- 🔍 isLoggedIn, userInfo provider 제거

### 변경됨 ⚡
- 🎯 패키지는 이제 콜백으로만 데이터 전달
- 📁 사용자가 원하는 방식으로 데이터 저장 가능
- 🏗️ 더 경량화된 패키지 구조

### 이유
- 패키지 사용자가 자신만의 데이터 저장 방식 선택 가능
- 불필요한 의존성 제거로 패키지 크기 감소
- confirm API 응답 데이터를 콜백으로 전달하여 유연성 증대

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
- 🎯 Riverpod을 활용한 상태 관리

### 기술 스택
- **상태 관리**: Riverpod (annotation 기반)
- **UI**: Material Design 3
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

