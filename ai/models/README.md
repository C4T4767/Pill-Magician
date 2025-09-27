# 🤖 AI Models Directory

이 디렉토리에는 학습된 AI 모델 파일들이 저장됩니다.

## 📁 모델 파일 구조

```
models/
├── yolov8_pill.pt      # YOLOv8 알약 분류 모델
├── mobilenet_pill.pt   # MobileNetV3 알약 분류 모델
├── resnet_pill.pt      # ResNet101 알약 분류 모델
└── README.md           # 이 파일
```

## 📊 모델 성능

| 모델 | 파일명 | 정확도 | 크기 | 추론시간 |
|------|--------|---------|------|----------|
| YOLOv8 | yolov8_pill.pt | 94.2% | 22MB | ~200ms |
| MobileNetV3 | mobilenet_pill.pt | 91.8% | 9MB | ~150ms |
| ResNet101 | resnet_pill.pt | 96.1% | 170MB | ~300ms |

## 🚀 모델 사용법

### Python에서 직접 사용
```python
from ultralytics import YOLO

# YOLOv8 모델 로드
model = YOLO('models/yolov8_pill.pt')

# 이미지 분류
results = model('pill_image.jpg')
```

### API를 통한 사용
```bash
curl -X POST http://localhost:60003/ai/classify \
  -F "image=@pill_image.jpg" \
  -F "model=yolov8"
```

## 📝 주의사항

- 모델 파일은 Git LFS를 사용하여 관리됩니다
- 큰 모델 파일(resnet_pill.pt)은 다운로드에 시간이 걸릴 수 있습니다
- 모델 파일이 없는 경우 학습 스크립트를 통해 새로 생성할 수 있습니다

## 🔄 모델 재학습

새로운 데이터로 모델을 재학습하려면:

```bash
cd ../training
python train_yolov8.py --data /path/to/dataset --epochs 100
```