import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/chat.dart';

class WebSocketService {
  static String get wsBaseUrl => dotenv.env['WS_BASE_URL'] ?? 'ws://localhost:5000';
  
  WebSocketChannel? _channel;
  Function(Map<String, dynamic>)? onMessage;
  Function()? onConnected;
  Function()? onDisconnected;
  
  bool get isConnected => _channel != null;
  
  void connect(String endpoint) {
    try {
      final url = Uri.parse('$wsBaseUrl$endpoint');
      _channel = WebSocketChannel.connect(url);
      
      _channel!.stream.listen(
        (data) {
          final message = jsonDecode(data);
          onMessage?.call(message);
        },
        onDone: () {
          onDisconnected?.call();
          _channel = null;
        },
        onError: (error) {
          print('WebSocket error: $error');
          onDisconnected?.call();
          _channel = null;
        },
      );
      
      onConnected?.call();
    } catch (e) {
      print('WebSocket connection error: $e');
      onDisconnected?.call();
    }
  }
  
  void send(Map<String, dynamic> message) {
    if (_channel != null) {
      _channel!.sink.add(jsonEncode(message));
    }
  }
  
  void disconnect() {
    _channel?.sink.close();
    _channel = null;
    onDisconnected?.call();
  }
}

class ChatWebSocket extends WebSocketService {
  void sendMessage(String content, int userId, String username, {String messageType = 'text'}) {
    send({
      'type': 'chat_message',
      'content': content,
      'user_id': userId,
      'username': username,
      'message_type': messageType,
    });
  }
  
  void sendTyping(String username) {
    send({
      'type': 'typing',
      'username': username,
    });
  }
  
  void deleteMessage(int messageId, int userId) {
    send({
      'type': 'delete_message',
      'message_id': messageId,
      'user_id': userId,
    });
  }
}

class MatchWebSocket extends WebSocketService {
  void updateScore(int homeScore, int awayScore) {
    send({
      'type': 'score_update',
      'home_score': homeScore,
      'away_score': awayScore,
    });
  }
  
  void sendMatchEvent(Map<String, dynamic> event) {
    send({
      'type': 'match_event',
      'event': event,
    });
  }
  
  void updateStatus(String status) {
    send({
      'type': 'status_change',
      'status': status,
    });
  }
}
