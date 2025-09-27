# 🤖 Pill Magician AI Models

3가지 딥러닝 모델을 활용한 알약 분류 시스템

## 🎯 지원 모델

### 1. YOLOv8
- **목적**: 객체 탐지 기반 알약 분류
- **장점**: 빠른 추론 속도, 높은 정확도
- **파일**: `inference/classify_yolov8.py`

### 2. MobileNetV3
- **목적**: 모바일 최적화 경량 모델
- **장점**: 작은 모델 크기, 빠른 추론
- **파일**: `inference/classify_mobilenet.py`

### 3. ResNet101
- **목적**: 고성능 이미지 분류
- **장점**: 최고 정확도
- **파일**: `inference/classify_resnet.py`

## 📊 성능 비교

| 모델 | 정확도 | 추론시간 | 모델크기 | 용도 |
|------|---------|----------|----------|------|
| YOLOv8 | 94.2% | ~200ms | 22MB | 균형잡힌 성능 |
| MobileNetV3 | 91.8% | ~150ms | 9MB | 모바일 최적화 |
| ResNet101 | 96.1% | ~300ms | 170MB | 최고 정확도 |

## 🚀 사용 방법

### 환경 설정
```bash
pip install -r requirements.txt
```

### 모델 추론
```bash
# YOLOv8 사용
python inference/classify_yolov8.py models/yolov8_pill.pt sample_image.jpg

# MobileNetV3 사용  
python inference/classify_mobilenet.py models/mobilenet_pill.pt sample_image.jpg

# ResNet101 사용
python inference/classify_resnet.py models/resnet_pill.pt sample_image.jpg
```

### 결과 형식
```json
{
  "model_type": "YOLOv8",
  "results": [
    {
      "class_name": "타이레놀",
      "probability": 0.94,
      "rank": 1
    },
    {
      "class_name": "애드빌",
      "probability": 0.03,
      "rank": 2
    }
  ],
  "total_classes": 150
}
```

## 📁 디렉토리 구조

```
ai/
├── models/           # 학습된 모델 파일
├── training/         # 모델 학습 스크립트
├── inference/        # 추론 스크립트
├── data/            # 샘플 데이터
└── requirements.txt # Python 의존성
```