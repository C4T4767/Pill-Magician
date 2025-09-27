# 📱 Pill Magician Mobile App

Flutter 기반 크로스 플랫폼 알약 분류 모바일 애플리케이션

## ✨ 주요 기능

### 📷 **이미지 캡처 & 업로드**
- **카메라 촬영** 실시간 알약 사진 촬영
- **갤러리 선택** 기존 이미지 불러오기
- **이미지 전처리** 자동 크롭 및 최적화

### 🔍 **AI 분석 결과**
- **실시간 분석** 이미지 업로드 즉시 결과 제공
- **Top-5 결과** 신뢰도 순 정렬
- **상세 정보** 약물 성분, 효능, 주의사항

### 📊 **개인화 기능**
- **검색 히스토리** 이전 검색 결과 저장
- **즐겨찾기** 자주 찾는 약물 북마크
- **알림 설정** 복용 시간 리마인더

## 🛠 기술 스택

- **Flutter 3.0** - UI 프레임워크
- **HTTP** - API 통신
- **Provider** - 상태 관리
- **Image Picker** - 카메라/갤러리 연동
- **Shared Preferences** - 로컬 데이터 저장

## 🚀 빌드 & 실행

### 환경 요구사항
- Flutter SDK 3.0 이상
- Dart SDK 2.17 이상
- Android Studio (Android 빌드)
- Xcode (iOS 빌드)

### 실행 방법
```bash
# 의존성 설치
flutter pub get

# 개발 모드 실행
flutter run

# Android APK 빌드
flutter build apk

# iOS IPA 빌드 (macOS 필요)
flutter build ios
```

## 📱 주요 화면

### 1. 메인 화면
- 카메라 촬영 버튼
- 갤러리 선택 버튼
- 최근 검색 기록

### 2. 촬영/선택 화면
- 실시간 카메라 프리뷰
- 촬영 가이드라인
- 이미지 편집 기능

### 3. 분석 결과 화면
- AI 분석 진행 상황
- Top-5 분류 결과
- 각 결과별 신뢰도 표시

### 4. 상세 정보 화면
- 약물 기본 정보
- 성분 및 효능
- 복용법 및 주의사항

## 🔧 환경 설정

`lib/config/api_config.dart`:
```dart
class ApiConfig {
  static const String baseUrl = 'http://localhost:60003';
  static const String classifyEndpoint = '/ai/classify';
  static const int timeoutSeconds = 30;
}
```

## 📁 프로젝트 구조

```
lib/
├── main.dart              # 앱 진입점
├── screens/               # 화면 위젯
│   ├── home_screen.dart
│   ├── camera_screen.dart
│   ├── result_screen.dart
│   └── detail_screen.dart
├── services/              # API 서비스
│   ├── api_service.dart
│   └── image_service.dart
├── models/                # 데이터 모델
│   ├── pill_model.dart
│   └── classification_result.dart
├── providers/             # 상태 관리
│   └── app_provider.dart
├── widgets/               # 재사용 위젯
│   ├── camera_widget.dart
│   └── result_card.dart
├── utils/                 # 유틸리티
│   └── image_utils.dart
└── config/                # 설정
    └── api_config.dart
```