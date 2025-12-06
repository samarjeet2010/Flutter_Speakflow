import 'package:flutter/foundation.dart';
import 'package:untitled_2/models/notification_model.dart';
import 'package:untitled_2/services/local_storage_service.dart';

class NotificationService {
  static const String _notificationsKey = 'notifications';
  final LocalStorageService _storage;

  NotificationService(this._storage);

  Future<List<NotificationModel>> getUserNotifications(String userId) async {
    try {
      final notificationsData = await _storage.getData(_notificationsKey); // ❗ FIXED

      if (notificationsData == null) {
        final sampleNotifications = _getSampleNotifications(userId);
        await _storage.setData(
          _notificationsKey,
          sampleNotifications.map((n) => n.toJson()).toList(),
        );
        return sampleNotifications;
      }

      final all = (notificationsData as List)
          .map((n) => NotificationModel.fromJson(n as Map<String, dynamic>))
          .toList();

      return all.where((n) => n.userId == userId).toList();
    } catch (e) {
      debugPrint('Error getting notifications: $e');
      return [];
    }
  }

  Future<int> getUnreadCount(String userId) async {
    final notifications = await getUserNotifications(userId);
    return notifications.where((n) => !n.isRead).length;
  }

  Future<bool> markAsRead(String notificationId) async {
    try {
      final notificationsData = await _storage.getData(_notificationsKey); // ❗ FIXED
      if (notificationsData == null) return false;

      final notifications = (notificationsData as List)
          .map((n) => NotificationModel.fromJson(n as Map<String, dynamic>))
          .toList();

      final index = notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        notifications[index] = notifications[index].copyWith(isRead: true);

        await _storage.setData(
          _notificationsKey,
          notifications.map((n) => n.toJson()).toList(),
        );
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
      return false;
    }
  }

  List<NotificationModel> _getSampleNotifications(String userId) {
    final now = DateTime.now();

    return [
      NotificationModel(
        id: 'notif_1',
        userId: userId,
        type: 'follower',
        title: 'New Follower',
        message: 'Maria Garcia started following you',
        isRead: false,
        createdAt: now.subtract(const Duration(hours: 2)),
        updatedAt: now.subtract(const Duration(hours: 2)),
      ),
      NotificationModel(
        id: 'notif_2',
        userId: userId,
        type: 'ai_message',
        title: 'AI Tutor Response',
        message: 'Your AI tutor has a new message for you',
        isRead: false,
        createdAt: now.subtract(const Duration(hours: 5)),
        updatedAt: now.subtract(const Duration(hours: 5)),
      ),
      NotificationModel(
        id: 'notif_3',
        userId: userId,
        type: 'lesson',
        title: 'Lesson Completed',
        message: 'Great job! You completed "Common Greetings"',
        isRead: true,
        createdAt: now.subtract(const Duration(hours: 8)),
        updatedAt: now.subtract(const Duration(hours: 8)),
      ),
      NotificationModel(
        id: 'notif_4',
        userId: userId,
        type: 'reminder',
        title: 'Daily Goal Reminder',
        message: "Don't forget your 20-minute practice today!",
        isRead: true,
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      NotificationModel(
        id: 'notif_5',
        userId: userId,
        type: 'achievement',
        title: 'Achievement Unlocked',
        message: '🔥 Week Warrior - 7-day streak achieved!',
        isRead: true,
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
    ];
  }
}
