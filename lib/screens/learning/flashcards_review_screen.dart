import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled_2/models/flashcard_model.dart';
import 'package:untitled_2/providers/app_provider.dart';
import 'package:untitled_2/theme.dart';

class FlashcardsReviewScreen extends StatefulWidget {
  const FlashcardsReviewScreen({super.key});

  @override
  State<FlashcardsReviewScreen> createState() => _FlashcardsReviewScreenState();
}

class _FlashcardsReviewScreenState extends State<FlashcardsReviewScreen> {
  List<FlashcardModel> _flashcards = [];
  int _currentIndex = 0;
  bool _showBack = false;

  @override
  void initState() {
    super.initState();
    _loadFlashcards();
  }

  Future<void> _loadFlashcards() async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final flashcards = await provider.flashcardService.getAllFlashcards(provider.currentUser!.id);
    setState(() => _flashcards = flashcards);
  }

  void _nextCard() {
    if (_currentIndex < _flashcards.length - 1) {
      setState(() {
        _currentIndex++;
        _showBack = false;
      });
    } else {
      Navigator.pop(context);
    }
  }

  void _previousCard() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _showBack = false;
      });
    }
  }

  void _markDifficulty(String difficulty) {
    final flashcard = _flashcards[_currentIndex];
    final updatedFlashcard = flashcard.copyWith(
      difficulty: difficulty,
      reviewCount: flashcard.reviewCount + 1,
      nextReview: DateTime.now().add(
        difficulty == 'easy' ? const Duration(days: 7) :
        difficulty == 'medium' ? const Duration(days: 3) :
        const Duration(days: 1),
      ),
    );

    final provider = Provider.of<AppProvider>(context, listen: false);
    provider.flashcardService.updateFlashcard(updatedFlashcard);
    _nextCard();
  }

  @override
  Widget build(BuildContext context) {
    if (_flashcards.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Flashcards')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final flashcard = _flashcards[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Flashcards (${_currentIndex + 1}/${_flashcards.length})'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (_currentIndex + 1) / _flashcards.length,
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              valueColor: const AlwaysStoppedAnimation(LightModeColors.accentGreen),
            ),
            Expanded(
              child: Padding(
                padding: AppSpacing.paddingXl,
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.xl),
                    GestureDetector(
                      onTap: () => setState(() => _showBack = !_showBack),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: Container(
                          key: ValueKey(_showBack),
                          width: double.infinity,
                          height: 400,
                          padding: AppSpacing.paddingXl,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: _showBack
                                  ? [LightModeColors.lightSecondary, LightModeColors.lightSecondary.withValues(alpha: 0.7)]
                                  : [LightModeColors.lightPrimary, LightModeColors.lightPrimary.withValues(alpha: 0.7)],
                            ),
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _showBack ? 'Translation' : 'Word',
                                style: context.textStyles.bodyMedium?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xl),
                              Text(
                                _showBack ? flashcard.back : flashcard.front,
                                style: context.textStyles.displayMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              if (_showBack && flashcard.example != null) ...[
                                const SizedBox(height: AppSpacing.xl),
                                Container(
                                  padding: AppSpacing.paddingMd,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(AppRadius.md),
                                  ),
                                  child: Text(
                                    flashcard.example!,
                                    style: context.textStyles.bodyMedium?.copyWith(
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                              const SizedBox(height: AppSpacing.xl),
                              Text(
                                'Tap to flip',
                                style: context.textStyles.bodySmall?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (_showBack) ...[
                      Text(
                        'How difficult was this?',
                        style: context.textStyles.titleMedium?.semiBold,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => _markDifficulty('hard'),
                              style: OutlinedButton.styleFrom(
                                padding: AppSpacing.paddingMd,
                                foregroundColor: LightModeColors.lightError,
                                side: const BorderSide(color: LightModeColors.lightError),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppRadius.md),
                                ),
                              ),
                              child: const Text('Hard'),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => _markDifficulty('medium'),
                              style: OutlinedButton.styleFrom(
                                padding: AppSpacing.paddingMd,
                                foregroundColor: LightModeColors.accentAmber,
                                side: const BorderSide(color: LightModeColors.accentAmber),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppRadius.md),
                                ),
                              ),
                              child: const Text('Medium'),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => _markDifficulty('easy'),
                              style: OutlinedButton.styleFrom(
                                padding: AppSpacing.paddingMd,
                                foregroundColor: LightModeColors.accentGreen,
                                side: const BorderSide(color: LightModeColors.accentGreen),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppRadius.md),
                                ),
                              ),
                              child: const Text('Easy'),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: _currentIndex > 0 ? _previousCard : null,
                          icon: const Icon(Icons.arrow_back),
                        ),
                        IconButton(
                          onPressed: _nextCard,
                          icon: const Icon(Icons.arrow_forward),
                        ),
                      ],
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
