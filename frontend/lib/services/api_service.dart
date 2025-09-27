import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:60003';
  static const Duration timeoutDuration = Duration(seconds: 30);

  /// 알약 이미지를 서버로 전송하여 AI 분류 결과를 받아옵니다
  Future<Map<String, dynamic>> classifyPill(
    File imageFile, {
    String modelType = 'yolov8',
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/ai/classify');
      final request = http.MultipartRequest('POST', uri);

      // 이미지 파일 추가
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      // 모델 타입 추가
      request.fields['model'] = modelType;

      // 요청 전송
      final streamedResponse = await request.send().timeout(timeoutDuration);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        if (data['success'] == true) {
          return data['result'];
        } else {
          throw Exception(data['error'] ?? '알 수 없는 오류가 발생했습니다');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['error'] ?? 'HTTP ${response.statusCode}');
      }
    } on http.ClientException {
      throw Exception('네트워크 연결을 확인해주세요');
    } on FormatException {
      throw Exception('서버 응답 형식이 올바르지 않습니다');
    } catch (e) {
      throw Exception('분류 실패: $e');
    }
  }

  /// 사용 가능한 AI 모델 목록을 가져옵니다
  Future<List<Map<String, dynamic>>> getAvailableModels() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/ai/models'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['available_models']);
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('모델 목록 조회 실패: $e');
    }
  }

  /// AI 모델 학습 상태를 확인합니다
  Future<Map<String, dynamic>> getTrainingStatus() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/ai/training/status'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('학습 상태 조회 실패: $e');
    }
  }

  /// 서버 상태를 확인합니다
  Future<bool> checkServerHealth() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/health'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}