import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'storage_service.dart';

class ApiService {
  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? 'http://localhost:5000';
  
  static Future<Map<String, String>> _getHeaders({bool includeAuth = true}) async {
    final headers = {
      'Content-Type': 'application/json',
    };
    
    if (includeAuth) {
      final token = await StorageService.getToken();
      if (token != null) {
        headers['Authorization'] = 'Token $token';
      }
    }
    
    return headers;
  }
  
  static Future<http.Response> get(String endpoint, {bool auth = true}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders(includeAuth: auth);
    
    try {
      return await http.get(url, headers: headers);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  static Future<http.Response> post(
    String endpoint, 
    Map<String, dynamic> body, 
    {bool auth = true}
  ) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders(includeAuth: auth);
    
    try {
      return await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  static Future<http.Response> put(
    String endpoint, 
    Map<String, dynamic> body, 
    {bool auth = true}
  ) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders(includeAuth: auth);
    
    try {
      return await http.put(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  static Future<http.Response> delete(String endpoint, {bool auth = true}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders(includeAuth: auth);
    
    try {
      return await http.delete(url, headers: headers);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  static Map<String, dynamic> parseResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }
  }
  
  static List<dynamic> parseListResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }
  }
}
