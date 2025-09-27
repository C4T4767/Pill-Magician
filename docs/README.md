# 📚 Pill Magician Documentation

이 디렉토리에는 프로젝트 관련 문서와 이미지가 포함되어 있습니다.

## 📁 디렉토리 구조

```
docs/
├── images/           # 스크린샷, 다이어그램, UI 이미지
├── reports/          # 프로젝트 보고서 (PDF)
├── api/              # API 문서
└── README.md         # 이 파일
```

## 📖 문서 목록

### 프로젝트 보고서
- `reports/capstone_final_report.pdf` - 캡스톤 최종 보고서
- `reports/presentation.pdf` - 프로젝트 발표 자료
- `reports/proposal.pdf` - 프로젝트 제안서

### API 문서
- `api/api_reference.md` - REST API 참조 문서
- `api/socket_events.md` - Socket.IO 이벤트 문서

### 시스템 다이어그램
- `images/system_architecture.png` - 시스템 아키텍처 다이어그램
- `images/ai_model_comparison.png` - AI 모델 성능 비교 차트
- `images/database_erd.png` - 데이터베이스 ERD

### UI/UX 스크린샷
- `images/app_screenshots/` - 모바일 앱 스크린샷
- `images/web_screenshots/` - 웹 관리자 시스템 스크린샷

## 🎯 주요 문서

### 시스템 아키텍처
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Flutter App   │    │   Web Admin     │    │  Node.js API    │
│   (Mobile)      │◄──►│   Dashboard     │◄──►│     Server      │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                                        │
                       ┌─────────────────┐             │
                       │     MySQL       │◄────────────┤
                       │   Database      │             │
                       └─────────────────┘             │
                                                        │
                       ┌─────────────────┐             │
                       │   AI Models     │◄────────────┘
                       │ (YOLOv8/Mobile/ │
                       │    ResNet)      │
                       └─────────────────┘
```

### 기술 스택 상세
- **AI/ML**: YOLOv8, MobileNetV3, ResNet101, PyTorch
- **Backend**: Node.js, Express.js, Socket.IO, MySQL
- **Frontend**: Flutter, Dart, HTTP Client
- **DevOps**: PM2, Docker (선택사항)

### 프로젝트 타임라인
- **2024.03**: 프로젝트 기획 및 요구사항 분석
- **2024.04-05**: AI 모델 개발 및 학습
- **2024.06-08**: 백엔드 API 개발
- **2024.09-10**: Flutter 앱 개발
- **2024.11**: 통합 테스트 및 최종 발표

## 📞 연락처

프로젝트 관련 문의:
- **개발팀**: pill-magician@gachon.ac.kr
- **GitHub**: https://github.com/C4T4767/pill-magician