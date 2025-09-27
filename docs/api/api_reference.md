# 🔌 API Reference

Pill Magician 백엔드 API 문서입니다.

## 📍 Base URL
```
http://localhost:60003
```

## 🔐 Authentication
현재 인증이 필요하지 않습니다.

## 📋 API Endpoints

### 1. 알약 분류 API

#### POST `/ai/classify`
업로드된 이미지를 AI 모델로 분석하여 알약을 분류합니다.

**Parameters:**
- `image` (file, required): 분석할 알약 이미지 파일
- `model` (string, optional): 사용할 AI 모델 ('yolov8', 'mobilenet', 'resnet') 기본값: 'yolov8'

**Request Example:**
```bash
curl -X POST http://localhost:60003/ai/classify \
  -F "image=@pill_image.jpg" \
  -F "model=yolov8"
```

**Response:**
```json
{
  "success": true,
  "result": {
    "confidence": 0.94,
    "class_id": 1,
    "predicted_pill": "타이레놀",
    "processing_time": 200
  }
}
```

**Error Response:**
```json
{
  "success": false,
  "error": "이미지 파일이 필요합니다"
}
```

### 2. 알약 정보 API

#### GET `/pills`
등록된 모든 알약 정보를 조회합니다.

**Response:**
```json
{
  "success": true,
  "pills": [
    {
      "id": 1,
      "name": "Tylenol",
      "korean_name": "타이레놀",
      "manufacturer": "한국얀센",
      "ingredient": "Acetaminophen 500mg",
      "efficacy": "해열, 진통"
    }
  ]
}
```

#### GET `/pills/:id`
특정 알약의 상세 정보를 조회합니다.

**Parameters:**
- `id` (number): 알약 ID

**Response:**
```json
{
  "success": true,
  "pill": {
    "id": 1,
    "name": "Tylenol",
    "korean_name": "타이레놀",
    "manufacturer": "한국얀센",
    "ingredient": "Acetaminophen 500mg",
    "efficacy": "해열, 진통",
    "usage_instructions": "성인 기준 1회 1-2정",
    "precautions": "간 기능 장애 환자 주의",
    "side_effects": "드물게 알레르기 반응"
  }
}
```

### 3. 분류 결과 저장 API

#### POST `/results`
AI 분류 결과를 데이터베이스에 저장합니다.

**Request Body:**
```json
{
  "user_id": 1,
  "image_path": "/uploads/pill_123.jpg",
  "model_used": "yolov8",
  "predicted_pill_id": 1,
  "confidence_score": 0.94,
  "processing_time_ms": 200
}
```

**Response:**
```json
{
  "success": true,
  "result_id": 123
}
```

### 4. 피드백 API

#### POST `/feedback`
사용자 피드백을 저장합니다.

**Request Body:**
```json
{
  "user_id": 1,
  "classification_result_id": 123,
  "is_correct": true,
  "rating": 5,
  "comment": "정확하게 분류했습니다"
}
```

**Response:**
```json
{
  "success": true,
  "feedback_id": 456
}
```

## 📊 Response Status Codes

| Code | Description |
|------|-------------|
| 200  | 성공 |
| 400  | 잘못된 요청 |
| 404  | 리소스를 찾을 수 없음 |
| 500  | 서버 내부 오류 |

## 🚀 Rate Limiting
현재 Rate Limiting이 적용되지 않았습니다.

## 📝 Notes
- 이미지 파일 최대 크기: 5MB
- 지원 이미지 형식: JPG, PNG, JPEG
- 모든 응답은 JSON 형식입니다