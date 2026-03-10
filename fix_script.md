# 🚨 긴급 수정: 캐시 문제 해결

## 문제
앱이 구버전 패키지를 사용 중입니다.

## 해결 방법

### PowerShell에서 실행 (순서대로!)

```powershell
# 1. 프로젝트로 이동
cd C:\Users\baro\Desktop\work\bs_point_0310

# 2. 기존 패키지 캐시 삭제
flutter pub cache clean

# 3. pub cache 완전 정리
flutter pub cache repair

# 4. 프로젝트 정리
flutter clean

# 5. 빌드 폴더 삭제
Remove-Item -Recurse -Force build -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force .dart_tool -ErrorAction SilentlyContinue

# 6. pubspec.lock 삭제 (중요!)
Remove-Item -Force pubspec.lock -ErrorAction SilentlyContinue

# 7. 의존성 재설치
flutter pub get

# 8. 앱 실행
flutter run
```

## 예상 로그 (성공 시)

```
I/flutter: 🔍 로드 시도: packages/ars_login/assets/html/terms_of_service.html
I/flutter: ✅ 파일 크기: 19760 bytes
I/flutter: ✅ 로드 성공!
I/flutter: ✅ WebView 생성됨 (로컬 HTML)
```

## 만약 여전히 안 되면

### Git에서 직접 특정 커밋 사용

pubspec.yaml 수정:
```yaml
dependencies:
  ars_login:
    git:
      url: https://github.com/okpojung/ars_auth.git
      ref: 7566660  # 특정 커밋 해시
```

그리고:
```powershell
flutter clean
flutter pub get
flutter run
```
