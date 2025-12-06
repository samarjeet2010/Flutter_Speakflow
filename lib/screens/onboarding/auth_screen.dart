import 'package:flutter/material.dart';
import 'package:untitled_2/screens/onboarding/profile_setup_screen.dart';
import 'package:untitled_2/theme.dart';

class AuthScreen extends StatefulWidget {
  final String nativeLanguage;
  final String targetLanguage;

  const AuthScreen({
    super.key,
    required this.nativeLanguage,
    required this.targetLanguage,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ProfileSetupScreen(
            nativeLanguage: widget.nativeLanguage,
            targetLanguage: widget.targetLanguage,
            email: _emailController.text,
          ),
        ),
      );
    }
  }

  void _continueWithGoogle() {
    // Simulate Google flow by generating a placeholder email
    final email = 'user${DateTime.now().millisecondsSinceEpoch}@gmail.com';
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ProfileSetupScreen(
          nativeLanguage: widget.nativeLanguage,
          targetLanguage: widget.targetLanguage,
          email: email,
        ),
      ),
    );
  }

  Future<void> _continueWithPhone() async {
    final phoneCtrl = TextEditingController();
    final otpCtrl = TextEditingController();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          top: AppSpacing.lg,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Continue with Phone', style: ctx.textStyles.titleLarge?.bold),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone number', prefixIcon: Icon(Icons.phone_outlined)),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: otpCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'OTP code', prefixIcon: Icon(Icons.lock_clock_outlined)),
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  final phone = phoneCtrl.text.trim();
                  final otp = otpCtrl.text.trim();
                  if (phone.length < 8 || otp.length < 4) {
                    Navigator.of(ctx).maybePop();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter valid phone and OTP')));
                    return;
                  }
                  Navigator.of(ctx).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => ProfileSetupScreen(
                        nativeLanguage: widget.nativeLanguage,
                        targetLanguage: widget.targetLanguage,
                        email: '$phone@phone.user',
                      ),
                    ),
                  );
                },
                child: const Text('Verify & Continue', style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingXl,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.xxl),
                Text(
                  _isLogin ? 'Welcome Back!' : 'Create Account',
                  style: context.textStyles.displaySmall?.bold,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  _isLogin ? 'Sign in to continue your learning journey' : 'Join millions of language learners',
                  style: context.textStyles.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.xl),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _handleSubmit,
                    style: FilledButton.styleFrom(
                      padding: AppSpacing.paddingMd,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                    ),
                    child: Text(
                      _isLogin ? 'Sign In' : 'Sign Up',
                      style: context.textStyles.titleMedium?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(child: Divider(color: Theme.of(context).colorScheme.outline)),
                    Padding(
                      padding: AppSpacing.horizontalMd,
                      child: Text(
                        'OR',
                        style: context.textStyles.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: Theme.of(context).colorScheme.outline)),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _continueWithGoogle,
                    icon: const Text('🔍', style: TextStyle(fontSize: 20)),
                    label: Text('Continue with Google', style: context.textStyles.titleMedium),
                    style: OutlinedButton.styleFrom(
                      padding: AppSpacing.paddingMd,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _continueWithPhone,
                    icon: const Icon(Icons.phone_outlined),
                    label: Text('Continue with Phone', style: context.textStyles.titleMedium),
                    style: OutlinedButton.styleFrom(
                      padding: AppSpacing.paddingMd,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Center(
                  child: TextButton(
                    onPressed: () => setState(() => _isLogin = !_isLogin),
                    child: Text(
                      _isLogin ? "Don't have an account? Sign Up" : "Already have an account? Sign In",
                      style: context.textStyles.bodyMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
