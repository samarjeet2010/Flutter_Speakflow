import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled_2/models/exercise_model.dart';
import 'package:untitled_2/providers/app_provider.dart';
import 'package:untitled_2/theme.dart';
import 'dart:async';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<ExerciseModel> _exercises = [];
  int _currentIndex = 0;
  String? _selectedAnswer;
  bool _showResult = false;
  int _score = 0;
  int _timeLeft = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadExercises();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadExercises() async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final exercises = await provider.exerciseService.getAllExercises();
    setState(() => _exercises = exercises.take(5).toList());
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _nextQuestion();
      }
    });
  }

  void _checkAnswer() {
    if (_selectedAnswer == null) return;
    setState(() => _showResult = true);
    if (_selectedAnswer == _exercises[_currentIndex].correctAnswer) {
      _score += _exercises[_currentIndex].xpReward;
    }

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) _nextQuestion();
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _exercises.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _showResult = false;
        _timeLeft = 30;
      });
    } else {
      _showResults();
    }
  }

  void _showResults() {
    _timer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Completed! 🎉'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Your Score',
              style: context.textStyles.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '$_score XP',
              style: context.textStyles.displayMedium?.bold.withColor(LightModeColors.accentGreen),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_exercises.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final exercise = _exercises[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        actions: [
          Center(
            child: Padding(
              padding: AppSpacing.horizontalMd,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: _timeLeft < 10 ? Colors.red : LightModeColors.accentAmber,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  '⏱️ $_timeLeft s',
                  style: context.textStyles.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (_currentIndex + 1) / _exercises.length,
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              valueColor: const AlwaysStoppedAnimation(LightModeColors.accentGreen),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.paddingXl,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Question ${_currentIndex + 1}/${_exercises.length}',
                          style: context.textStyles.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          '⭐ ${exercise.xpReward} XP',
                          style: context.textStyles.titleSmall?.bold.withColor(LightModeColors.accentAmber),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Container(
                      width: double.infinity,
                      padding: AppSpacing.paddingLg,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Text(
                        exercise.question,
                        style: context.textStyles.titleLarge?.semiBold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    ...List.generate(exercise.options.length, (index) {
                      final option = exercise.options[index];
                      final isSelected = _selectedAnswer == option;
                      final isCorrect = option == exercise.correctAnswer;

                      Color? backgroundColor;
                      Color? borderColor;

                      if (_showResult && isSelected) {
                        backgroundColor = isCorrect
                            ? LightModeColors.accentGreen.withValues(alpha: 0.1)
                            : LightModeColors.lightError.withValues(alpha: 0.1);
                        borderColor = isCorrect
                            ? LightModeColors.accentGreen
                            : LightModeColors.lightError;
                      } else if (isSelected) {
                        backgroundColor = LightModeColors.lightPrimary.withValues(alpha: 0.1);
                        borderColor = LightModeColors.lightPrimary;
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: InkWell(
                          onTap: _showResult ? null : () => setState(() => _selectedAnswer = option),
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          child: Container(
                            width: double.infinity,
                            padding: AppSpacing.paddingMd,
                            decoration: BoxDecoration(
                              color: backgroundColor ?? Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              border: Border.all(
                                color: borderColor ?? Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? (borderColor ?? LightModeColors.lightPrimary)
                                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      String.fromCharCode(65 + index),
                                      style: context.textStyles.titleSmall?.copyWith(
                                        color: isSelected ? Colors.white : null,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Text(option, style: context.textStyles.bodyLarge),
                                ),
                                if (_showResult && isCorrect)
                                  const Icon(Icons.check_circle, color: LightModeColors.accentGreen),
                                if (_showResult && isSelected && !isCorrect)
                                  const Icon(Icons.cancel, color: LightModeColors.lightError),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: AppSpacing.xl),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _selectedAnswer != null && !_showResult ? _checkAnswer : null,
                        style: FilledButton.styleFrom(
                          padding: AppSpacing.paddingMd,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                        ),
                        child: Text(
                          'Submit Answer',
                          style: context.textStyles.titleMedium?.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
