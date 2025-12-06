import 'package:flutter/material.dart';
import 'package:untitled_2/models/user_model.dart';

import 'package:untitled_2/services/local_storage_service.dart';
import 'package:untitled_2/services/auth_service.dart';
import 'package:untitled_2/services/post_service.dart';
import 'package:untitled_2/services/lesson_service.dart';
import 'package:untitled_2/services/exercise_service.dart';
import 'package:untitled_2/services/flashcard_service.dart';
import 'package:untitled_2/services/voice_room_service.dart';
import 'package:untitled_2/services/achievement_service.dart';
import 'package:untitled_2/services/notifications_service.dart';
import 'package:untitled_2/services/message_service.dart';

class AppProvider with ChangeNotifier {
  // SERVICES
  late LocalStorageService _storage;
  late AuthService _authService;
  late PostService _postService;
  late LessonService _lessonService;
  late ExerciseService _exerciseService;
  late FlashcardService _flashcardService;
  late VoiceRoomService _voiceRoomService;
  late AchievementService _achievementService;
  late NotificationService _notificationService;
  late MessageService _messageService;

  // USER
  UserModel? _currentUser;

  // UI STATES
  bool _isLoading = true;
  int _selectedBottomNavIndex = 0;

  // SETTINGS
  bool _notificationsEnabled = true;
  bool _soundEffectsEnabled = true;
  bool _darkMode = false;

  AppProvider() {
    initialize();
  }

  // GETTERS
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  int get selectedBottomNavIndex => _selectedBottomNavIndex;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get soundEffectsEnabled => _soundEffectsEnabled;
  bool get darkMode => _darkMode;

  AuthService get authService => _authService;
  PostService get postService => _postService;
  LessonService get lessonService => _lessonService;
  ExerciseService get exerciseService => _exerciseService;
  FlashcardService get flashcardService => _flashcardService;
  VoiceRoomService get voiceRoomService => _voiceRoomService;
  AchievementService get achievementService => _achievementService;
  NotificationService get notificationService => _notificationService;
  MessageService get messageService => _messageService;

  // INITIALIZER
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    // Load Local Storage
    _storage = await LocalStorageService.getInstance();

    // Initialize all services
    _authService = AuthService(_storage);
    _postService = PostService(_storage);
    _lessonService = LessonService(_storage);
    _exerciseService = ExerciseService(_storage);
    _flashcardService = FlashcardService(_storage);
    _voiceRoomService = VoiceRoomService(_storage);
    _achievementService = AchievementService(_storage);
    _notificationService = NotificationService(_storage);
    _messageService = MessageService(_storage);

    // Load current user
    _currentUser = await _authService.getCurrentUser();

    // Load settings
    _notificationsEnabled =
        await _storage.getData('settings_notifications') ?? true;

    _soundEffectsEnabled =
        await _storage.getData('settings_sound') ?? true;

    _darkMode =
        await _storage.getData('settings_dark_mode') ?? false;

    _isLoading = false;
    notifyListeners();
  }

  // NAVIGATION
  void setBottomNavIndex(int index) {
    _selectedBottomNavIndex = index;
    notifyListeners();
  }

  // UPDATE USER
  Future<void> updateUser(UserModel user) async {
    await _authService.updateUser(user);
    _currentUser = user;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _currentUser = null;
    notifyListeners();
  }

  // SETTINGS
  Future<void> setNotificationsEnabled(bool value) async {
    _notificationsEnabled = value;
    await _storage.setData('settings_notifications', value);
    notifyListeners();
  }

  Future<void> setSoundEffectsEnabled(bool value) async {
    _soundEffectsEnabled = value;
    await _storage.setData('settings_sound', value);
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _darkMode = value;
    await _storage.setData('settings_dark_mode', value);
    notifyListeners();
  }
}
