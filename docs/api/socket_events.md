# 🔌 Socket.IO Events Documentation

Pill Magician의 실시간 통신을 위한 Socket.IO 이벤트 문서입니다.

## 📡 Connection
```javascript
const socket = io('http://localhost:60003');
```

## 📤 Client → Server Events

### 1. 연결 이벤트

#### `connect`
클라이언트가 서버에 연결될 때 발생합니다.

```javascript
socket.on('connect', () => {
    console.log('서버에 연결되었습니다:', socket.id);
});
```

#### `disconnect`
클라이언트가 서버에서 연결 해제될 때 발생합니다.

```javascript
socket.on('disconnect', () => {
    console.log('서버와 연결이 해제되었습니다');
});
```

### 2. 분류 요청 이벤트

#### `classify_request`
실시간으로 이미지 분류를 요청합니다.

**Payload:**
```javascript
socket.emit('classify_request', {
    image_data: 'base64_encoded_image_data',
    model: 'yolov8',
    user_id: 123
});
```

### 3. 방 참여 이벤트

#### `join_room`
특정 방에 참여합니다.

**Payload:**
```javascript
socket.emit('join_room', {
    room_id: 'classification_room_123',
    user_id: 123
});
```

## 📥 Server → Client Events

### 1. 분류 결과 이벤트

#### `classification_result`
AI 분류 결과를 클라이언트에게 전송합니다.

**Payload:**
```javascript
socket.on('classification_result', (data) => {
    console.log('분류 결과:', data);
    // data = {
    //     success: true,
    //     result: {
    //         confidence: 0.94,
    //         predicted_pill: '타이레놀',
    //         processing_time: 200
    //     },
    //     timestamp: '2024-11-27T10:30:00Z'
    // }
});
```

### 2. 시스템 상태 이벤트

#### `system_status`
서버의 시스템 상태를 전송합니다.

**Payload:**
```javascript
socket.on('system_status', (data) => {
    console.log('시스템 상태:', data);
    // data = {
    //     status: 'healthy',
    //     active_models: ['yolov8', 'mobilenet', 'resnet'],
    //     server_load: 0.3,
    //     memory_usage: 0.6
    // }
});
```

### 3. 에러 이벤트

#### `error`
처리 중 오류가 발생했을 때 전송됩니다.

**Payload:**
```javascript
socket.on('error', (error) => {
    console.error('에러 발생:', error);
    // error = {
    //     type: 'classification_error',
    //     message: '이미지 처리 중 오류가 발생했습니다',
    //     code: 'IMG_PROCESS_FAILED'
    // }
});
```

### 4. 연결 확인 이벤트

#### `connection_confirmed`
연결이 성공적으로 확립되었을 때 전송됩니다.

**Payload:**
```javascript
socket.on('connection_confirmed', (data) => {
    console.log('연결 확인:', data);
    // data = {
    //     socket_id: 'abc123',
    //     server_time: '2024-11-27T10:30:00Z',
    //     available_features: ['classification', 'realtime_status']
    // }
});
```

## 📝 Usage Examples

### Flutter 앱에서 사용
```dart
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;
  
  void connect() {
    socket = IO.io('http://localhost:60003', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    
    socket.connect();
    
    socket.on('connect', (_) {
      print('Connected to server');
    });
    
    socket.on('classification_result', (data) {
      print('Classification result: $data');
    });
  }
  
  void requestClassification(String imageData, String model) {
    socket.emit('classify_request', {
      'image_data': imageData,
      'model': model,
      'user_id': 123
    });
  }
}
```

### 웹 클라이언트에서 사용
```javascript
const socket = io('http://localhost:60003');

// 연결 확인
socket.on('connect', () => {
    console.log('Connected to server');
});

// 분류 결과 수신
socket.on('classification_result', (data) => {
    updateUI(data.result);
});

// 분류 요청 전송
function classifyImage(imageFile, model = 'yolov8') {
    const reader = new FileReader();
    reader.onload = (e) => {
        socket.emit('classify_request', {
            image_data: e.target.result,
            model: model,
            user_id: getCurrentUserId()
        });
    };
    reader.readAsDataURL(imageFile);
}
```

## 🔧 Error Handling

### 연결 오류 처리
```javascript
socket.on('connect_error', (error) => {
    console.error('Connection failed:', error);
    // 재연결 로직 구현
});
```

### 분류 오류 처리
```javascript
socket.on('error', (error) => {
    if (error.type === 'classification_error') {
        showErrorMessage('이미지 분류에 실패했습니다');
    }
});
```

## 📊 Event Flow

```
Client                          Server
  |                               |
  |--- connect ------------------>|
  |<-- connection_confirmed ------|
  |                               |
  |--- classify_request --------->|
  |                               |--- AI Model Processing
  |<-- classification_result -----|
  |                               |
  |--- disconnect --------------->|
```

## 🛠 Development Notes

- Socket.IO 버전: 4.x
- 네임스페이스: 기본 '/' 사용
- 방(Room) 기능: 사용자별 개별 방 지원
- 인증: 현재 미구현 (추후 JWT 토큰 인증 예정)