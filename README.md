# 💊 Pill Magician - AI 기반 알약 분류 시스템

> AI 모델을 활용한 알약 자동 분류 및 정보 제공 플랫폼  
> **가천대학교 2024년 캡스톤 디자인 프로젝트**

## 📌 프로젝트 개요

**Pill Magician**은 사용자가 촬영한 알약 이미지를 AI 모델로 분석하여 약물 정보를 제공하는 종합 플랫폼입니다. 3가지 딥러닝 모델(YOLOv8, MobileNetV3, ResNet101)을 비교 분석하여 최적의 성능을 도출했습니다.

### 🎯 핵심 가치
- **정확한 알약 식별**: 다중 AI 모델 앙상블로 높은 정확도 달성
- **실시간 처리**: 빠른 이미지 분석 및 결과 제공
- **사용자 친화적**: 직관적인 모바일 앱 인터페이스

## ✨ 주요 기능

### 🔍 **AI 기반 알약 분류**
- **3가지 AI 모델** 비교 구현 (YOLOv8, MobileNetV3, ResNet101)
- **이미지 전처리** 파이프라인 (중앙 크롭, 리사이징)
- **Top-5 분류 결과** 신뢰도와 함께 제공

### 📱 **Flutter 모바일 앱**
- **카메라 연동** 실시간 촬영 및 갤러리 선택
- **즉시 분석** 결과 화면
- **알약 정보** 상세 제공 (성분, 효능, 주의사항)

### 🖥️ **관리자 웹 시스템**
- **실시간 모니터링** 대시보드
- **AI 모델 관리** 및 성능 비교
- **사용자 활동** 통계 및 로그

### 🔄 **실시간 통신**
- **Socket.IO** 기반 실시간 업데이트
- **AI 학습 진행상황** 실시간 모니터링
- **즉시 결과 전송**

## 🛠 기술 스택

### **AI/ML**
- **YOLOv8** - 객체 탐지 및 분류
- **MobileNetV3** - 경량화 모바일 모델
- **ResNet101** - 고성능 분류 모델
- **PyTorch** - 딥러닝 프레임워크

### **Backend**
- **Node.js** + Express.js
- **Socket.IO** - 실시간 통신
- **MySQL** - 데이터베이스
- **Multer** - 파일 업로드 처리

### **Frontend**
- **Flutter** - 크로스 플랫폼 모바일 앱
- **EJS** - 웹 템플릿 엔진
- **HTTP** 클라이언트 통신

### **DevOps & Tools**
- **Python** - AI 모델 학습 및 추론
- **PM2** - 프로세스 관리
- **Morgan** - 로깅 미들웨어

## 📊 프로젝트 성과

### **AI 모델 성능 비교**
| 모델 | 정확도 | 추론 시간 | 모델 크기 |
|------|---------|-----------|-----------|
| YOLOv8 | 94.2% | ~200ms | 22MB |
| MobileNetV3 | 91.8% | ~150ms | 9MB |
| ResNet101 | 96.1% | ~300ms | 170MB |

### **시스템 성능**
- **평균 응답 시간**: 300ms 이하
- **동시 처리**: 50+ 요청 지원
- **이미지 처리**: 5MB 파일 지원

## 🏗 시스템 아키텍처

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

## 💡 기술적 하이라이트

### **1. 멀티 모델 앙상블 시스템**
```python
def classify_pill(image_path):
    # 3가지 모델로 동시 추론
    yolo_result = classify_yolov8(image_path)
    mobile_result = classify_mobilenet(image_path)
    resnet_result = classify_resnet(image_path)
    
    # 결과 앙상블 및 신뢰도 계산
    final_result = ensemble_results([yolo_result, mobile_result, resnet_result])
    return final_result
```

### **2. 실시간 Socket.IO 통신**
```javascript
// 실시간 AI 학습 진행상황 전송
socket.on('trainingUpdate', (update) => {
    io.emit('trainingUpdate', {
        epoch: update.epoch,
        accuracy: update.accuracy,
        loss: update.loss,
        timestamp: new Date()
    });
});
```

### **3. Flutter 카메라 연동**
```dart
// 카메라/갤러리 이미지 선택 및 AI 분석 요청
Future<void> classifyPill(File imageFile) async {
    final response = await http.post(
        Uri.parse('$baseUrl/ai/classify'),
        headers: {'Content-Type': 'multipart/form-data'},
        body: {'image': await MultipartFile.fromFile(imageFile.path)}
    );
    
    final result = json.decode(response.body);
    setState(() => _classificationResult = result);
}
```

## 🚀 실행 방법

### **환경 요구사항**
- Node.js 16 이상
- Python 3.8 이상
- Flutter 3.0 이상
- MySQL 8.0 이상

### **백엔드 실행**
```bash
cd backend
npm install
node server.js
# Server running on http://localhost:60003
```

### **AI 모델 실행**
```bash
cd ai
pip install -r requirements.txt
python inference/classify_yolov8.py models/yolov8_pill.pt sample_image.jpg
```

### **Flutter 앱 실행**
```bash
cd frontend
flutter pub get
flutter run
```

## 📁 프로젝트 구조

```
pill-magician/
├── backend/              # Node.js API 서버
│   ├── routes/          # API 라우터
│   ├── server.js        # 메인 서버 파일
│   └── package.json
├── frontend/            # Flutter 모바일 앱
│   ├── lib/            # Dart 소스코드
│   ├── assets/         # 이미지, 아이콘
│   └── pubspec.yaml
├── ai/                  # AI 모델 및 학습
│   ├── models/         # 학습된 모델 파일
│   ├── training/       # 모델 학습 스크립트
│   ├── inference/      # 추론 스크립트
│   └── requirements.txt
├── docs/               # 프로젝트 문서
│   ├── images/         # 스크린샷, 다이어그램
│   └── reports/        # 프로젝트 보고서
└── README.md
```

## 🤝 팀 구성

- **김우진**: AI 모델 개발, 데이터 전처리
- **배태선**: 백엔드 API 개발, 시스템 아키텍처
- **조은주**: Flutter 앱 개발, UI/UX 디자인
- **김동현**: 데이터베이스 설계, 웹 관리자 시스템

## 📞 연락처

- **GitHub**: [C4T4767](https://github.com/C4T4767)
- **Email**: taesun8282@naver.com

---

📅 **개발 기간**: 2024.03 ~ 2024.06  
🎓 **소속**: 가천대학교 컴퓨터공학과  
