import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled_2/models/achievement_model.dart';
import 'package:untitled_2/providers/app_provider.dart';
import 'package:untitled_2/theme.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  List<AchievementModel> _achievements = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAchievements();
  }

  Future<void> _loadAchievements() async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final achievements = await provider.achievementService.getAllAchievements();
    setState(() {
      _achievements = achievements;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingXl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: AppSpacing.paddingLg,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      LightModeColors.accentAmber.withValues(alpha: 0.2),
                      LightModeColors.accentAmber.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Column(
                  children: [
                    Text(
                      '${_achievements.where((a) => a.isUnlocked).length}',
                      style: context.textStyles.displayLarge?.bold.withColor(LightModeColors.accentAmber),
                    ),
                    Text(
                      'Achievements Unlocked',
                      style: context.textStyles.bodyLarge,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('Unlocked', style: context.textStyles.titleLarge?.bold),
              const SizedBox(height: AppSpacing.md),
              ...List.generate(
                _achievements.where((a) => a.isUnlocked).length,
                    (index) {
                  final achievement = _achievements.where((a) => a.isUnlocked).toList()[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: AchievementCard(achievement: achievement),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('Locked', style: context.textStyles.titleLarge?.bold),
              const SizedBox(height: AppSpacing.md),
              ...List.generate(
                _achievements.where((a) => !a.isUnlocked).length,
                    (index) {
                  final achievement = _achievements.where((a) => !a.isUnlocked).toList()[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: AchievementCard(achievement: achievement),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AchievementCard extends StatelessWidget {
  final AchievementModel achievement;

  const AchievementCard({super.key, required this.achievement});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: achievement.isUnlocked
            ? Theme.of(context).colorScheme.surface
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: achievement.isUnlocked
              ? LightModeColors.accentAmber.withValues(alpha: 0.3)
              : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: achievement.isUnlocked
                  ? LightModeColors.accentAmber.withValues(alpha: 0.1)
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Center(
              child: Text(
                achievement.icon,
                style: TextStyle(
                  fontSize: 32,
                  color: achievement.isUnlocked ? null : Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: context.textStyles.titleMedium?.semiBold,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  achievement.description,
                  style: context.textStyles.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                if (!achievement.isUnlocked) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Goal: ${achievement.requiredValue}',
                    style: context.textStyles.bodySmall?.copyWith(
                      color: LightModeColors.accentAmber,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (achievement.isUnlocked)
            Icon(
              Icons.check_circle,
              color: LightModeColors.accentGreen,
              size: 28,
            )
          else
            Icon(
              Icons.lock_outline,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 28,
            ),
        ],
      ),
    );
  }
}
