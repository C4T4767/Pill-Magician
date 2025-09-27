"""
YOLOv8 모델 학습 스크립트
Pill classification model training using YOLOv8
"""

from ultralytics import YOLO
import yaml
import os
import argparse
from pathlib import Path

def create_dataset_config(data_path, classes):
    """
    YOLOv8 학습을 위한 데이터셋 설정 파일 생성
    """
    config = {
        'path': str(data_path),
        'train': 'images/train',
        'val': 'images/val',
        'test': 'images/test',
        'nc': len(classes),
        'names': classes
    }
    
    config_path = data_path / 'dataset.yaml'
    with open(config_path, 'w', encoding='utf-8') as f:
        yaml.dump(config, f, default_flow_style=False, allow_unicode=True)
    
    return config_path

def train_yolov8_model(
    data_config_path,
    epochs=100,
    img_size=640,
    batch_size=16,
    model_size='n',
    save_dir='./runs/train'
):
    """
    YOLOv8 모델 학습 실행
    
    Args:
        data_config_path: 데이터셋 설정 파일 경로
        epochs: 학습 에포크 수
        img_size: 입력 이미지 크기
        batch_size: 배치 크기
        model_size: 모델 크기 (n, s, m, l, x)
        save_dir: 모델 저장 디렉토리
    """
    
    # 사전 훈련된 YOLOv8 모델 로드
    model = YOLO(f'yolov8{model_size}.pt')
    
    print(f"🚀 YOLOv8{model_size.upper()} 모델 학습 시작")
    print(f"📊 설정: Epochs={epochs}, ImgSize={img_size}, BatchSize={batch_size}")
    
    # 모델 학습 실행
    results = model.train(
        data=data_config_path,
        epochs=epochs,
        imgsz=img_size,
        batch=batch_size,
        name=f'pill_yolov8{model_size}',
        save=True,
        save_period=10,  # 10 에포크마다 체크포인트 저장
        patience=20,     # 조기 종료 설정
        project=save_dir,
        exist_ok=True,
        pretrained=True,
        optimizer='AdamW',
        lr0=0.01,
        lrf=0.1,
        momentum=0.937,
        weight_decay=0.0005,
        warmup_epochs=3,
        warmup_momentum=0.8,
        warmup_bias_lr=0.1,
        box=7.5,
        cls=0.5,
        dfl=1.5,
        pose=12.0,
        kobj=2.0,
        label_smoothing=0.0,
        nbs=64,
        hsv_h=0.015,
        hsv_s=0.7,
        hsv_v=0.4,
        degrees=0.0,
        translate=0.1,
        scale=0.5,
        shear=0.0,
        perspective=0.0,
        flipud=0.0,
        fliplr=0.5,
        mosaic=1.0,
        mixup=0.0,
        copy_paste=0.0
    )
    
    print("✅ 학습 완료!")
    print(f"📁 모델 저장 위치: {results.save_dir}")
    
    # 모델 검증
    metrics = model.val()
    print(f"📊 검증 결과:")
    print(f"   - mAP50: {metrics.box.map50:.4f}")
    print(f"   - mAP50-95: {metrics.box.map:.4f}")
    
    return results

def main():
    parser = argparse.ArgumentParser(description='YOLOv8 Pill Classification Training')
    parser.add_argument('--data', type=str, required=True, help='Dataset directory path')
    parser.add_argument('--epochs', type=int, default=100, help='Number of epochs')
    parser.add_argument('--img-size', type=int, default=640, help='Image size')
    parser.add_argument('--batch-size', type=int, default=16, help='Batch size')
    parser.add_argument('--model-size', choices=['n', 's', 'm', 'l', 'x'], default='n', help='Model size')
    parser.add_argument('--save-dir', type=str, default='./runs/train', help='Save directory')
    
    args = parser.parse_args()
    
    # 데이터 경로 설정
    data_path = Path(args.data)
    if not data_path.exists():
        raise FileNotFoundError(f"데이터 디렉토리를 찾을 수 없습니다: {data_path}")
    
    # 알약 클래스 목록 (실제 프로젝트에 맞게 수정 필요)
    pill_classes = [
        '타이레놀', '애드빌', '부루펜', '낙센', '펜잘', 
        '게보린', '사리돈', '밴드', '베아제', '디클론',
        # ... 더 많은 알약 클래스들
    ]
    
    # 데이터셋 설정 파일 생성
    config_path = create_dataset_config(data_path, pill_classes)
    print(f"📝 데이터셋 설정 파일 생성: {config_path}")
    
    # 모델 학습 실행
    train_yolov8_model(
        data_config_path=config_path,
        epochs=args.epochs,
        img_size=args.img_size,
        batch_size=args.batch_size,
        model_size=args.model_size,
        save_dir=args.save_dir
    )

if __name__ == "__main__":
    main()