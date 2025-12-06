import 'package:flutter/foundation.dart';
import 'package:untitled_2/models/message_model.dart';
import 'package:untitled_2/services/local_storage_service.dart';

class MessageService {
  static const String _messagesKey = 'messages';
  final LocalStorageService _storage;

  MessageService(this._storage);

  Future<List<MessageModel>> getConversationMessages(String conversationId) async {
    try {
      final messagesData = await _storage.getData(_messagesKey); // ❗ FIXED

      if (messagesData == null) {
        final sampleMessages = _getSampleMessages(conversationId);
        await _storage.setData(
          _messagesKey,
          sampleMessages.map((m) => m.toJson()).toList(),
        );
        return sampleMessages;
      }

      final allMessages = (messagesData as List)
          .map((m) => MessageModel.fromJson(m as Map<String, dynamic>))
          .toList();

      return allMessages.where((m) => m.conversationId == conversationId).toList();
    } catch (e) {
      debugPrint('Error getting messages: $e');
      return [];
    }
  }

  Future<bool> sendMessage(MessageModel message) async {
    try {
      final messagesData = await _storage.getData(_messagesKey) ?? []; // ❗ FIXED

      final messages = (messagesData as List)
          .map((m) => MessageModel.fromJson(m as Map<String, dynamic>))
          .toList();

      messages.add(message);

      await _storage.setData(
        _messagesKey,
        messages.map((m) => m.toJson()).toList(),
      );

      return true;
    } catch (e) {
      debugPrint('Error sending message: $e');
      return false;
    }
  }

  Future<MessageModel?> getAIResponse(String userMessage, String conversationId) async {
    await Future.delayed(const Duration(seconds: 1));

    final responses = [
      "That's a great question! Let me explain...",
      "Perfect! Your pronunciation is improving.",
      "Here's a tip: practice this phrase daily.",
      "Excellent work! You're making progress.",
      "Let me help you with that grammar point.",
    ];

    final now = DateTime.now();

    return MessageModel(
      id: 'msg_${now.millisecondsSinceEpoch}',
      conversationId: conversationId,
      senderId: 'ai_tutor',
      content: responses[now.millisecond % responses.length],
      isAI: true,
      createdAt: now,
      updatedAt: now,
    );
  }

  List<MessageModel> _getSampleMessages(String conversationId) {
    final now = DateTime.now();

    return [
      MessageModel(
        id: 'msg_1',
        conversationId: conversationId,
        senderId: 'user_1',
        content: 'Hello! I want to learn Spanish greetings.',
        isAI: false,
        createdAt: now.subtract(const Duration(minutes: 10)),
        updatedAt: now.subtract(const Duration(minutes: 10)),
      ),
      MessageModel(
        id: 'msg_2',
        conversationId: conversationId,
        senderId: 'ai_tutor',
        content:
        "¡Hola! I'd be happy to help you learn Spanish greetings. Let's start with the basics: Hola (Hello), Buenos días (Good morning), Buenas tardes (Good afternoon), and Buenas noches (Good evening).",
        isAI: true,
        createdAt: now.subtract(const Duration(minutes: 9)),
        updatedAt: now.subtract(const Duration(minutes: 9)),
      ),
      MessageModel(
        id: 'msg_3',
        conversationId: conversationId,
        senderId: 'user_1',
        content: 'How do I pronounce "Buenos días"?',
        isAI: false,
        createdAt: now.subtract(const Duration(minutes: 8)),
        updatedAt: now.subtract(const Duration(minutes: 8)),
      ),
      MessageModel(
        id: 'msg_4',
        conversationId: conversationId,
        senderId: 'ai_tutor',
        content:
        'Great question! "Buenos días" is pronounced as "BWEH-nos DEE-as". The stress is on the "DI" syllable. Would you like to practice?',
        isAI: true,
        createdAt: now.subtract(const Duration(minutes: 7)),
        updatedAt: now.subtract(const Duration(minutes: 7)),
      ),
    ];
  }
}
