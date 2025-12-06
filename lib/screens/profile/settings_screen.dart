import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled_2/providers/app_provider.dart';
import 'package:untitled_2/screens/social/splash_screen.dart';
import 'package:untitled_2/theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.paddingMd,
          children: [
            _SettingsSection(
              title: 'Account',
              items: [
                _SettingsItem(
                  icon: Icons.person_outline,
                  title: 'Edit Profile',
                  onTap: () {
                    Navigator.of(context).maybePop();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Edit Profile coming soon')));
                  },
                ),
                _SettingsItem(
                  icon: Icons.translate,
                  title: 'Change Languages',
                  onTap: () {
                    Navigator.of(context).maybePop();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Change Languages coming soon')));
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            _SettingsSection(
              title: 'Preferences',
              items: [
                _SettingsItem(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  trailing: Consumer<AppProvider>(
                    builder: (context, provider, _) => Switch(
                      value: provider.notificationsEnabled,
                      onChanged: (v) => provider.setNotificationsEnabled(v),
                    ),
                  ),
                ),
                _SettingsItem(
                  icon: Icons.volume_up_outlined,
                  title: 'Sound Effects',
                  trailing: Consumer<AppProvider>(
                    builder: (context, provider, _) => Switch(
                      value: provider.soundEffectsEnabled,
                      onChanged: (v) => provider.setSoundEffectsEnabled(v),
                    ),
                  ),
                ),
                _SettingsItem(
                  icon: Icons.dark_mode_outlined,
                  title: 'Dark Mode',
                  trailing: Consumer<AppProvider>(
                    builder: (context, provider, _) => Switch(
                      value: provider.darkMode,
                      onChanged: (v) => provider.setDarkMode(v),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            _SettingsSection(
              title: 'Premium',
              items: [
                _SettingsItem(
                  icon: Icons.workspace_premium,
                  title: 'Upgrade to Premium',
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: LightModeColors.accentAmber,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Text(
                      'PRO',
                      style: context.textStyles.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            _SettingsSection(
              title: 'About',
              items: [
                _SettingsItem(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  onTap: () {},
                ),
                _SettingsItem(
                  icon: Icons.info_outline,
                  title: 'About',
                  trailing: Text(
                    'v1.0.0',
                    style: context.textStyles.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  onTap: () {},
                ),
                _SettingsItem(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            Padding(
              padding: AppSpacing.horizontalXl,
              child: OutlinedButton(
                onPressed: () async {
                  final provider = Provider.of<AppProvider>(context, listen: false);
                  await provider.signOut();
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const SplashScreen()),
                          (route) => false,
                    );
                  }
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: LightModeColors.lightError,
                  side: const BorderSide(color: LightModeColors.lightError),
                  padding: AppSpacing.paddingMd,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
                child: const Text('Sign Out'),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<_SettingsItem> items;

  const _SettingsSection({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppSpacing.horizontalMd,
          child: Text(
            title,
            style: context.textStyles.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            children: List.generate(items.length, (index) {
              return Column(
                children: [
                  if (index > 0)
                    Divider(
                      height: 1,
                      color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  items[index],
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsItem({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Padding(
        padding: AppSpacing.paddingMd,
        child: Row(
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(title, style: context.textStyles.bodyMedium),
            ),
            if (trailing != null)
              trailing!
            else if (onTap != null)
              const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
