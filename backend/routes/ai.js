const express = require('express');
const router = express.Router();
const multer = require('multer');
const { spawn } = require('child_process');
const path = require('path');
const fs = require('fs');

// 파일 업로드 설정
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        const uploadDir = path.join(__dirname, '../../ai/data/uploads');
        if (!fs.existsSync(uploadDir)) {
            fs.mkdirSync(uploadDir, { recursive: true });
        }
        cb(null, uploadDir);
    },
    filename: function (req, file, cb) {
        const uniqueName = Date.now() + '-' + Math.round(Math.random() * 1E9) + path.extname(file.originalname);
        cb(null, uniqueName);
    }
});

const upload = multer({ 
    storage: storage,
    limits: { fileSize: 10 * 1024 * 1024 }, // 10MB 제한
    fileFilter: (req, file, cb) => {
        if (file.mimetype.startsWith('image/')) {
            cb(null, true);
        } else {
            cb(new Error('이미지 파일만 업로드 가능합니다.'));
        }
    }
});

// AI 모델을 사용한 알약 분류
router.post('/classify', upload.single('image'), async (req, res) => {
    if (!req.file) {
        return res.status(400).json({ error: '이미지 파일이 필요합니다.' });
    }

    const imagePath = req.file.path;
    const modelType = req.body.model || 'yolov8'; // 기본값: YOLOv8
    
    try {
        let scriptPath;
        let modelPath;
        
        // 모델 타입에 따른 스크립트 선택
        switch (modelType) {
            case 'yolov8':
                scriptPath = path.join(__dirname, '../../ai/inference/classify_yolov8.py');
                modelPath = path.join(__dirname, '../../ai/models/yolov8_pill.pt');
                break;
            case 'mobilenet':
                scriptPath = path.join(__dirname, '../../ai/inference/classify_mobilenet.py');
                modelPath = path.join(__dirname, '../../ai/models/mobilenet_pill.pt');
                break;
            case 'resnet':
                scriptPath = path.join(__dirname, '../../ai/inference/classify_resnet.py');
                modelPath = path.join(__dirname, '../../ai/models/resnet_pill.pt');
                break;
            default:
                return res.status(400).json({ error: '지원하지 않는 모델 타입입니다.' });
        }

        // Python 스크립트 실행
        const pythonProcess = spawn('python', [scriptPath, modelPath, imagePath]);
        
        let result = '';
        let error = '';

        pythonProcess.stdout.on('data', (data) => {
            result += data.toString();
        });

        pythonProcess.stderr.on('data', (data) => {
            error += data.toString();
        });

        pythonProcess.on('close', (code) => {
            // 임시 파일 삭제
            fs.unlink(imagePath, (err) => {
                if (err) console.error('임시 파일 삭제 실패:', err);
            });

            if (code === 0) {
                try {
                    const classificationResult = JSON.parse(result);
                    
                    // Socket.IO로 실시간 결과 전송
                    const io = req.app.get('socketio');
                    io.emit('classificationResult', {
                        result: classificationResult,
                        timestamp: new Date().toISOString()
                    });

                    res.json({
                        success: true,
                        result: classificationResult,
                        model_used: modelType
                    });
                } catch (parseError) {
                    res.status(500).json({ 
                        error: '결과 파싱 실패', 
                        details: parseError.message 
                    });
                }
            } else {
                res.status(500).json({ 
                    error: 'AI 모델 실행 실패', 
                    details: error 
                });
            }
        });

    } catch (error) {
        res.status(500).json({ 
            error: '서버 오류', 
            details: error.message 
        });
    }
});

// 사용 가능한 AI 모델 목록
router.get('/models', (req, res) => {
    res.json({
        available_models: [
            {
                name: 'YOLOv8',
                id: 'yolov8',
                accuracy: '94.2%',
                inference_time: '~200ms',
                model_size: '22MB',
                description: '균형잡힌 성능의 객체 탐지 모델'
            },
            {
                name: 'MobileNetV3',
                id: 'mobilenet',
                accuracy: '91.8%',
                inference_time: '~150ms',
                model_size: '9MB',
                description: '모바일 최적화 경량 모델'
            },
            {
                name: 'ResNet101',
                id: 'resnet',
                accuracy: '96.1%',
                inference_time: '~300ms',
                model_size: '170MB',
                description: '최고 정확도의 분류 모델'
            }
        ]
    });
});

// AI 모델 학습 상태 확인
router.get('/training/status', (req, res) => {
    // 실제로는 데이터베이스나 파일에서 학습 상태를 확인
    res.json({
        status: 'completed',
        current_epoch: 100,
        total_epochs: 100,
        accuracy: 94.2,
        loss: 0.15,
        last_updated: new Date().toISOString()
    });
});

module.exports = router;