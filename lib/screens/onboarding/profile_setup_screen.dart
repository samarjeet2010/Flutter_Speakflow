import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled_2/models/user_model.dart';
import 'package:untitled_2/providers/app_provider.dart';
import 'package:untitled_2/screens/social/main_navigation.dart';
import 'package:untitled_2/theme.dart';

class ProfileSetupScreen extends StatefulWidget {
  final String nativeLanguage;
  final String targetLanguage;
  final String email;

  const ProfileSetupScreen({
    super.key,
    required this.nativeLanguage,
    required this.targetLanguage,
    required this.email,
  });

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _nameController = TextEditingController();
  String _level = 'Beginner';
  int _dailyGoal = 20;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleComplete() async {
    final provider = Provider.of<AppProvider>(context, listen: false);

    final user = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text.isEmpty ? 'Language Learner' : _nameController.text,
      email: widget.email,
      nativeLanguage: widget.nativeLanguage,
      targetLanguage: widget.targetLanguage,
      level: _level,
      dailyGoalMinutes: _dailyGoal,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await provider.updateUser(user);

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainNavigation()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Setup')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingXl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tell us about yourself',
                style: context.textStyles.headlineMedium?.bold,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'This helps us personalize your learning experience',
                style: context.textStyles.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: LightModeColors.lightPrimaryContainer,
                      child: Text(
                        '👤',
                        style: context.textStyles.displayMedium,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: LightModeColors.lightPrimary,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Your Name',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('Your Level in ${widget.targetLanguage}', style: context.textStyles.titleMedium?.semiBold),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                children: ['Beginner', 'Intermediate', 'Advanced'].map((level) {
                  return ChoiceChip(
                    label: Text(level),
                    selected: _level == level,
                    onSelected: (selected) => setState(() => _level = level),
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('Daily Goal', style: context.textStyles.titleMedium?.semiBold),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                children: [10, 20, 30].map((goal) {
                  return ChoiceChip(
                    label: Text('$goal min'),
                    selected: _dailyGoal == goal,
                    onSelected: (selected) => setState(() => _dailyGoal = goal),
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.xxl),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _handleComplete,
                  style: FilledButton.styleFrom(
                    padding: AppSpacing.paddingMd,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: Text(
                    'Complete Setup',
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
