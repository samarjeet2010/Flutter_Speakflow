import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled_2/models/notification_model.dart';
import 'package:untitled_2/providers/app_provider.dart';
import 'package:untitled_2/theme.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationModel> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final notifications = await provider.notificationService.getUserNotifications(provider.currentUser!.id);
    setState(() {
      _notifications = notifications;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('Mark all read', style: context.textStyles.bodyMedium),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🔔', style: const TextStyle(fontSize: 64)),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No notifications yet',
              style: context.textStyles.titleLarge,
            ),
          ],
        ),
      )
          : ListView.separated(
        padding: AppSpacing.paddingMd,
        itemCount: _notifications.length,
        separatorBuilder: (_, __) => Divider(
          height: 1,
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return NotificationTile(notification: notification);
        },
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;

  const NotificationTile({super.key, required this.notification});

  IconData _getIcon() {
    switch (notification.type) {
      case 'follower':
        return Icons.person_add;
      case 'ai_message':
        return Icons.chat_bubble;
      case 'lesson':
        return Icons.school;
      case 'reminder':
        return Icons.notifications;
      case 'achievement':
        return Icons.emoji_events;
      default:
        return Icons.notifications;
    }
  }

  Color _getColor() {
    switch (notification.type) {
      case 'follower':
        return LightModeColors.lightPrimary;
      case 'ai_message':
        return LightModeColors.lightSecondary;
      case 'lesson':
        return LightModeColors.accentGreen;
      case 'achievement':
        return LightModeColors.accentAmber;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: notification.isRead
          ? null
          : LightModeColors.lightPrimary.withValues(alpha: 0.05),
      padding: AppSpacing.paddingMd,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getColor().withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(_getIcon(), color: _getColor()),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: context.textStyles.titleSmall?.semiBold,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  notification.message,
                  style: context.textStyles.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  DateFormat('MMM dd, HH:mm').format(notification.createdAt),
                  style: context.textStyles.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (!notification.isRead)
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: LightModeColors.lightPrimary,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
