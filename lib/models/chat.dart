class ChatMessage {
  final int? id;
  final int userId;
  final String username;
  final String content;
  final String messageType;
  final DateTime timestamp;
  final bool isDeleted;
  
  ChatMessage({
    this.id,
    required this.userId,
    required this.username,
    required this.content,
    required this.messageType,
    required this.timestamp,
    this.isDeleted = false,
  });
  
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['message_id'] ?? json['id'],
      userId: json['user_id'],
      username: json['username'],
      content: json['message'] ?? json['content'],
      messageType: json['message_type'] ?? 'text',
      timestamp: json['timestamp'] is String 
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      isDeleted: json['is_deleted'] ?? false,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'content': content,
      'message_type': messageType,
      'timestamp': timestamp.toIso8601String(),
    };
  }
  
  bool get isText => messageType == 'text';
  bool get isImage => messageType == 'image';
  bool get isEmoji => messageType == 'emoji';
}

class ChatRoom {
  final int id;
  final String roomType;
  final int fixtureId;
  final String fixtureName;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final bool isActive;
  
  ChatRoom({
    required this.id,
    required this.roomType,
    required this.fixtureId,
    required this.fixtureName,
    required this.createdAt,
    this.expiresAt,
    required this.isActive,
  });
  
  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'],
      roomType: json['room_type'],
      fixtureId: json['fixture'],
      fixtureName: json['fixture_name'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      expiresAt: json['expires_at'] != null 
          ? DateTime.parse(json['expires_at']) 
          : null,
      isActive: json['is_active'] ?? true,
    );
  }
}
