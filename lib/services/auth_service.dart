import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:untitled_2/models/user_model.dart';
import 'package:untitled_2/services/local_storage_service.dart';

class AuthService {
  static const String _currentUserKey = 'current_user';
  static const String _usersKey = 'all_users';
  final LocalStorageService _storage;

  AuthService(this._storage);

  Future<void> _initializeSampleData() async {
    final existingUsers = await _storage.getData<List>(_usersKey);
    if (existingUsers == null) {
      final sampleUsers = _getSampleUsers();
      await _storage.setData(_usersKey, sampleUsers.map((u) => u.toJson()).toList());
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final userData = await _storage.getData<Map<String, dynamic>>(_currentUserKey);
      if (userData == null) {
        await _initializeSampleData();
        final firstUser = _getSampleUsers().first;
        await _storage.setData(_currentUserKey, firstUser.toJson());
        return firstUser;
      }
      return UserModel.fromJson(userData);
    } catch (e) {
      debugPrint('Error getting current user: $e');
      return null;
    }
  }

  Future<bool> updateUser(UserModel user) async {
    try {
      await _storage.setData(_currentUserKey, user.toJson());
      final usersData = await _storage.getData<List>(_usersKey);
      if (usersData != null) {
        final users = usersData.map((u) => UserModel.fromJson(u as Map<String, dynamic>)).toList();
        final index = users.indexWhere((u) => u.id == user.id);
        if (index != -1) {
          users[index] = user;
          await _storage.setData(_usersKey, users.map((u) => u.toJson()).toList());
        }
      }
      return true;
    } catch (e) {
      debugPrint('Error updating user: $e');
      return false;
    }
  }

  Future<bool> signOut() async {
    try {
      await _storage.removeData(_currentUserKey);
      return true;
    } catch (e) {
      debugPrint('Error signing out: $e');
      return false;
    }
  }

  List<UserModel> _getSampleUsers() {
    final now = DateTime.now();
    return [
      UserModel(
        id: 'user_1',
        name: 'Alex Johnson',
        email: 'alex@example.com',
        photoUrl: null,
        nativeLanguage: 'English',
        targetLanguage: 'Spanish',
        level: 'Intermediate',
        dailyGoalMinutes: 20,
        streak: 7,
        xp: 1250,
        badges: ['first_lesson', 'week_streak', 'vocabulary_master'],
        followers: 45,
        following: 32,
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now,
      ),
      UserModel(
        id: 'user_2',
        name: 'Maria Garcia',
        email: 'maria@example.com',
        photoUrl: null,
        nativeLanguage: 'Spanish',
        targetLanguage: 'English',
        level: 'Advanced',
        dailyGoalMinutes: 30,
        streak: 21,
        xp: 3400,
        badges: ['first_lesson', 'month_streak', 'ai_expert'],
        followers: 120,
        following: 85,
        createdAt: now.subtract(const Duration(days: 60)),
        updatedAt: now,
      ),
    ];
  }
}
