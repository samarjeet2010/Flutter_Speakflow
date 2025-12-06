import 'package:flutter/foundation.dart';
import 'package:untitled_2/models/achievement_model.dart';
import 'package:untitled_2/services/local_storage_service.dart';

class AchievementService {
  static const String _achievementsKey = 'achievements';
  final LocalStorageService _storage;

  AchievementService(this._storage);

  Future<List<AchievementModel>> getAllAchievements() async {
    try {
      // ❌ FIXED HERE (no generic type)
      final storedData = await _storage.getData(_achievementsKey);

      if (storedData == null) {
        final sampleAchievements = _getSampleAchievements();

        await _storage.setData(
          _achievementsKey,
          sampleAchievements.map((a) => a.toJson()).toList(),
        );

        return sampleAchievements;
      }

      // Convert each item to AchievementModel
      return (storedData as List)
          .map((json) => AchievementModel.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Error getting achievements: $e');
      return [];
    }
  }

  Future<bool> unlockAchievement(String achievementId) async {
    try {
      final achievements = await getAllAchievements();

      final index = achievements.indexWhere((a) => a.id == achievementId);

      if (index != -1 && !achievements[index].isUnlocked) {
        achievements[index] = achievements[index].copyWith(
          isUnlocked: true,
          unlockedAt: DateTime.now(),
        );

        await _storage.setData(
          _achievementsKey,
          achievements.map((a) => a.toJson()).toList(),
        );

        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Error unlocking achievement: $e');
      return false;
    }
  }

  List<AchievementModel> _getSampleAchievements() {
    final now = DateTime.now();

    return [
      AchievementModel(
        id: 'ach_1',
        title: 'First Steps',
        description: 'Complete your first lesson',
        icon: '🎯',
        requiredValue: 1,
        type: 'lessons',
        isUnlocked: true,
        unlockedAt: now.subtract(const Duration(days: 5)),
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now,
      ),
      AchievementModel(
        id: 'ach_2',
        title: 'Week Warrior',
        description: 'Maintain a 7-day streak',
        icon: '🔥',
        requiredValue: 7,
        type: 'streak',
        isUnlocked: true,
        unlockedAt: now,
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now,
      ),
      AchievementModel(
        id: 'ach_3',
        title: 'Vocabulary Master',
        description: 'Learn 100 new words',
        icon: '📚',
        requiredValue: 100,
        type: 'vocabulary',
        isUnlocked: false,
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now,
      ),
      AchievementModel(
        id: 'ach_4',
        title: 'Social Butterfly',
        description: 'Make 10 posts',
        icon: '🦋',
        requiredValue: 10,
        type: 'social',
        isUnlocked: false,
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now,
      ),
      AchievementModel(
        id: 'ach_5',
        title: 'AI Companion',
        description: 'Chat with AI 50 times',
        icon: '🤖',
        requiredValue: 50,
        type: 'ai_chat',
        isUnlocked: false,
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now,
      ),
      AchievementModel(
        id: 'ach_6',
        title: 'Month Champion',
        description: 'Maintain a 30-day streak',
        icon: '👑',
        requiredValue: 30,
        type: 'streak',
        isUnlocked: false,
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now,
      ),
    ];
  }
}
