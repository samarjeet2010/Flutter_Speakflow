import 'package:flutter/material.dart';
import 'package:untitled_2/screens/onboarding/auth_screen.dart';
import 'package:untitled_2/theme.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String? _nativeLanguage;
  String? _targetLanguage;

  final List<Map<String, String>> _languages = [
    {'name': 'English', 'emoji': '🇬🇧'},
    {'name': 'Spanish', 'emoji': '🇪🇸'},
    {'name': 'French', 'emoji': '🇫🇷'},
    {'name': 'German', 'emoji': '🇩🇪'},
    {'name': 'Italian', 'emoji': '🇮🇹'},
    {'name': 'Portuguese', 'emoji': '🇵🇹'},
    {'name': 'Russian', 'emoji': '🇷🇺'},
    {'name': 'Japanese', 'emoji': '🇯🇵'},
    {'name': 'Chinese', 'emoji': '🇨🇳'},
    {'name': 'Korean', 'emoji': '🇰🇷'},
    {'name': 'Arabic', 'emoji': '🇸🇦'},
    {'name': 'Hindi', 'emoji': '🇮🇳'},
    {'name': 'Bengali', 'emoji': '🇧🇩'},
    {'name': 'Urdu', 'emoji': '🇵🇰'},
    {'name': 'Punjabi', 'emoji': '🇮🇳'},
    {'name': 'Turkish', 'emoji': '🇹🇷'},
    {'name': 'Vietnamese', 'emoji': '🇻🇳'},
    {'name': 'Thai', 'emoji': '🇹🇭'},
    {'name': 'Dutch', 'emoji': '🇳🇱'},
    {'name': 'Swedish', 'emoji': '🇸🇪'},
    {'name': 'Norwegian', 'emoji': '🇳🇴'},
    {'name': 'Danish', 'emoji': '🇩🇰'},
    {'name': 'Finnish', 'emoji': '🇫🇮'},
    {'name': 'Polish', 'emoji': '🇵🇱'},
    {'name': 'Czech', 'emoji': '🇨🇿'},
    {'name': 'Greek', 'emoji': '🇬🇷'},
    {'name': 'Hebrew', 'emoji': '🇮🇱'},
    {'name': 'Indonesian', 'emoji': '🇮🇩'},
    {'name': 'Malay', 'emoji': '🇲🇾'},
    {'name': 'Tagalog', 'emoji': '🇵🇭'},
    {'name': 'Tamil', 'emoji': '🇮🇳'},
    {'name': 'Telugu', 'emoji': '🇮🇳'},
    {'name': 'Marathi', 'emoji': '🇮🇳'},
    {'name': 'Gujarati', 'emoji': '🇮🇳'},
    {'name': 'Ukrainian', 'emoji': '🇺🇦'},
    {'name': 'Romanian', 'emoji': '🇷🇴'},
    {'name': 'Hungarian', 'emoji': '🇭🇺'},
    {'name': 'Persian', 'emoji': '🇮🇷'},
    {'name': 'Afrikaans', 'emoji': '🇿🇦'},
    {'name': 'Swahili', 'emoji': '🇰🇪'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Languages'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingXl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose your languages',
                style: context.textStyles.headlineMedium?.bold,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Select the language you speak and the one you want to learn',
                style: context.textStyles.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'I speak:',
                style: context.textStyles.titleLarge?.semiBold,
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                children: _languages.map((lang) {
                  final isSelected = _nativeLanguage == lang['name'];
                  return ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(lang['emoji']!, style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 8),
                        Text(lang['name']!),
                      ],
                    ),
                    selected: isSelected,
                    onSelected: (selected) => setState(() => _nativeLanguage = selected ? lang['name'] : null),
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'I want to learn:',
                style: context.textStyles.titleLarge?.semiBold,
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                children: _languages.map((lang) {
                  final isSelected = _targetLanguage == lang['name'];
                  return ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(lang['emoji']!, style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 8),
                        Text(lang['name']!),
                      ],
                    ),
                    selected: isSelected,
                    onSelected: (selected) => setState(() => _targetLanguage = selected ? lang['name'] : null),
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.xxl),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _nativeLanguage != null && _targetLanguage != null
                      ? () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AuthScreen(
                        nativeLanguage: _nativeLanguage!,
                        targetLanguage: _targetLanguage!,
                      ),
                    ),
                  )
                      : null,
                  style: FilledButton.styleFrom(
                    padding: AppSpacing.paddingMd,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: Text(
                    'Continue',
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
