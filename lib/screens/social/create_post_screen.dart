import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled_2/models/post_model.dart';
import 'package:untitled_2/providers/app_provider.dart';
import 'package:untitled_2/theme.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _contentController = TextEditingController();
  final List<String> _selectedTags = [];
  final List<String> _availableTags = [
    'Spanish', 'French', 'German', 'Japanese', 'Chinese',
    'Grammar', 'Vocabulary', 'Study Tips', 'Pronunciation', 'Culture'
  ];

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _createPost() async {
    if (_contentController.text.trim().isEmpty) return;

    final provider = Provider.of<AppProvider>(context, listen: false);
    final user = provider.currentUser!;

    final post = PostModel(
      id: 'post_${DateTime.now().millisecondsSinceEpoch}',
      userId: user.id,
      userName: user.name,
      userPhotoUrl: user.photoUrl,
      content: _contentController.text.trim(),
      languageTags: _selectedTags,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await provider.postService.createPost(post);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post created successfully!'),
          backgroundColor: LightModeColors.accentGreen,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        actions: [
          TextButton(
            onPressed: _createPost,
            child: Text(
              'Post',
              style: context.textStyles.titleMedium?.copyWith(
                color: LightModeColors.lightPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingMd,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<AppProvider>(
                    builder: (context, provider, _) {
                      final user = provider.currentUser;
                      return CircleAvatar(
                        radius: 24,
                        backgroundColor: LightModeColors.lightPrimaryContainer,
                        child: Text(
                          user?.name[0] ?? 'U',
                          style: context.textStyles.titleLarge?.bold.withColor(LightModeColors.lightPrimary),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: TextField(
                      controller: _contentController,
                      decoration: const InputDecoration(
                        hintText: "What's on your mind?",
                        border: InputBorder.none,
                      ),
                      maxLines: 8,
                      autofocus: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              const Divider(),
              const SizedBox(height: AppSpacing.md),
              Text('Add Tags', style: context.textStyles.titleMedium?.semiBold),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: _availableTags.map((tag) {
                  final isSelected = _selectedTags.contains(tag);
                  return FilterChip(
                    label: Text(tag),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedTags.add(tag);
                        } else {
                          _selectedTags.remove(tag);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.xl),
              Container(
                padding: AppSpacing.paddingMd,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _MediaButton(
                      icon: Icons.image_outlined,
                      label: 'Photo',
                      onTap: () {},
                    ),
                    _MediaButton(
                      icon: Icons.videocam_outlined,
                      label: 'Video',
                      onTap: () {},
                    ),
                    _MediaButton(
                      icon: Icons.location_on_outlined,
                      label: 'Location',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MediaButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MediaButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Padding(
        padding: AppSpacing.paddingSm,
        child: Column(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              style: context.textStyles.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
