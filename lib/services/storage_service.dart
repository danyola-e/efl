import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  
  static const _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );
  
  static Future<void> saveToken(String token) async {
    await _clearLegacyToken();
    await _secureStorage.write(key: _tokenKey, value: token);
  }
  
  static Future<String?> getToken() async {
    await _migrateLegacyToken();
    return await _secureStorage.read(key: _tokenKey);
  }
  
  static Future<void> saveUser(Map<String, dynamic> userData) async {
    await _clearLegacyUser();
    await _secureStorage.write(key: _userKey, value: jsonEncode(userData));
  }
  
  static Future<Map<String, dynamic>?> getUser() async {
    await _migrateLegacyUser();
    final userJson = await _secureStorage.read(key: _userKey);
    if (userJson != null) {
      return jsonDecode(userJson);
    }
    return null;
  }
  
  static Future<void> clearAll() async {
    await _secureStorage.deleteAll();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
  
  static Future<void> _migrateLegacyToken() async {
    final secureToken = await _secureStorage.read(key: _tokenKey);
    if (secureToken != null) return;
    
    final prefs = await SharedPreferences.getInstance();
    final legacyToken = prefs.getString(_tokenKey);
    
    if (legacyToken != null) {
      await _secureStorage.write(key: _tokenKey, value: legacyToken);
      await prefs.remove(_tokenKey);
    }
  }
  
  static Future<void> _migrateLegacyUser() async {
    final secureUser = await _secureStorage.read(key: _userKey);
    if (secureUser != null) return;
    
    final prefs = await SharedPreferences.getInstance();
    final legacyUser = prefs.getString(_userKey);
    
    if (legacyUser != null) {
      await _secureStorage.write(key: _userKey, value: legacyUser);
      await prefs.remove(_userKey);
    }
  }
  
  static Future<void> _clearLegacyToken() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_tokenKey)) {
      await prefs.remove(_tokenKey);
    }
  }
  
  static Future<void> _clearLegacyUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_userKey)) {
      await prefs.remove(_userKey);
    }
  }
}
