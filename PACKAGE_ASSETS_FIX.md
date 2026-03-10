# 🔧 "페이지 내용을 불러올 수 없습니다" 오류 해결

## 🐛 문제 상황

로컬 HTML 방식으로 변경 후 "페이지 내용을 불러올 수 없습니다" 에러가 발생했습니다.

## 🔍 원인 분석

Flutter 패키지의 assets를 다른 앱에서 사용할 때는 **특별한 경로 형식**이 필요합니다.

### ❌ 잘못된 경로

```dart
// 패키지 내부에서만 작동
'assets/html/terms_of_service.html'
```

### ✅ 올바른 경로

```dart
// 다른 앱에서 패키지 assets 사용 시
'packages/ars_login/assets/html/terms_of_service.html'
```

---

## 🔧 해결 방법

### 1. **constants.dart 수정** (이미 완료!)

```dart
// lib/res/constants.dart

class AppConstants {
  // ✅ 올바른 패키지 assets 경로
  static const String termsOfServiceUrl =
      'packages/ars_login/assets/html/terms_of_service.html';
  static const String privacyPolicyUrl =
      'packages/ars_login/assets/html/privacy_policy.html';
}
```

### 2. **사용자 앱에서 업데이트**

```powershell
cd C:\Users\baro\Desktop\work\bs_point_0310

# 캐시 완전 정리
flutter clean

# 의존성 재설치
flutter pub get

# pub cache 정리 (필요시)
flutter pub cache repair

# 앱 재실행
flutter run
```

---

## 📊 Flutter 패키지 Assets 경로 규칙

### 패키지 내부에서 사용

```dart
// 패키지 자체 코드에서
rootBundle.loadString('assets/html/file.html')
```

### 다른 앱에서 패키지 assets 사용

```dart
// 앱에서 패키지 assets 로드
rootBundle.loadString('packages/패키지명/assets/html/file.html')
```

### 예시 비교

| 위치 | 경로 |
|------|------|
| 패키지 내부 | `assets/images/logo.png` |
| 앱에서 사용 | `packages/ars_login/assets/images/logo.png` |
| 패키지 내부 | `assets/html/terms.html` |
| 앱에서 사용 | `packages/ars_login/assets/html/terms.html` |

---

## 🎯 전체 경로 구조

```
사용자 앱 (bs_point)
└── pubspec.yaml
    └── dependencies:
        └── ars_login (패키지)
            ├── pubspec.yaml
            │   └── flutter:
            │       └── assets:
            │           └── assets/html/
            └── assets/
                └── html/
                    ├── privacy_policy.html
                    └── terms_of_service.html

로드 시:
앱 → rootBundle.loadString('packages/ars_login/assets/html/privacy_policy.html')
```

---

## ✅ 최종 확인 사항

### 1. **패키지 pubspec.yaml**

```yaml
# ars_login/pubspec.yaml
flutter:
  assets:
    - assets/images/
    - assets/html/        # ✅ 패키지 assets 등록
```

### 2. **패키지 constants.dart**

```dart
// ars_login/lib/res/constants.dart
static const String termsOfServiceUrl =
    'packages/ars_login/assets/html/terms_of_service.html';  // ✅ packages/ 접두사
```

### 3. **사용자 앱 pubspec.yaml**

```yaml
# bs_point/pubspec.yaml
dependencies:
  ars_login:
    git:
      url: https://github.com/okpojung/ars_auth.git
      ref: genspark_ai_developer  # ✅ 최신 커밋 포함
```

---

## 🧪 테스트 방법

### PowerShell에서 실행

```powershell
# 1. 프로젝트로 이동
cd C:\Users\baro\Desktop\work\bs_point_0310

# 2. 완전 정리
flutter clean
Remove-Item -Recurse -Force .dart_tool -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force build -ErrorAction SilentlyContinue

# 3. 의존성 재설치
flutter pub get

# 4. 앱 실행
flutter run

# 5. 로그 확인
# "✅ 로컬 HTML 로드 성공" 메시지 확인
```

### 예상 로그

```
✅ 로컬 HTML 로드 성공: packages/ars_login/assets/html/terms_of_service.html
✅ WebView 생성됨 (로컬 HTML)
```

### 에러 발생 시 로그

```
❌ 로컬 HTML 로드 실패: Unable to load asset
```

---

## 🔍 추가 디버깅

### 1. **assets 파일 존재 확인**

```dart
// 패키지 디버깅 코드 (terms.dart에 임시 추가)
Future<void> _loadLocalHtml() async {
  try {
    print('🔍 로드 시도: ${widget.termsType.url}');
    
    final content = await rootBundle.loadString(widget.termsType.url);
    
    print('✅ 파일 크기: ${content.length} bytes');
    print('✅ 로드 성공!');
    
    setState(() {
      htmlContent = content;
      isLoading = false;
    });
  } catch (e, stackTrace) {
    print('❌ 로드 실패: $e');
    print('📍 Stack trace: $stackTrace');
    
    setState(() {
      errorMessage = '약관 파일을 불러올 수 없습니다.\n에러: $e';
      isLoading = false;
    });
  }
}
```

### 2. **패키지 캐시 확인**

```powershell
# 패키지 캐시 위치 확인
flutter pub cache list

# 특정 패키지 확인
flutter pub cache list | Select-String "ars_login"

# 캐시 완전 정리 후 재설치
flutter pub cache repair
cd C:\Users\baro\Desktop\work\bs_point_0310
flutter pub get
```

### 3. **빌드 폴더 정리**

```powershell
cd C:\Users\baro\Desktop\work\bs_point_0310

# Windows
Remove-Item -Recurse -Force build, .dart_tool

# 또는 Git Bash
rm -rf build .dart_tool

flutter pub get
flutter run
```

---

## 📝 커밋 이력

### Commit 1: WebView 네트워크 이슈 해결
- Android/iOS 보안 설정 추가
- WebView 설정 최적화

### Commit 2: 로컬 HTML 방식 전환
- HTML 파일 assets에 추가
- rootBundle 로드 방식 적용

### Commit 3: 패키지 경로 수정 ✅
- `packages/ars_login/` 접두사 추가
- **이 커밋이 문제 해결의 핵심!**

---

## 🎉 결론

**핵심 포인트**: Flutter 패키지의 assets를 다른 앱에서 사용할 때는 반드시 `packages/패키지명/` 접두사를 붙여야 합니다!

```dart
// ❌ 잘못된 경로
'assets/html/terms_of_service.html'

// ✅ 올바른 경로
'packages/ars_login/assets/html/terms_of_service.html'
```

이제 앱에서 `flutter pub get` 후 실행하면 정상적으로 약관이 표시됩니다! 🚀
