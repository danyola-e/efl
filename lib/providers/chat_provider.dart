import 'package:flutter/material.dart';
import '../models/chat.dart';
import '../services/websocket_service.dart';

class ChatProvider with ChangeNotifier {
  final List<ChatMessage> _messages = [];
  ChatWebSocket? _chatSocket;
  bool _isConnected = false;
  String? _typingUser;
  
  List<ChatMessage> get messages => _messages;
  bool get isConnected => _isConnected;
  String? get typingUser => _typingUser;
  
  void connectToChat(int roomId) {
    _chatSocket = ChatWebSocket();
    
    _chatSocket!.onMessage = (data) {
      _handleWebSocketMessage(data);
    };
    
    _chatSocket!.onConnected = () {
      _isConnected = true;
      notifyListeners();
    };
    
    _chatSocket!.onDisconnected = () {
      _isConnected = false;
      notifyListeners();
    };
    
    _chatSocket!.connect('/ws/chat/$roomId/');
  }
  
  void _handleWebSocketMessage(Map<String, dynamic> data) {
    final type = data['type'];
    
    if (type == 'chat_message') {
      final message = ChatMessage.fromJson(data);
      _messages.add(message);
      notifyListeners();
    } else if (type == 'typing') {
      _typingUser = data['username'];
      notifyListeners();
      
      Future.delayed(const Duration(seconds: 3), () {
        if (_typingUser == data['username']) {
          _typingUser = null;
          notifyListeners();
        }
      });
    } else if (type == 'message_deleted') {
      final messageId = data['message_id'];
      _messages.removeWhere((m) => m.id == messageId);
      notifyListeners();
    } else if (type == 'connection_established') {
      print('Chat connected: ${data['message']}');
    }
  }
  
  void sendMessage(String content, int userId, String username) {
    _chatSocket?.sendMessage(content, userId, username);
  }
  
  void sendTyping(String username) {
    _chatSocket?.sendTyping(username);
  }
  
  void deleteMessage(int messageId, int userId) {
    _chatSocket?.deleteMessage(messageId, userId);
  }
  
  void disconnect() {
    _chatSocket?.disconnect();
    _messages.clear();
    _isConnected = false;
    _typingUser = null;
    notifyListeners();
  }
  
  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }
}
