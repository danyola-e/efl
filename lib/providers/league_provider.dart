import 'package:flutter/material.dart';
import '../models/league.dart';
import '../services/api_service.dart';

class LeagueProvider with ChangeNotifier {
  List<League> _leagues = [];
  List<Standing> _standings = [];
  League? _selectedLeague;
  bool _isLoading = false;
  String? _error;
  
  List<League> get leagues => _leagues;
  List<Standing> get standings => _standings;
  League? get selectedLeague => _selectedLeague;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  Future<void> fetchLeagues({String? status}) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      String endpoint = '/api/leagues/competitions/';
      if (status != null) {
        endpoint += '?status=$status';
      }
      
      final response = await ApiService.get(endpoint);
      final data = ApiService.parseListResponse(response);
      
      _leagues = data.map((json) => League.fromJson(json)).toList();
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  Future<void> fetchStandings({int? competitionId, int? divisionId}) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      String endpoint = '/api/leagues/standings/';
      List<String> params = [];
      
      if (competitionId != null) params.add('competition=$competitionId');
      if (divisionId != null) params.add('division=$divisionId');
      
      if (params.isNotEmpty) {
        endpoint += '?${params.join('&')}';
      }
      
      final response = await ApiService.get(endpoint);
      final data = ApiService.parseListResponse(response);
      
      _standings = data.map((json) => Standing.fromJson(json)).toList();
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  void selectLeague(League league) {
    _selectedLeague = league;
    notifyListeners();
  }
  
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
