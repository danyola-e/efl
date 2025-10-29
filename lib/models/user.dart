class User {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final String? profilePicture;
  final String? country;
  final String? gamertag;
  final String? bio;
  final bool isApproved;
  final int? wins;
  final int? losses;
  final int? goalsScored;
  final DateTime dateJoined;
  
  User({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.profilePicture,
    this.country,
    this.gamertag,
    this.bio,
    required this.isApproved,
    this.wins,
    this.losses,
    this.goalsScored,
    required this.dateJoined,
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      role: json['role'],
      profilePicture: json['profile_picture'],
      country: json['country'],
      gamertag: json['gamertag'],
      bio: json['bio'],
      isApproved: json['is_approved'] ?? false,
      wins: json['wins'],
      losses: json['losses'],
      goalsScored: json['goals_scored'],
      dateJoined: DateTime.parse(json['date_joined']),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'role': role,
      'profile_picture': profilePicture,
      'country': country,
      'gamertag': gamertag,
      'bio': bio,
      'is_approved': isApproved,
      'wins': wins,
      'losses': losses,
      'goals_scored': goalsScored,
      'date_joined': dateJoined.toIso8601String(),
    };
  }
  
  String get fullName => '$firstName $lastName'.trim().isEmpty ? username : '$firstName $lastName';
  String get displayName => gamertag ?? username;
  int get totalMatches => (wins ?? 0) + (losses ?? 0);
  double get winRate => totalMatches > 0 ? ((wins ?? 0) / totalMatches * 100) : 0.0;
}
