import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Provider
import 'package:untitled_2/providers/app_provider.dart';

// Profile Screens
import 'package:untitled_2/screens/profile/achievement_screen.dart';
import 'package:untitled_2/screens/profile/settings_screen.dart';
import 'package:untitled_2/screens/profile/notifications_screen.dart';

// Theme
import 'package:untitled_2/theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationsScreen()),
            ),
            icon: const Icon(Icons.notifications_outlined),
          ),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Consumer<AppProvider>(
            builder: (context, provider, _) {
              final user = provider.currentUser;
              if (user == null) {
                return const Center(child: CircularProgressIndicator());
              }

              return Column(
                children: [
                  const SizedBox(height: AppSpacing.xl),
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: LightModeColors.lightPrimaryContainer,
                    child: Text(
                      user.name[0],
                      style: context.textStyles.displayMedium?.bold.withColor(LightModeColors.lightPrimary),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(user.name, style: context.textStyles.headlineSmall?.bold),
                  Text(
                    user.email,
                    style: context.textStyles.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Padding(
                    padding: AppSpacing.horizontalXl,
                    child: Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            value: '${user.xp}',
                            label: 'Total XP',
                            icon: '⭐',
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _StatCard(
                            value: '${user.streak}',
                            label: 'Day Streak',
                            icon: '🔥',
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _StatCard(
                            value: '${user.badges.length}',
                            label: 'Badges',
                            icon: '🏆',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Padding(
                    padding: AppSpacing.horizontalXl,
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {},
                            child: Column(
                              children: [
                                Text('${user.followers}', style: context.textStyles.titleLarge?.bold),
                                Text(
                                  'Followers',
                                  style: context.textStyles.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {},
                            child: Column(
                              children: [
                                Text('${user.following}', style: context.textStyles.titleLarge?.bold),
                                Text(
                                  'Following',
                                  style: context.textStyles.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _ProfileSection(
                    title: 'Learning',
                    items: [
                      _ProfileItem(
                        icon: Icons.translate,
                        title: 'Native Language',
                        value: user.nativeLanguage,
                        color: LightModeColors.lightPrimary,
                      ),
                      _ProfileItem(
                        icon: Icons.school,
                        title: 'Learning',
                        value: user.targetLanguage,
                        color: LightModeColors.lightSecondary,
                      ),
                      _ProfileItem(
                        icon: Icons.bar_chart,
                        title: 'Level',
                        value: user.level,
                        color: LightModeColors.accentGreen,
                      ),
                      _ProfileItem(
                        icon: Icons.timer,
                        title: 'Daily Goal',
                        value: '${user.dailyGoalMinutes} min',
                        color: LightModeColors.accentAmber,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _ProfileSection(
                    title: 'Progress',
                    items: [
                      _ProfileItem(
                        icon: Icons.emoji_events,
                        title: 'Achievements',
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        color: LightModeColors.accentAmber,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AchievementsScreen()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final String icon;

  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: AppSpacing.xs),
          Text(value, style: context.textStyles.titleLarge?.bold),
          Text(
            label,
            style: context.textStyles.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final String title;
  final List<_ProfileItem> items;

  const _ProfileSection({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.horizontalXl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: context.textStyles.titleMedium?.semiBold),
          const SizedBox(height: AppSpacing.md),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: List.generate(items.length, (index) {
                final item = items[index];
                return Column(
                  children: [
                    if (index > 0)
                      Divider(
                        height: 1,
                        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                      ),
                    item,
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? value;
  final Widget? trailing;
  final Color color;
  final VoidCallback? onTap;

  const _ProfileItem({
    required this.icon,
    required this.title,
    this.value,
    this.trailing,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Padding(
        padding: AppSpacing.paddingMd,
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(title, style: context.textStyles.bodyMedium),
            ),
            if (value != null)
              Text(
                value!,
                style: context.textStyles.bodyMedium?.semiBold.withColor(color),
              ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
