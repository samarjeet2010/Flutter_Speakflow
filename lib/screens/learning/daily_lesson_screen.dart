import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled_2/models/lesson_model.dart';
import 'package:untitled_2/providers/app_provider.dart';
import 'package:untitled_2/theme.dart';

class DailyLessonScreen extends StatefulWidget {
  const DailyLessonScreen({super.key});

  @override
  State<DailyLessonScreen> createState() => _DailyLessonScreenState();
}

class _DailyLessonScreenState extends State<DailyLessonScreen> {
  LessonModel? _lesson;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLesson();
  }

  Future<void> _loadLesson() async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final lesson = await provider.lessonService.getTodayLesson();
    setState(() {
      _lesson = lesson;
      _isLoading = false;
    });
  }

  Future<void> _completeLesson() async {
    if (_lesson == null) return;

    final provider = Provider.of<AppProvider>(context, listen: false);
    await provider.lessonService.markLessonComplete(_lesson!.id);

    final user = provider.currentUser;
    if (user != null) {
      await provider.updateUser(user.copyWith(xp: user.xp + _lesson!.xpReward));
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lesson completed! +${_lesson!.xpReward} XP'),
          backgroundColor: LightModeColors.accentGreen,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_lesson == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Daily Lesson')),
        body: const Center(
          child: Text('No lesson available today'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Lesson'),
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
                      LightModeColors.accentGreen.withValues(alpha: 0.2),
                      LightModeColors.accentGreen.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: LightModeColors.accentGreen,
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Text(
                            _lesson!.difficulty,
                            style: context.textStyles.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '⭐ ${_lesson!.xpReward} XP',
                          style: context.textStyles.titleSmall?.bold.withColor(LightModeColors.accentGreen),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      _lesson!.title,
                      style: context.textStyles.headlineMedium?.bold,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      _lesson!.description,
                      style: context.textStyles.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('Vocabulary', style: context.textStyles.titleLarge?.bold),
              const SizedBox(height: AppSpacing.md),
              ...List.generate(_lesson!.vocabulary.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Container(
                    width: double.infinity,
                    padding: AppSpacing.paddingMd,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: LightModeColors.lightPrimary.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: context.textStyles.titleSmall?.bold.withColor(LightModeColors.lightPrimary),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            _lesson!.vocabulary[index],
                            style: context.textStyles.titleMedium?.semiBold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.volume_up_outlined),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.xl),
              Text('Examples', style: context.textStyles.titleLarge?.bold),
              const SizedBox(height: AppSpacing.md),
              ...List.generate(_lesson!.examples.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Container(
                    width: double.infinity,
                    padding: AppSpacing.paddingMd,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      _lesson!.examples[index],
                      style: context.textStyles.bodyMedium,
                    ),
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.xxl),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _completeLesson,
                  style: FilledButton.styleFrom(
                    padding: AppSpacing.paddingMd,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: Text(
                    'Complete Lesson',
                    style: context.textStyles.titleMedium?.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
