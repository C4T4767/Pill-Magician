# 🖥️ Pill Magician Backend

Node.js 기반 API 서버 및 실시간 통신 시스템

## 📋 주요 기능

- **RESTful API** 제공
- **Socket.IO** 실시간 통신
- **AI 모델 연동** 및 결과 처리
- **파일 업로드** 처리 (이미지)
- **MySQL 데이터베이스** 연동

## 🚀 실행 방법

```bash
# 의존성 설치
npm install

# 서버 실행
npm start

# 개발 모드 (nodemon)
npm run dev
```

## 📡 API 엔드포인트

### 알약 분류
- `POST /ai/classify` - 이미지 업로드 및 AI 분류
- `GET /ai/models` - 사용 가능한 AI 모델 목록

### 사용자 관리
- `POST /users/register` - 사용자 등록
- `POST /users/login` - 로그인
- `GET /users/profile` - 프로필 조회

### 실시간 업데이트
- `Socket: trainingUpdate` - AI 학습 진행상황
- `Socket: classificationResult` - 분류 결과 실시간 전송

## 🔧 환경 설정

환경변수 설정 (.env 파일):
```
PORT=60003
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=password
DB_NAME=pill_magician
```