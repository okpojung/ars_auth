# 📱 약관 HTML 폰트 크기 조정 가이드

## 🎯 폰트 크기 제어 요소

약관 HTML의 폰트 크기는 **두 가지 요소**로 제어됩니다:

1. **HTML CSS 설정** (assets/html/*.html)
2. **WebView textZoom 설정** (lib/widgets/terms.dart)

---

## 📊 현재 적용된 설정

### 1. HTML CSS 설정

```css
/* 기본 폰트 크기 */
html, body {
  font-size: 14px;  /* 기준 크기 */
}

/* 제목 (h1) */
h1 {
  font-size: 1.3rem;  /* 14px × 1.3 = 18.2px */
}

/* 소제목 (h2) */
h2 {
  font-size: 1.05rem;  /* 14px × 1.05 = 14.7px */
}

/* 본문 (.con) */
.con {
  font-size: 0.95rem;  /* 14px × 0.95 = 13.3px */
}

/* 모바일 (480px 이하) */
@media (max-width: 480px) {
  body {
    font-size: 13px;  /* 기준 크기 축소 */
  }
  
  h1 {
    font-size: 1.2rem;  /* 13px × 1.2 = 15.6px */
  }
  
  h2 {
    font-size: 1rem;  /* 13px × 1 = 13px */
  }
  
  .con {
    font-size: 0.9rem;  /* 13px × 0.9 = 11.7px */
  }
}
```

### 2. WebView textZoom 설정

```dart
// lib/widgets/terms.dart
InAppWebViewSettings(
  textZoom: 100,  // 100% (기본값, 변경 없음)
)
```

---

## 🔧 폰트 크기 조정 방법

### 방법 1: HTML CSS 수정 (권장)

**파일 위치**:
- `assets/html/terms_of_service.html`
- `assets/html/privacy_policy.html`

**수정 방법**:

```css
/* 더 크게 하려면 */
html, body {
  font-size: 16px;  /* 14px → 16px */
}

h1 {
  font-size: 1.5rem;  /* 1.3rem → 1.5rem */
}

/* 더 작게 하려면 */
html, body {
  font-size: 12px;  /* 14px → 12px */
}

h1 {
  font-size: 1.1rem;  /* 1.3rem → 1.1rem */
}
```

### 방법 2: WebView textZoom 수정

**파일 위치**: `lib/widgets/terms.dart`

**수정 방법**:

```dart
InAppWebViewSettings(
  textZoom: 120,  // 120% (20% 크게)
  // 또는
  textZoom: 80,   // 80% (20% 작게)
)
```

---

## 📐 폰트 크기 계산법

### rem 단위 계산

```
실제 크기 = 기본 font-size × rem 값

예시:
- 기본 font-size: 14px
- h1 설정: 1.3rem
- 실제 h1 크기: 14px × 1.3 = 18.2px
```

### textZoom 적용

```
최종 크기 = 실제 크기 × (textZoom / 100)

예시:
- 실제 h1 크기: 18.2px
- textZoom: 100
- 최종 h1 크기: 18.2px × (100/100) = 18.2px

예시 2 (textZoom 120):
- 실제 h1 크기: 18.2px
- textZoom: 120
- 최종 h1 크기: 18.2px × (120/100) = 21.84px
```

---

## 📋 권장 설정 값

### 작은 폰트 (노안 대응 불필요)

```css
/* HTML CSS */
html, body { font-size: 12px; }
h1 { font-size: 1.2rem; }  /* 14.4px */
h2 { font-size: 1rem; }    /* 12px */
.con { font-size: 0.9rem; } /* 10.8px */
```

```dart
// WebView
textZoom: 100
```

### 중간 폰트 (현재 설정) ✅

```css
/* HTML CSS */
html, body { font-size: 14px; }
h1 { font-size: 1.3rem; }  /* 18.2px */
h2 { font-size: 1.05rem; } /* 14.7px */
.con { font-size: 0.95rem; } /* 13.3px */
```

```dart
// WebView
textZoom: 100
```

### 큰 폰트 (노안 대응)

```css
/* HTML CSS */
html, body { font-size: 16px; }
h1 { font-size: 1.4rem; }  /* 22.4px */
h2 { font-size: 1.1rem; }  /* 17.6px */
.con { font-size: 1rem; }  /* 16px */
```

```dart
// WebView
textZoom: 110  // 추가 10% 확대
```

---

## 🎨 스타일 요소별 역할

### h1 (페이지 제목)

```css
h1 {
  font-size: 1.3rem;      /* 크기 */
  font-weight: 700;       /* 굵기 */
  color: #111111;         /* 색상 */
  margin: 0 0 28px;       /* 여백 */
}
```

**용도**: "비에스포인트앱 서비스 이용약관" 같은 최상위 제목

### h2 (섹션 제목)

```css
h2 {
  font-size: 1.05rem;     /* 크기 */
  font-weight: 700;       /* 굵기 */
  color: #111111;         /* 색상 */
  border-left: 4px solid #4a7bd0;  /* 왼쪽 강조선 */
  padding-left: 10px;     /* 왼쪽 여백 */
}
```

**용도**: "제 1조 (목적)" 같은 섹션 제목

### .con (본문 내용)

```css
.con {
  font-size: 0.95rem;     /* 크기 */
  color: #222222;         /* 색상 */
  line-height: 1.75;      /* 줄 간격 */
  margin-bottom: 14px;    /* 아래 여백 */
}
```

**용도**: 약관의 본문 내용

### .section-box (섹션 박스)

```css
.section-box {
  background: #fafafa;    /* 배경색 */
  border: 1px solid #eeeeee;  /* 테두리 */
  border-radius: 12px;    /* 모서리 둥글게 */
  padding: 16px;          /* 내부 여백 */
}
```

**용도**: 내용을 담는 회색 박스

---

## 🔄 변경 사항 적용 방법

### 1. HTML 파일 수정

```bash
# 패키지 저장소에서
git clone https://github.com/okpojung/ars_auth.git
cd ars_auth
git checkout genspark_ai_developer

# HTML 파일 수정
code assets/html/terms_of_service.html
code assets/html/privacy_policy.html

# 커밋 및 푸시
git add assets/html/
git commit -m "style: 약관 폰트 크기 조정"
git push origin genspark_ai_developer
```

### 2. 사용자 앱 업데이트

```powershell
cd C:\Users\baro\Desktop\work\bs_point_0310

# 캐시 정리
flutter clean

# 의존성 업데이트
flutter pub get

# 앱 실행
flutter run
```

---

## 🎯 테스트 시나리오

### 1. 다양한 기기 테스트

- [ ] 작은 화면 (5인치)
- [ ] 중간 화면 (6인치)
- [ ] 큰 화면 (6.5인치+)
- [ ] 태블릿 (10인치)

### 2. 가독성 테스트

- [ ] 제목이 눈에 잘 띄는가?
- [ ] 본문을 편하게 읽을 수 있는가?
- [ ] 줄 간격이 적절한가?
- [ ] 스크롤이 부드러운가?

### 3. 접근성 테스트

- [ ] 노안 사용자가 읽기 편한가?
- [ ] 색약 사용자가 구분할 수 있는가?
- [ ] 명암 대비가 충분한가?

---

## 📊 변경 이력

### 2024-03-10: 폰트 크기 최적화

**변경 전**:
```css
html, body { font-size: 16px; }
h1 { font-size: 1.9rem; }  /* 30.4px - 너무 큼 */
```

**변경 후**:
```css
html, body { font-size: 14px; }
h1 { font-size: 1.3rem; }  /* 18.2px - 적절 */
```

**WebView 설정**:
```dart
textZoom: 220  →  textZoom: 100  (기본값)
```

**이유**: 
- 이전 설정(16px × 1.9 × 2.2 = 66.88px)이 너무 커서 가독성 저하
- 현재 설정(14px × 1.3 × 1.0 = 18.2px)으로 적절한 크기 확보

---

## 💡 추가 팁

### 1. rem vs px

```css
/* ✅ rem 사용 (권장) */
h1 { font-size: 1.3rem; }  /* 반응형, 상대 크기 */

/* ❌ px 사용 (비권장) */
h1 { font-size: 18px; }    /* 고정, 절대 크기 */
```

**rem 장점**: 기본 font-size만 변경하면 모든 요소가 비율에 맞게 조정됨

### 2. 모바일 최적화

```css
/* 데스크톱 */
@media (min-width: 481px) {
  body { font-size: 14px; }
}

/* 모바일 */
@media (max-width: 480px) {
  body { font-size: 13px; }  /* 1px 작게 */
}
```

### 3. 줄 간격 조정

```css
body {
  line-height: 1.75;  /* 줄 간격 (175%) */
}

/* 더 넓게: 1.85, 2.0 */
/* 더 좁게: 1.6, 1.5 */
```

---

## 🔗 관련 파일

| 파일 | 역할 |
|------|------|
| `assets/html/terms_of_service.html` | 이용약관 HTML + CSS |
| `assets/html/privacy_policy.html` | 개인정보 처리방침 HTML + CSS |
| `lib/widgets/terms.dart` | WebView 설정 (textZoom) |

---

## 📞 추가 지원

폰트 크기 조정이 필요하면:
1. 이 가이드를 참고하여 HTML CSS 수정
2. 또는 WebView textZoom 값 조정
3. 변경 후 테스트하여 최적값 찾기
