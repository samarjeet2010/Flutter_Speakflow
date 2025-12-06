import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Models
import 'package:untitled_2/models/exercise_model.dart';

// Providers
import 'package:untitled_2/providers/app_provider.dart';

// Screens
import 'package:untitled_2/screens/learning/quiz_screen.dart';
import 'package:untitled_2/screens/learning/flashcards_review_screen.dart';

// Theme
import 'package:untitled_2/theme.dart';

class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({super.key});

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  List<ExerciseModel> _exercises = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final exercises = await provider.exerciseService.getAllExercises();
    setState(() {
      _exercises = exercises;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice & Exercises'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingXl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Exercise Types', style: context.textStyles.headlineSmall?.bold),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Choose your practice method',
                style: context.textStyles.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              ExerciseTypeCard(
                icon: Icons.quiz_outlined,
                title: 'Quiz',
                description: 'Test your knowledge with multiple choice questions',
                color: LightModeColors.lightPrimary,
                count: _exercises.where((e) => e.type == 'multiple_choice').length,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QuizScreen()),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              ExerciseTypeCard(
                icon: Icons.style_outlined,
                title: 'Flashcards',
                description: 'Review vocabulary with interactive cards',
                color: LightModeColors.lightSecondary,
                count: 12,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FlashcardsReviewScreen()),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              ExerciseTypeCard(
                icon: Icons.build_outlined,
                title: 'Sentence Builder',
                description: 'Arrange words to form correct sentences',
                color: LightModeColors.accentGreen,
                count: _exercises.where((e) => e.type == 'sentence_builder').length,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QuizScreen()),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              ExerciseTypeCard(
                icon: Icons.hearing_outlined,
                title: 'Listening Test',
                description: 'Practice your listening comprehension',
                color: LightModeColors.lightTertiary,
                count: _exercises.where((e) => e.type == 'listening').length,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QuizScreen()),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              ExerciseTypeCard(
                icon: Icons.swap_horiz_outlined,
                title: 'Word Match',
                description: 'Match words with their translations',
                color: LightModeColors.accentAmber,
                count: _exercises.where((e) => e.type == 'word_match').length,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QuizScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExerciseTypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final int count;
  final VoidCallback onTap;

  const ExerciseTypeCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.count,
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
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title, style: context.textStyles.titleMedium?.bold),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Text(
                          '$count',
                          style: context.textStyles.bodySmall?.bold.withColor(color),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    description,
                    style: context.textStyles.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Icon(Icons.arrow_forward_ios, size: 16, color: color),
          ],
        ),
      ),
    );
  }
}
