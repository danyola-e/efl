import 'user.dart';

class Match {
  final int id;
  final String matchId;
  final User homePlayer;
  final User awayPlayer;
  final int? homeScore;
  final int? awayScore;
  final String status;
  final DateTime scheduledTime;
  final DateTime? actualStartTime;
  final DateTime? actualEndTime;
  final String competitionName;
  final int competitionId;
  final String? divisionName;
  final String? recordingUrl;
  final bool isVerified;
  final List<Goal>? goals;
  
  Match({
    required this.id,
    required this.matchId,
    required this.homePlayer,
    required this.awayPlayer,
    this.homeScore,
    this.awayScore,
    required this.status,
    required this.scheduledTime,
    this.actualStartTime,
    this.actualEndTime,
    required this.competitionName,
    required this.competitionId,
    this.divisionName,
    this.recordingUrl,
    required this.isVerified,
    this.goals,
  });
  
  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'],
      matchId: json['match_id'],
      homePlayer: User.fromJson(json['home_player']),
      awayPlayer: User.fromJson(json['away_player']),
      homeScore: json['home_score'],
      awayScore: json['away_score'],
      status: json['status'],
      scheduledTime: DateTime.parse(json['scheduled_time']),
      actualStartTime: json['actual_start_time'] != null 
          ? DateTime.parse(json['actual_start_time']) 
          : null,
      actualEndTime: json['actual_end_time'] != null 
          ? DateTime.parse(json['actual_end_time']) 
          : null,
      competitionName: json['competition']['name'],
      competitionId: json['competition']['id'],
      divisionName: json['division']?['name'],
      recordingUrl: json['recording_url'],
      isVerified: json['is_verified'] ?? false,
      goals: json['goals'] != null
          ? (json['goals'] as List).map((g) => Goal.fromJson(g)).toList()
          : null,
    );
  }
  
  bool get isLive => status == 'ongoing';
  bool get isCompleted => status == 'completed';
  bool get isScheduled => status == 'scheduled';
  bool get hasRecording => recordingUrl != null && recordingUrl!.isNotEmpty;
}

class Goal {
  final int id;
  final int playerId;
  final String playerName;
  final int minute;
  final String goalType;
  
  Goal({
    required this.id,
    required this.playerId,
    required this.playerName,
    required this.minute,
    required this.goalType,
  });
  
  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'],
      playerId: json['player'],
      playerName: json['player_name'],
      minute: json['minute'],
      goalType: json['goal_type'],
    );
  }
}
