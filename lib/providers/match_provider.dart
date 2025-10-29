import 'package:flutter/material.dart';
import '../models/match.dart';
import '../services/api_service.dart';

class MatchProvider with ChangeNotifier {
  List<Match> _matches = [];
  List<Match> _liveMatches = [];
  Match? _selectedMatch;
  bool _isLoading = false;
  String? _error;
  
  List<Match> get matches => _matches;
  List<Match> get liveMatches => _liveMatches;
  Match? get selectedMatch => _selectedMatch;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  Future<void> fetchMatches({String? status, int? competitionId}) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      String endpoint = '/api/matches/fixtures/';
      List<String> params = [];
      
      if (status != null) params.add('status=$status');
      if (competitionId != null) params.add('competition=$competitionId');
      
      if (params.isNotEmpty) {
        endpoint += '?${params.join('&')}';
      }
      
      final response = await ApiService.get(endpoint);
      final data = ApiService.parseListResponse(response);
      
      _matches = data.map((json) => Match.fromJson(json)).toList();
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  Future<void> fetchLiveMatches() async {
    try {
      final response = await ApiService.get('/api/matches/fixtures/?status=ongoing');
      final data = ApiService.parseListResponse(response);
      
      _liveMatches = data.map((json) => Match.fromJson(json)).toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching live matches: $e');
    }
  }
  
  Future<void> fetchMatchById(int id) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final response = await ApiService.get('/api/matches/fixtures/$id/');
      final data = ApiService.parseResponse(response);
      
      _selectedMatch = Match.fromJson(data);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  Future<bool> updateMatchScore(int matchId, int homeScore, int awayScore) async {
    try {
      await ApiService.put(
        '/api/matches/fixtures/$matchId/',
        {'home_score': homeScore, 'away_score': awayScore},
      );
      
      await fetchMatchById(matchId);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  void updateMatchFromWebSocket(Map<String, dynamic> data) {
    if (_selectedMatch != null && _selectedMatch!.id.toString() == data['id'].toString()) {
      _selectedMatch = Match.fromJson(data);
      notifyListeners();
    }
    
    final index = _matches.indexWhere((m) => m.id.toString() == data['id'].toString());
    if (index != -1) {
      _matches[index] = Match.fromJson(data);
      notifyListeners();
    }
  }
  
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
