class League {
  final int id;
  final String name;
  final String format;
  final String status;
  final DateTime startDate;
  final DateTime? endDate;
  final String? description;
  final String? rules;
  final int? maxPlayers;
  final String? prizePool;
  
  League({
    required this.id,
    required this.name,
    required this.format,
    required this.status,
    required this.startDate,
    this.endDate,
    this.description,
    this.rules,
    this.maxPlayers,
    this.prizePool,
  });
  
  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      id: json['id'],
      name: json['name'],
      format: json['format'],
      status: json['status'],
      startDate: DateTime.parse(json['start_date']),
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      description: json['description'],
      rules: json['rules'],
      maxPlayers: json['max_players'],
      prizePool: json['prize_pool'],
    );
  }
  
  bool get isActive => status == 'active';
  bool get isUpcoming => status == 'upcoming';
  bool get isCompleted => status == 'completed';
}

class Standing {
  final int position;
  final User player;
  final int played;
  final int won;
  final int drawn;
  final int lost;
  final int goalsFor;
  final int goalsAgainst;
  final int goalDifference;
  final int points;
  final String? form;
  
  Standing({
    required this.position,
    required this.player,
    required this.played,
    required this.won,
    required this.drawn,
    required this.lost,
    required this.goalsFor,
    required this.goalsAgainst,
    required this.goalDifference,
    required this.points,
    this.form,
  });
  
  factory Standing.fromJson(Map<String, dynamic> json) {
    return Standing(
      position: json['position'],
      player: User.fromJson(json['player']),
      played: json['played'],
      won: json['won'],
      drawn: json['drawn'],
      lost: json['lost'],
      goalsFor: json['goals_for'],
      goalsAgainst: json['goals_against'],
      goalDifference: json['goal_difference'],
      points: json['points'],
      form: json['form'],
    );
  }
}
