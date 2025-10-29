import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;
  
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;
  bool get isPlayer => _currentUser?.role == 'player';
  bool get isAdmin => _currentUser?.role == 'admin';
  bool get isFan => _currentUser?.role == 'fan';
  
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _currentUser = await AuthService.getCurrentUser();
    } catch (e) {
      _error = e.toString();
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final result = await AuthService.login(username, password);
      _currentUser = User.fromJson(result['user']);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> register({
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
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final result = await AuthService.register(
        username: username,
        email: email,
        password: password,
        password2: password2,
        firstName: firstName,
        lastName: lastName,
        role: role,
        gamertag: gamertag,
        country: country,
      );
      
      _currentUser = User.fromJson(result['user']);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<void> logout() async {
    await AuthService.logout();
    _currentUser = null;
    notifyListeners();
  }
  
  Future<void> refreshProfile() async {
    try {
      _currentUser = await AuthService.fetchUserProfile();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    }
  }
  
  Future<bool> updateProfile(Map<String, dynamic> updates) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _currentUser = await AuthService.updateProfile(updates);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
