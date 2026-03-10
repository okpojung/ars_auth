# 📱 로컬 HTML 약관 표시 방식으로 변경

## 🎯 변경 이유

네트워크 의존 없이 안정적으로 약관을 표시하기 위해 **로컬 assets 방식**으로 변경했습니다.

### ❌ 기존 방식의 문제점
- 네트워크 연결 필요
- Android/iOS 보안 정책 (ATS, Network Security Config)
- 로딩 실패 시 빈 화면 표시
- 서버 다운 시 약관 표시 불가

### ✅ 새로운 방식의 장점
- ✅ 네트워크 불필요 (오프라인 작동)
- ✅ 100% 안정적 표시
- ✅ 빠른 로딩 속도
- ✅ 보안 정책 이슈 없음
- ✅ 약관 내용 버전 관리 가능

---

## 📂 프로젝트 구조

```
ars_login/
├── assets/
│   ├── html/
│   │   ├── privacy_policy.html      # 개인정보 처리방침
│   │   └── terms_of_service.html    # 이용약관
│   └── images/
│       └── terms.json
├── lib/
│   ├── model/
│   │   └── enum_list.dart
│   ├── res/
│   │   └── constants.dart           # URL 경로 설정
│   └── widgets/
│       └── terms.dart               # WebView 구현
└── pubspec.yaml                     # assets 등록
```

---

## 🔧 주요 변경 사항

### 1. HTML 파일 위치

```
assets/html/
├── privacy_policy.html      # 개인정보 처리방침
└── terms_of_service.html    # 이용약관
```

### 2. constants.dart 수정

```dart
// 로컬 assets 경로 (메인)
static const String termsOfServiceUrl = 'assets/html/terms_of_service.html';
static const String privacyPolicyUrl = 'assets/html/privacy_policy.html';

// 외부 URL (백업용)
static const String termsOfServiceUrlRemote = 'https://mobile.barosvc.com/info/use_info2.html';
static const String privacyPolicyUrlRemote = 'https://mobile.barosvc.com/info/privacy2.html';
```

### 3. terms.dart 수정

**로드 방식 변경**: URL 로드 → 로컬 파일 로드

```dart
// 초기화 시 로컬 HTML 로드
Future<void> _loadLocalHtml() async {
  try {
    final content = await rootBundle.loadString(widget.termsType.url);
    setState(() {
      htmlContent = content;
      isLoading = false;
    });
  } catch (e) {
    setState(() {
      errorMessage = '약관 파일을 불러올 수 없습니다.';
      isLoading = false;
    });
  }
}

// WebView 초기화 변경
InAppWebView(
  initialData: InAppWebViewInitialData(
    data: htmlContent!,
    baseUrl: WebUri('about:blank'),
  ),
  // ... 설정
)
```

### 4. pubspec.yaml 수정

```yaml
flutter:
  assets:
    - assets/images/
    - assets/html/        # ✅ 추가
```

---

## 📝 약관 내용 수정 방법

### 1. GitHub에서 로컬로 복사

```bash
git clone https://github.com/okpojung/ars_auth.git
cd ars_auth
```

### 2. HTML 파일 수정

```bash
# 개인정보 처리방침 수정
code assets/html/privacy_policy.html

# 이용약관 수정
code assets/html/terms_of_service.html
```

### 3. 변경사항 커밋 및 푸시

```bash
git add assets/html/
git commit -m "docs: 약관 내용 업데이트"
git push origin genspark_ai_developer
```

### 4. 앱 업데이트

사용자 앱에서:

```bash
flutter pub get
flutter clean
flutter run
```

---

## 🚀 사용 방법

### 패키지 사용자 (앱 개발자)

#### pubspec.yaml

```yaml
dependencies:
  flutter_riverpod: ^2.6.1
  ars_login:
    git:
      url: https://github.com/okpojung/ars_auth.git
      ref: genspark_ai_developer
```

#### 사용 예시

```dart
import 'package:ars_login/ars_login.dart';

// 약관 화면 표시
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const TermsScreen(
      termsType: TermsType.service,  // 이용약관
    ),
  ),
);

// 또는
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const TermsScreen(
      termsType: TermsType.privacy,  // 개인정보 처리방침
    ),
  ),
);
```

---

## 🔄 기존 프로젝트 마이그레이션

### 1. 새 버전 적용

```bash
flutter pub upgrade ars_login
```

### 2. 변경사항 없음!

URL 경로만 변경되었고, 사용 방식은 동일합니다:

```dart
// 기존 코드 그대로 작동
const TermsScreen(termsType: TermsType.service)
const TermsScreen(termsType: TermsType.privacy)
```

---

## 📊 비교: 변경 전후

| 항목 | 변경 전 (네트워크) | 변경 후 (로컬) |
|------|-------------------|---------------|
| **로딩 속도** | 느림 (네트워크 의존) | 빠름 (즉시 표시) |
| **오프라인** | ❌ 작동 안 함 | ✅ 정상 작동 |
| **안정성** | 보통 (서버 상태 의존) | 높음 (항상 작동) |
| **보안 설정** | 필요 (ATS, NSC) | 불필요 |
| **에러 가능성** | 높음 | 매우 낮음 |
| **약관 업데이트** | 서버만 수정 | Git + 앱 업데이트 |
| **버전 관리** | 어려움 | 쉬움 (Git) |

---

## 🎨 HTML 파일 형식

### 기본 구조

```html
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
  <title>약관 제목</title>
  <style>
    /* 스타일 */
  </style>
</head>
<body>
  <div class="information_box">
    <h1>약관 제목</h1>
    <div class="con">약관 내용...</div>
  </div>
</body>
</html>
```

### 주의사항

1. **인코딩**: UTF-8 필수
2. **외부 리소스**: 사용 금지 (CDN, 외부 이미지 등)
3. **JavaScript**: 필요 시 인라인으로 작성
4. **CSS**: `<style>` 태그 내에 작성
5. **모바일 최적화**: viewport 설정 필수

---

## 🐛 문제 해결

### 1. "약관 파일을 불러올 수 없습니다" 에러

**원인**: assets 경로 문제

**해결**:
```bash
# 1. pubspec.yaml 확인
flutter:
  assets:
    - assets/html/

# 2. 파일 존재 확인
ls assets/html/

# 3. 캐시 정리 후 재실행
flutter clean
flutter pub get
flutter run
```

### 2. HTML이 깨져 보임

**원인**: 인코딩 문제

**해결**:
```html
<meta charset="UTF-8" />
```

파일 저장 시 UTF-8 인코딩 사용

### 3. 스타일이 적용 안 됨

**원인**: 외부 CSS 사용

**해결**:
```html
<!-- ❌ 외부 CSS -->
<link rel="stylesheet" href="https://example.com/style.css">

<!-- ✅ 인라인 CSS -->
<style>
  body { font-family: sans-serif; }
</style>
```

---

## ✅ 테스트 체크리스트

- [ ] 이용약관 표시 정상 작동
- [ ] 개인정보 처리방침 표시 정상 작동
- [ ] 스크롤 정상 작동
- [ ] 폰트 크기 적절
- [ ] 뒤로가기 버튼 작동
- [ ] 확인 버튼 작동
- [ ] 오프라인 상태에서 작동
- [ ] Android 테스트
- [ ] iOS 테스트

---

## 📚 관련 파일

| 파일 | 설명 |
|------|------|
| `assets/html/privacy_policy.html` | 개인정보 처리방침 HTML |
| `assets/html/terms_of_service.html` | 이용약관 HTML |
| `lib/res/constants.dart` | URL 경로 정의 |
| `lib/widgets/terms.dart` | WebView 구현 |
| `lib/model/enum_list.dart` | 약관 타입 enum |
| `pubspec.yaml` | Assets 등록 |

---

## 🔗 참고 링크

- [원격 URL (백업용)](https://mobile.barosvc.com/info/)
- [GitHub 저장소](https://github.com/okpojung/ars_auth)
- [Pull Request #1](https://github.com/okpojung/ars_auth/pull/1)

---

## 📞 지원

문제가 발생하면 GitHub Issues에 등록해주세요:
https://github.com/okpojung/ars_auth/issues
