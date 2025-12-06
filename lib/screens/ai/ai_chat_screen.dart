import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:untitled_2/models/message_model.dart';
import 'package:untitled_2/providers/app_provider.dart';
import 'package:untitled_2/theme.dart';

import 'package:intl/intl.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final String _conversationId = 'default_conversation';
  List<MessageModel> _messages = [];
  bool _isAITyping = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final messages = await provider.messageService.getConversationMessages(_conversationId);
    setState(() => _messages = messages);
    _scrollToBottom();
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

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final provider = Provider.of<AppProvider>(context, listen: false);
    final content = _messageController.text.trim();
    _messageController.clear();

    final userMessage = MessageModel(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: _conversationId,
      senderId: provider.currentUser?.id ?? 'user',
      content: content,
      isAI: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await provider.messageService.sendMessage(userMessage);
    setState(() {
      _messages.add(userMessage);
      _isAITyping = true;
    });
    _scrollToBottom();

    final aiResponse = await provider.messageService.getAIResponse(content, _conversationId);
    if (aiResponse != null) {
      await provider.messageService.sendMessage(aiResponse);
      setState(() {
        _messages.add(aiResponse);
        _isAITyping = false;
      });
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [LightModeColors.lightPrimary, LightModeColors.lightSecondary],
                ),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('🤖', style: TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI Tutor', style: context.textStyles.titleMedium?.semiBold),
                Text(
                  'Online',
                  style: context.textStyles.bodySmall?.copyWith(
                    color: LightModeColors.accentGreen,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: AppSpacing.paddingMd,
              itemCount: _messages.length + (_isAITyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isAITyping) {
                  return const TypingIndicator();
                }
                final message = _messages[index];
                return ChatBubble(message: message);
              },
            ),
          ),
          Container(
            padding: AppSpacing.paddingMd,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.add_circle_outline, color: Theme.of(context).colorScheme.primary),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.mic_outlined, color: Theme.of(context).colorScheme.primary),
                  ),
                  IconButton(
                    onPressed: _sendMessage,
                    icon: Icon(Icons.send, color: Theme.of(context).colorScheme.primary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final MessageModel message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isAI = message.isAI;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        mainAxisAlignment: isAI ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isAI) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [LightModeColors.lightPrimary, LightModeColors.lightSecondary],
                ),
                shape: BoxShape.circle,
              ),
              child: const Center(child: Text('🤖', style: TextStyle(fontSize: 16))),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isAI ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                Container(
                  padding: AppSpacing.paddingMd,
                  decoration: BoxDecoration(
                    color: isAI
                        ? Theme.of(context).colorScheme.surfaceContainerHighest
                        : LightModeColors.lightPrimary,
                    borderRadius: BorderRadius.circular(AppRadius.md).copyWith(
                      topLeft: isAI ? Radius.zero : const Radius.circular(AppRadius.md),
                      topRight: isAI ? const Radius.circular(AppRadius.md) : Radius.zero,
                    ),
                  ),
                  child: Text(
                    message.content,
                    style: context.textStyles.bodyMedium?.copyWith(
                      color: isAI ? Theme.of(context).colorScheme.onSurface : Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  DateFormat('HH:mm').format(message.createdAt),
                  style: context.textStyles.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (!isAI) ...[
            const SizedBox(width: AppSpacing.sm),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: LightModeColors.lightPrimaryContainer,
                shape: BoxShape.circle,
              ),
              child: const Center(child: Text('👤', style: TextStyle(fontSize: 16))),
            ),
          ],
        ],
      ),
    );
  }
}

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [LightModeColors.lightPrimary, LightModeColors.lightSecondary],
              ),
              shape: BoxShape.circle,
            ),
            child: const Center(child: Text('🤖', style: TextStyle(fontSize: 16))),
          ),
          const SizedBox(width: AppSpacing.sm),
          Container(
            padding: AppSpacing.paddingMd,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                3,
                    (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: CircleAvatar(
                    radius: 4,
                    backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
