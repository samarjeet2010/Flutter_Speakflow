import 'package:flutter/foundation.dart';
import 'package:untitled_2/models/lesson_model.dart';
import 'package:untitled_2/services/local_storage_service.dart';

class LessonService {
  static const String _lessonsKey = 'lessons';
  final LocalStorageService _storage;

  LessonService(this._storage);

  Future<List<LessonModel>> getAllLessons() async {
    try {
      final lessonsData = await _storage.getData(_lessonsKey);   // ❗ FIXED (removed <List>)

      if (lessonsData == null) {
        final sampleLessons = _getSampleLessons();
        await _storage.setData(
          _lessonsKey,
          sampleLessons.map((l) => l.toJson()).toList(),
        );
        return sampleLessons;
      }

      return (lessonsData as List)
          .map((l) => LessonModel.fromJson(l as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error getting lessons: $e');
      return [];
    }
  }

  Future<LessonModel?> getTodayLesson() async {
    final lessons = await getAllLessons();
    return lessons.isNotEmpty ? lessons.first : null;
  }

  Future<bool> markLessonComplete(String lessonId) async {
    try {
      final lessons = await getAllLessons();
      final index = lessons.indexWhere((l) => l.id == lessonId);

      if (index != -1) {
        lessons[index] = lessons[index].copyWith(isCompleted: true);

        await _storage.setData(
          _lessonsKey,
          lessons.map((l) => l.toJson()).toList(),
        );
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Error marking lesson complete: $e');
      return false;
    }
  }

  List<LessonModel> _getSampleLessons() {
    final now = DateTime.now();
    return [
      LessonModel(
        id: 'lesson_1',
        title: 'Common Greetings',
        description: 'Learn how to greet people in different situations',
        language: 'Spanish',
        vocabulary: ['Hola', 'Buenos días', 'Buenas tardes', 'Buenas noches', '¿Cómo estás?'],
        examples: [
          'Hola, ¿cómo estás? - Hello, how are you?',
          'Buenos días, señor - Good morning, sir',
          'Buenas tardes - Good afternoon',
        ],
        difficulty: 'Beginner',
        xpReward: 50,
        isCompleted: false,
        createdAt: now,
        updatedAt: now,
      ),
      LessonModel(
        id: 'lesson_2',
        title: 'Past Tense Basics',
        description: 'Master the simple past tense in Spanish',
        language: 'Spanish',
        vocabulary: ['Fui', 'Hice', 'Vi', 'Comí', 'Bebí'],
        examples: [
          'Ayer fui al cine - Yesterday I went to the cinema',
          'Hice mi tarea - I did my homework',
          'Vi una película - I watched a movie',
        ],
        difficulty: 'Intermediate',
        xpReward: 75,
        isCompleted: false,
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      LessonModel(
        id: 'lesson_3',
        title: 'Food & Dining',
        description: 'Learn vocabulary for restaurants and food',
        language: 'Spanish',
        vocabulary: ['Comida', 'Restaurante', 'Menú', 'Cuenta', 'Delicioso'],
        examples: [
          'La comida está deliciosa - The food is delicious',
          '¿Me trae el menú, por favor? - Can you bring me the menu, please?',
          'La cuenta, por favor - The bill, please',
        ],
        difficulty: 'Beginner',
        xpReward: 50,
        isCompleted: true,
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
    ];
  }
}
