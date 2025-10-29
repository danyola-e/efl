import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  static Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await ApiService.post(
      '/api/users/login/',
      {'username': username, 'password': password},
      auth: false,
    );
    
    final data = ApiService.parseResponse(response);
    
    if (data['token'] != null) {
      await StorageService.saveToken(data['token']);
      await StorageService.saveUser(data['user']);
    }
    
    return data;
  }
  
  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String password2,
    required String firstName,
    required String lastName,
    required String role,
    String? gamertag,
    String? country,
  }) async {
    final response = await ApiService.post(
      '/api/users/register/',
      {
        'username': username,
        'email': email,
        'password': password,
        'password2': password2,
        'first_name': firstName,
        'last_name': lastName,
        'role': role,
        'gamertag': gamertag,
        'country': country,
      },
      auth: false,
    );
    
    final data = ApiService.parseResponse(response);
    
    if (data['token'] != null) {
      await StorageService.saveToken(data['token']);
      await StorageService.saveUser(data['user']);
    }
    
    return data;
  }
  
  static Future<void> logout() async {
    try {
      await ApiService.post('/api/users/logout/', {});
    } catch (e) {
      // Continue with local logout even if API call fails
    }
    
    await StorageService.clearAll();
  }
  
  static Future<User?> getCurrentUser() async {
    final userData = await StorageService.getUser();
    if (userData != null) {
      return User.fromJson(userData);
    }
    return null;
  }
  
  static Future<bool> isLoggedIn() async {
    final token = await StorageService.getToken();
    return token != null;
  }
  
  static Future<User> fetchUserProfile() async {
    final response = await ApiService.get('/api/users/profile/');
    final data = ApiService.parseResponse(response);
    
    await StorageService.saveUser(data);
    return User.fromJson(data);
  }
  
  static Future<User> updateProfile(Map<String, dynamic> updates) async {
    final response = await ApiService.put('/api/users/profile/', updates);
    final data = ApiService.parseResponse(response);
    
    await StorageService.saveUser(data);
    return User.fromJson(data);
  }
}
