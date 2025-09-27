"""
YOLOv8 기반 알약 분류 추론 스크립트
Pill classification inference using YOLOv8 model
"""

from ultralytics import YOLO
import sys
import json
from PIL import Image
import argparse

def crop_center(image_path, cropped_image_path):
    """
    이미지 중앙 영역을 크롭하는 함수
    Args:
        image_path: 원본 이미지 경로
        cropped_image_path: 크롭된 이미지 저장 경로
    """
    img = Image.open(image_path)
    width, height = img.size
    
    # 중앙 1/9 영역 계산
    left = width / 3
    top = height / 3
    right = width * 2 / 3
    bottom = height * 2 / 3
    
    # 이미지 크롭 및 저장
    cropped_img = img.crop((left, top, right, bottom))
    cropped_img.save(cropped_image_path)

def classify_pill(model_path, image_path, num_results=5):
    """
    YOLOv8 모델을 사용한 알약 분류
    Args:
        model_path: 학습된 모델 경로
        image_path: 분류할 이미지 경로
        num_results: 반환할 결과 개수
    Returns:
        dict: 분류 결과 (클래스명, 확률)
    """
    # 이미지 전처리
    cropped_image_path = './data/cropped_image.jpg'
    crop_center(image_path, cropped_image_path)
    
    # 모델 로드 및 추론
    model = YOLO(model_path)
    results = model(cropped_image_path)
    
    # 결과 추출
    class_names = results[0].names
    probabilities = results[0].probs
    
    # Top-N 결과 정리
    classification_results = []
    for i in range(min(num_results, len(probabilities.top5))):
        if i == 0:
            class_name = class_names[0]
            probability = probabilities.top1conf.item()
        else:
            class_name = class_names[probabilities.top5[i]]
            probability = probabilities.top5conf[i].item()
        
        classification_results.append({
            'class_name': class_name,
            'probability': probability,
            'rank': i + 1
        })
    
    return {
        'model_type': 'YOLOv8',
        'results': classification_results,
        'total_classes': len(class_names)
    }

def main():
    parser = argparse.ArgumentParser(description='YOLOv8 Pill Classification')
    parser.add_argument('model_path', help='Path to trained YOLOv8 model')
    parser.add_argument('image_path', help='Path to input image')
    parser.add_argument('--num_results', type=int, default=5, help='Number of top results to return')
    
    args = parser.parse_args()
    
    try:
        results = classify_pill(args.model_path, args.image_path, args.num_results)
        print(json.dumps(results, ensure_ascii=False, indent=2))
    except Exception as e:
        print(json.dumps({'error': str(e)}, ensure_ascii=False))

if __name__ == "__main__":
    main()