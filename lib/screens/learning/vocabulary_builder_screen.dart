import 'package:flutter/material.dart';
import 'package:untitled_2/screens/learning/flashcards_review_screen.dart';
import 'package:untitled_2/theme.dart';

class VocabularyBuilderScreen extends StatelessWidget {
  const VocabularyBuilderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vocabulary Builder'),
      ),
      body: SafeArea(
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
                      LightModeColors.lightPrimary.withValues(alpha: 0.2),
                      LightModeColors.lightSecondary.withValues(alpha: 0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Column(
                  children: [
                    Text(
                      '12',
                      style: context.textStyles.displayLarge?.bold.withColor(LightModeColors.lightPrimary),
                    ),
                    Text(
                      'Cards to Review Today',
                      style: context.textStyles.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  Expanded(
                    child: _StatsCard(
                      icon: '📚',
                      value: '48',
                      label: 'Total Cards',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _StatsCard(
                      icon: '✅',
                      value: '36',
                      label: 'Mastered',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('Study Sets', style: context.textStyles.titleLarge?.bold),
              const SizedBox(height: AppSpacing.md),
              _StudySetCard(
                title: 'Common Phrases',
                cardCount: 15,
                progress: 0.8,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FlashcardsReviewScreen()),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _StudySetCard(
                title: 'Travel Vocabulary',
                cardCount: 20,
                progress: 0.5,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FlashcardsReviewScreen()),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _StudySetCard(
                title: 'Business Terms',
                cardCount: 13,
                progress: 0.3,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FlashcardsReviewScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FlashcardsReviewScreen()),
        ),
        icon: const Icon(Icons.play_arrow),
        label: const Text('Start Review'),
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  final String icon;
  final String value;
  final String label;

  const _StatsCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
        ),
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

class _StudySetCard extends StatelessWidget {
  final String title;
  final int cardCount;
  final double progress;
  final VoidCallback onTap;

  const _StudySetCard({
    required this.title,
    required this.cardCount,
    required this.progress,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(title, style: context.textStyles.titleMedium?.semiBold),
                ),
                Text(
                  '$cardCount cards',
                  style: context.textStyles.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                valueColor: const AlwaysStoppedAnimation(LightModeColors.accentGreen),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '${(progress * 100).toInt()}% mastered',
              style: context.textStyles.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
