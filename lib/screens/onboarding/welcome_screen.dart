import 'package:flutter/material.dart';
import 'package:untitled_2/screens/onboarding/language_selection_screen.dart';
import 'package:untitled_2/theme.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'emoji': '🤖',
      'title': 'AI-Powered Learning',
      'description': 'Chat with your personal AI tutor anytime, anywhere. Get instant feedback and personalized lessons.',
    },
    {
      'emoji': '🌍',
      'title': 'Connect Globally',
      'description': 'Join voice rooms and make friends with native speakers from around the world.',
    },
    {
      'emoji': '🎯',
      'title': 'Gamified Experience',
      'description': 'Earn XP, maintain streaks, unlock achievements, and make language learning fun!',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: AppSpacing.paddingMd,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 60),
                  Row(
                    children: List.generate(
                      _pages.length,
                          (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? LightModeColors.lightPrimary
                              : LightModeColors.lightOutline,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const LanguageSelectionScreen()),
                    ),
                    child: Text('Skip', style: context.textStyles.bodyMedium),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: AppSpacing.paddingXl,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                LightModeColors.lightPrimary.withValues(alpha: 0.2),
                                LightModeColors.lightSecondary.withValues(alpha: 0.2),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(80),
                          ),
                          child: Center(
                            child: Text(page['emoji']!, style: const TextStyle(fontSize: 80)),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        Text(
                          page['title']!,
                          style: context.textStyles.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          page['description']!,
                          style: context.textStyles.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: AppSpacing.paddingXl,
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (_currentPage < _pages.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const LanguageSelectionScreen()),
                      );
                    }
                  },
                  style: FilledButton.styleFrom(
                    padding: AppSpacing.paddingMd,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: Text(
                    _currentPage < _pages.length - 1 ? 'Next' : 'Get Started',
                    style: context.textStyles.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
