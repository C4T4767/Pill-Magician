-- Pill Magician Database Schema
-- AI-powered pill classification system

-- 사용자 테이블
CREATE TABLE user (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- 알약 정보 테이블
CREATE TABLE pill (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    korean_name VARCHAR(100),
    manufacturer VARCHAR(100),
    ingredient VARCHAR(500),
    efficacy TEXT,
    usage_instructions TEXT,
    precautions TEXT,
    side_effects TEXT,
    image_url VARCHAR(255),
    classification_code VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- AI 분류 결과 테이블
CREATE TABLE classification_result (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    image_path VARCHAR(255) NOT NULL,
    model_used VARCHAR(50) NOT NULL,
    predicted_pill_id INT,
    confidence_score DECIMAL(5,4),
    processing_time_ms INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE SET NULL,
    FOREIGN KEY (predicted_pill_id) REFERENCES pill(id) ON DELETE SET NULL
);

-- 사용자 피드백 테이블
CREATE TABLE feedback (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    classification_result_id INT,
    is_correct BOOLEAN,
    actual_pill_id INT,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE,
    FOREIGN KEY (classification_result_id) REFERENCES classification_result(id) ON DELETE CASCADE,
    FOREIGN KEY (actual_pill_id) REFERENCES pill(id) ON DELETE SET NULL
);

-- AI 모델 정보 테이블
CREATE TABLE ai_model (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    version VARCHAR(20) NOT NULL,
    model_path VARCHAR(255) NOT NULL,
    accuracy DECIMAL(5,4),
    model_size_mb INT,
    avg_inference_time_ms INT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_model_version (name, version)
);

-- 사용자 세션 테이블
CREATE TABLE user_session (
    id VARCHAR(128) PRIMARY KEY,
    user_id INT,
    session_data TEXT,
    expires_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE
);

-- 시스템 로그 테이블
CREATE TABLE system_log (
    id INT PRIMARY KEY AUTO_INCREMENT,
    level ENUM('INFO', 'WARNING', 'ERROR', 'DEBUG') NOT NULL,
    message TEXT NOT NULL,
    module VARCHAR(50),
    user_id INT,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE SET NULL
);

-- 인덱스 생성
CREATE INDEX idx_classification_result_user_id ON classification_result(user_id);
CREATE INDEX idx_classification_result_created_at ON classification_result(created_at);
CREATE INDEX idx_feedback_classification_result_id ON feedback(classification_result_id);
CREATE INDEX idx_pill_name ON pill(name);
CREATE INDEX idx_pill_korean_name ON pill(korean_name);
CREATE INDEX idx_system_log_created_at ON system_log(created_at);
CREATE INDEX idx_system_log_level ON system_log(level);

-- 샘플 데이터 삽입
INSERT INTO ai_model (name, version, model_path, accuracy, model_size_mb, avg_inference_time_ms) VALUES
('YOLOv8', '1.0', 'models/yolov8_pill.pt', 0.9420, 22, 200),
('MobileNetV3', '1.0', 'models/mobilenet_pill.pt', 0.9180, 9, 150),
('ResNet101', '1.0', 'models/resnet_pill.pt', 0.9610, 170, 300);

INSERT INTO pill (name, korean_name, manufacturer, ingredient, efficacy) VALUES
('Tylenol', '타이레놀', '한국얀센', 'Acetaminophen 500mg', '해열, 진통'),
('Advil', '애드빌', '한국화이자', 'Ibuprofen 200mg', '해열, 진통, 소염'),
('Brufen', '부루펜', '한국아보트', 'Ibuprofen 400mg', '해열, 진통, 소염'),
('Naxen', '낙센', '한국로슈', 'Naproxen 220mg', '해열, 진통, 소염'),
('Benzal', '펜잘', '동아제약', 'Diclofenac 25mg', '진통, 소염');