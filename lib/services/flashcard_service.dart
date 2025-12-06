import 'package:flutter/foundation.dart';
import 'package:untitled_2/models/flashcard_model.dart';
import 'package:untitled_2/services/local_storage_service.dart';

class FlashcardService {
  static const String _flashcardsKey = 'flashcards';
  final LocalStorageService _storage;

  FlashcardService(this._storage);

  Future<List<FlashcardModel>> getAllFlashcards(String userId) async {
    try {
      final flashcardsData = await _storage.getData(_flashcardsKey) as List?;

      if (flashcardsData == null) {
        final sampleFlashcards = _getSampleFlashcards(userId);

        await _storage.setData(
          _flashcardsKey,
          sampleFlashcards.map((f) => f.toJson()).toList(),
        );

        return sampleFlashcards;
      }

      final allCards = flashcardsData
          .map((f) => FlashcardModel.fromJson(Map<String, dynamic>.from(f)))
          .toList();

      return allCards.where((f) => f.userId == userId).toList();
    } catch (e) {
      debugPrint('Error getting flashcards: $e');
      return [];
    }
  }

  Future<List<FlashcardModel>> getDueFlashcards(String userId) async {
    final cards = await getAllFlashcards(userId);
    final now = DateTime.now();

    return cards.where((f) =>
    f.nextReview == null ||
        f.nextReview!.isBefore(now)
    ).toList();
  }

  Future<bool> updateFlashcard(FlashcardModel flashcard) async {
    try {
      final flashcardsData = await _storage.getData(_flashcardsKey) as List?;

      if (flashcardsData == null) return false;

      final flashcards = flashcardsData
          .map((f) => FlashcardModel.fromJson(Map<String, dynamic>.from(f)))
          .toList();

      final index = flashcards.indexWhere((f) => f.id == flashcard.id);

      if (index != -1) {
        flashcards[index] = flashcard;

        await _storage.setData(
          _flashcardsKey,
          flashcards.map((f) => f.toJson()).toList(),
        );

        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Error updating flashcard: $e');
      return false;
    }
  }

  List<FlashcardModel> _getSampleFlashcards(String userId) {
    final now = DateTime.now();

    return [
      FlashcardModel(
        id: 'card_1',
        userId: userId,
        front: 'Hola',
        back: 'Hello',
        language: 'Spanish',
        example: 'Hola, ¿cómo estás?',
        difficulty: 'easy',
        reviewCount: 5,
        nextReview: now.add(const Duration(days: 3)),
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now,
      ),
      FlashcardModel(
        id: 'card_2',
        userId: userId,
        front: 'Gracias',
        back: 'Thank you',
        language: 'Spanish',
        example: 'Muchas gracias por tu ayuda',
        difficulty: 'easy',
        reviewCount: 3,
        nextReview: now.add(const Duration(days: 2)),
        createdAt: now.subtract(const Duration(days: 8)),
        updatedAt: now,
      ),
      FlashcardModel(
        id: 'card_3',
        userId: userId,
        front: 'Por favor',
        back: 'Please',
        language: 'Spanish',
        example: 'Una taza de café, por favor',
        difficulty: 'easy',
        reviewCount: 4,
        nextReview: now.subtract(const Duration(hours: 2)),
        createdAt: now.subtract(const Duration(days: 7)),
        updatedAt: now,
      ),
      FlashcardModel(
        id: 'card_4',
        userId: userId,
        front: 'Lo siento',
        back: 'I am sorry',
        language: 'Spanish',
        example: 'Lo siento, fue mi culpa',
        difficulty: 'medium',
        reviewCount: 2,
        nextReview: now.subtract(const Duration(hours: 5)),
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now,
      ),
      FlashcardModel(
        id: 'card_5',
        userId: userId,
        front: 'De nada',
        back: 'You are welcome',
        language: 'Spanish',
        example: 'De nada, siempre estoy aquí para ayudar',
        difficulty: 'medium',
        reviewCount: 1,
        nextReview: now.subtract(const Duration(days: 1)),
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now,
      ),
    ];
  }
}
