import 'package:dio/dio.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class QuantSpaceApi {
  late Dio _dio;
  String? _sessionId;

  /// Publicly accessible base URL for image proxying
  late final String baseUrl;

  // Base configuration
  static const String _defaultModel = "gemini/gemini-1.5-flash";
  static const String _masterApiKey = "quantspace-dev-key-123";

  QuantSpaceApi() {
    // Auto-Discovery of Backend URL
    String calculatedBaseUrl = "http://localhost:8000/api/v1";

    // Support Android Emulator access to localhost
    if (!kIsWeb && Platform.isAndroid) {
      calculatedBaseUrl = "http://10.0.2.2:8000/api/v1";
    }

    baseUrl = calculatedBaseUrl;

    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 60),
    ));

    // Add interceptor for consistent Authorization header application
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['Content-Type'] = 'application/json';
        options.headers['Authorization'] = 'Bearer $_masterApiKey';

        if (kDebugMode) {
          print("[QuantSpace API] Request: ${options.method} ${options.path}");
          print("[QuantSpace API] Headers: ${options.headers}");
        }
        return handler.next(options);
      },
    ));
  }

  /// Unified Chat Completion with Session Support
  Future<Map<String, dynamic>> chat(String message, {String? model, bool enableTools = true, List<String>? images}) async {
    try {
      final response = await _dio.post('/chat', data: {
        'messages': [{'role': 'user', 'content': message}],
        'model': model ?? _defaultModel,
        'enable_tools': enableTools,
        'session_id': _sessionId,
        'images': images,
      });

      if (response.data['session_id'] != null) {
        _sessionId = response.data['session_id'];
      }

      return response.data;
    } on DioException catch (e) {
      debugPrint("[QuantSpace API] Chat Error: ${e.response?.data ?? e.message}");
      rethrow;
    }
  }

  /// Fetches the dynamic list of models supported by the backend
  Future<List<dynamic>> getModels() async {
    try {
      final response = await _dio.get('/models');
      return response.data as List<dynamic>;
    } on DioException catch (e) {
      debugPrint("[QuantSpace API] Model Fetch Error: ${e.message}");
      return [];
    }
  }

  /// Specialized: Fetch Weather data
  Future<Map<String, dynamic>> getWeather(String location) async {
    try {
      final response = await _dio.get('/weather/$location');
      return response.data;
    } on DioException catch (e) {
      return {"error": "Could not fetch weather: ${e.message}"};
    }
  }

  /// Specialized: Fetch Financial Indicators
  Future<Map<String, dynamic>> getIndicators(String ticker) async {
    try {
      final response = await _dio.get('/finance/stock/$ticker/indicators');
      return response.data['result'] ?? response.data;
    } catch (e) {
      debugPrint("[QuantSpace API] Finance Error: $e");
      rethrow;
    }
  }

  /// Specialized: Generate AI Image
  Future<String?> generateImage(String prompt) async {
    try {
      final response = await _dio.post('/chat', data: {
        'messages': [{'role': 'user', 'content': "Generate a high-quality AI image: $prompt"}],
        'model': _defaultModel,
        'enable_tools': true,
      });

      final content = response.data['content'] as String;
      final regExp = RegExp(r'!\[.*?\]\((.*?)\)');
      final match = regExp.firstMatch(content);

      return match?.group(1) ?? content;
    } catch (e) {
      debugPrint("[QuantSpace API] Image Gen Error: $e");
      return null;
    }
  }

  /// Clears the current conversation thread and server-side session
  void resetSession() {
    _sessionId = null;
    debugPrint("[QuantSpace API] Session Reset Requested");
  }
}
