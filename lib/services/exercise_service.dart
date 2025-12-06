import 'package:flutter/foundation.dart';
import 'package:untitled_2/models/exercise_model.dart';
import 'package:untitled_2/services/local_storage_service.dart';

class ExerciseService {
  static const String _exercisesKey = 'exercises';
  final LocalStorageService _storage;

  ExerciseService(this._storage);

  Future<List<ExerciseModel>> getAllExercises() async {
    try {
      final exercisesData = await _storage.getData(_exercisesKey); // FIXED

      if (exercisesData == null) {
        final sampleExercises = _getSampleExercises();
        await _storage.setData(
          _exercisesKey,
          sampleExercises.map((e) => e.toJson()).toList(),
        );
        return sampleExercises;
      }

      return (exercisesData as List)
          .map((e) => ExerciseModel.fromJson(e as Map<String, dynamic>))
          .toList();

    } catch (e) {
      debugPrint('Error getting exercises: $e');
      return [];
    }
  }

  Future<List<ExerciseModel>> getExercisesByType(String type) async {
    final exercises = await getAllExercises();
    return exercises.where((e) => e.type == type).toList();
  }

  List<ExerciseModel> _getSampleExercises() {
    final now = DateTime.now();
    return [
      ExerciseModel(
        id: 'ex_1',
        type: 'multiple_choice',
        title: 'Translate to Spanish',
        question: 'How do you say "Good morning" in Spanish?',
        options: ['Buenas noches', 'Buenos días', 'Buenas tardes', 'Hola'],
        correctAnswer: 'Buenos días',
        language: 'Spanish',
        difficulty: 'Beginner',
        xpReward: 25,
        createdAt: now,
        updatedAt: now,
      ),
      ExerciseModel(
        id: 'ex_2',
        type: 'word_match',
        title: 'Match the Words',
        question: 'Match "libro" with its English translation',
        options: ['House', 'Book', 'Car', 'Table'],
        correctAnswer: 'Book',
        language: 'Spanish',
        difficulty: 'Beginner',
        xpReward: 20,
        createdAt: now,
        updatedAt: now,
      ),
      ExerciseModel(
        id: 'ex_3',
        type: 'sentence_builder',
        title: 'Build a Sentence',
        question: 'Arrange the words: "I / to / went / the / market"',
        options: [
          'I went to the market',
          'Went I to the market',
          'To the market I went',
          'The market I went to'
        ],
        correctAnswer: 'I went to the market',
        language: 'English',
        difficulty: 'Intermediate',
        xpReward: 30,
        createdAt: now,
        updatedAt: now,
      ),
      ExerciseModel(
        id: 'ex_4',
        type: 'listening',
        title: 'Listen and Choose',
        question: 'What does "Me llamo Juan" mean?',
        options: [
          'I am hungry',
          'My name is Juan',
          'I am from Spain',
          'Nice to meet you'
        ],
        correctAnswer: 'My name is Juan',
        language: 'Spanish',
        difficulty: 'Beginner',
        xpReward: 25,
        createdAt: now,
        updatedAt: now,
      ),
      ExerciseModel(
        id: 'ex_5',
        type: 'multiple_choice',
        title: 'Grammar Check',
        question: 'Choose the correct verb form: "Yo ____ español"',
        options: ['habla', 'hablas', 'hablo', 'hablan'],
        correctAnswer: 'hablo',
        language: 'Spanish',
        difficulty: 'Intermediate',
        xpReward: 30,
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }
}
