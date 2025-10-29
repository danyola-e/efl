import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/chat_provider.dart';
import '../../providers/auth_provider.dart';
import '../../config/theme.dart';
import '../../models/chat.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int? roomId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (roomId == null) {
      roomId = ModalRoute.of(context)!.settings.arguments as int;
      _connectToChat();
    }
  }

  void _connectToChat() {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.connectToChat(roomId!);
  }

  @override
  void dispose() {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.disconnect();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    if (authProvider.currentUser != null) {
      chatProvider.sendMessage(
        text,
        authProvider.currentUser!.id,
        authProvider.currentUser!.username,
      );

      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Chat'),
        actions: [
          Consumer<ChatProvider>(
            builder: (context, chatProvider, child) {
              return Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: chatProvider.isConnected
                        ? AppTheme.secondaryNeon
                        : Colors.red,
                    boxShadow: [
                      BoxShadow(
                        color: chatProvider.isConnected
                            ? AppTheme.secondaryNeon.withOpacity(0.5)
                            : Colors.red.withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                if (chatProvider.messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color: Colors.white24,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No messages yet',
                          style: TextStyle(color: Colors.white38),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Be the first to say something!',
                          style: TextStyle(color: Colors.white38, fontSize: 12),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: chatProvider.messages.length,
                  itemBuilder: (context, index) {
                    final message = chatProvider.messages[index];
                    final isMyMessage = message.userId == authProvider.currentUser?.id;
                    return _buildMessageBubble(message, isMyMessage);
                  },
                );
              },
            ),
          ),
          
          Consumer<ChatProvider>(
            builder: (context, chatProvider, child) {
              if (chatProvider.typingUser != null &&
                  chatProvider.typingUser != authProvider.currentUser?.username) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    '${chatProvider.typingUser} is typing...',
                    style: TextStyle(
                      color: AppTheme.primaryNeon,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardBg,
              border: Border(
                top: BorderSide(color: AppTheme.borderColor),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (text) {
                      final chatProvider = Provider.of<ChatProvider>(
                        context,
                        listen: false,
                      );
                      if (authProvider.currentUser != null) {
                        chatProvider.sendTyping(authProvider.currentUser!.username);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send, color: AppTheme.primaryNeon),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isMyMessage) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMyMessage) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.primaryNeon,
              child: Text(
                message.username[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isMyMessage)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      message.username,
                      style: TextStyle(
                        color: AppTheme.primaryNeon,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isMyMessage
                        ? AppTheme.primaryNeon.withOpacity(0.2)
                        : AppTheme.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isMyMessage
                          ? AppTheme.primaryNeon.withOpacity(0.5)
                          : AppTheme.borderColor,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.content,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('HH:mm').format(message.timestamp),
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isMyMessage) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.primaryNeon,
              child: Text(
                message.username[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
