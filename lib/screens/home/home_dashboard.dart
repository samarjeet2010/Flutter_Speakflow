import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled_2/providers/app_provider.dart';
import 'package:untitled_2/screens/ai/ai_chat_screen.dart';
import 'package:untitled_2/screens/ai/ai_voice_chat_screen.dart';
import 'package:untitled_2/screens/learning/daily_lesson_screen.dart';
import 'package:untitled_2/screens/learning/vocabulary_builder_screen.dart';
import 'package:untitled_2/screens/profile/notifications_screen.dart';
import 'package:untitled_2/theme.dart';

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DashboardHeader(),
              const SizedBox(height: AppSpacing.lg),
              const ProgressSection(),
              const SizedBox(height: AppSpacing.xl),
              const AIShortcuts(),
              const SizedBox(height: AppSpacing.xl),
              const TodayLessonCard(),
              const SizedBox(height: AppSpacing.xl),
              const QuickActions(),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final user = provider.currentUser;
        return Container(
          padding: AppSpacing.paddingXl,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [LightModeColors.lightPrimary, LightModeColors.lightSecondary],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, ${user?.name ?? "Learner"} 👋',
                        style: context.textStyles.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Learning ${user?.targetLanguage ?? "Spanish"}',
                        style: context.textStyles.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                    ),
                    icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class ProgressSection extends StatelessWidget {
  const ProgressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final user = provider.currentUser;
        return Padding(
          padding: AppSpacing.horizontalXl,
          child: Row(
            children: [
              Expanded(
                child: _ProgressCard(
                  icon: '🔥',
                  title: 'Streak',
                  value: '${user?.streak ?? 0} days',
                  color: LightModeColors.accentAmber,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _ProgressCard(
                  icon: '⭐',
                  title: 'XP',
                  value: '${user?.xp ?? 0}',
                  color: LightModeColors.accentGreen,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _ProgressCard(
                  icon: '🏆',
                  title: 'Level',
                  value: user?.level ?? 'Beginner',
                  color: LightModeColors.lightTertiary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final String icon;
  final String title;
  final String value;
  final Color color;

  const _ProgressCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: context.textStyles.titleMedium?.bold.withColor(color),
          ),
          Text(
            title,
            style: context.textStyles.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class AIShortcuts extends StatelessWidget {
  const AIShortcuts({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.horizontalXl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('AI Tutor', style: context.textStyles.titleLarge?.bold),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _AIShortcutCard(
                  icon: Icons.chat_bubble_outline,
                  title: 'Chat',
                  color: LightModeColors.lightPrimary,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AIChatScreen()),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _AIShortcutCard(
                  icon: Icons.mic_outlined,
                  title: 'Voice',
                  color: LightModeColors.lightSecondary,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AIVoiceChatScreen()),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AIShortcutCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _AIShortcutCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: AppSpacing.paddingLg,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withValues(alpha: 0.7)],
          ),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: AppSpacing.sm),
            Text(
              title,
              style: context.textStyles.titleMedium?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class TodayLessonCard extends StatelessWidget {
  const TodayLessonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.horizontalXl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Today\'s Lesson', style: context.textStyles.titleLarge?.bold),
          const SizedBox(height: AppSpacing.md),
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DailyLessonScreen()),
            ),
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: Container(
              padding: AppSpacing.paddingLg,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          LightModeColors.accentGreen.withValues(alpha: 0.2),
                          LightModeColors.accentGreen.withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: const Center(
                      child: Text('📚', style: TextStyle(fontSize: 32)),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Common Greetings',
                          style: context.textStyles.titleMedium?.semiBold,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Learn basic Spanish greetings • 5 min',
                          style: context.textStyles.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.horizontalXl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quick Actions', style: context.textStyles.titleLarge?.bold),
          const SizedBox(height: AppSpacing.md),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            childAspectRatio: 1.5,
            children: [
              _QuickActionCard(
                icon: Icons.style_outlined,
                title: 'Flashcards',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const VocabularyBuilderScreen()),
                ),
              ),
              _QuickActionCard(
                icon: Icons.record_voice_over_outlined,
                title: 'Practice Speaking',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AIVoiceChatScreen()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: AppSpacing.paddingMd,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: AppSpacing.sm),
            Text(
              title,
              style: context.textStyles.bodyMedium?.semiBold,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
