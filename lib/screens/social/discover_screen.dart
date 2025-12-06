import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled_2/models/post_model.dart';
import 'package:untitled_2/providers/app_provider.dart';
import 'package:untitled_2/screens/social/create_post_screen.dart';
import 'package:untitled_2/screens/social/voice_rooms_lobby_screen.dart';
import 'package:untitled_2/theme.dart';
import 'package:intl/intl.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  List<PostModel> _posts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final posts = await provider.postService.getAllPosts();
    setState(() {
      _posts = posts;
      _isLoading = false;
    });
  }

  Future<void> _toggleLike(String postId) async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    await provider.postService.toggleLike(postId);
    _loadPosts();
  }

  Future<void> _toggleBookmark(String postId) async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    await provider.postService.toggleBookmark(postId);
    _loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _loadPosts,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: AppSpacing.paddingMd,
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _TagChip(label: '#Spanish', color: LightModeColors.lightPrimary),
                          const SizedBox(width: AppSpacing.sm),
                          _TagChip(label: '#Grammar', color: LightModeColors.lightSecondary),
                          const SizedBox(width: AppSpacing.sm),
                          _TagChip(label: '#StudyTips', color: LightModeColors.accentGreen),
                          const SizedBox(width: AppSpacing.sm),
                          _TagChip(label: '#Japanese', color: LightModeColors.lightTertiary),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const VoiceRoomsLobbyScreen()),
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      child: Container(
                        width: double.infinity,
                        padding: AppSpacing.paddingMd,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              LightModeColors.lightTertiary.withValues(alpha: 0.2),
                              LightModeColors.lightTertiary.withValues(alpha: 0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(
                            color: LightModeColors.lightTertiary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: LightModeColors.lightTertiary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.record_voice_over, color: Colors.white),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Join Voice Rooms',
                                    style: context.textStyles.titleMedium?.semiBold,
                                  ),
                                  Text(
                                    'Practice speaking with native speakers',
                                    style: context.textStyles.bodySmall?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: LightModeColors.lightTertiary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) => PostCard(
                  post: _posts[index],
                  onLike: () => _toggleLike(_posts[index].id),
                  onBookmark: () => _toggleBookmark(_posts[index].id),
                ),
                childCount: _posts.length,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CreatePostScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  final Color color;

  const _TagChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: color.withValues(alpha: 0.1),
      side: BorderSide(color: color.withValues(alpha: 0.3)),
      labelStyle: context.textStyles.bodyMedium?.copyWith(
        color: color,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback onLike;
  final VoidCallback onBookmark;

  const PostCard({
    super.key,
    required this.post,
    required this.onLike,
    required this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: LightModeColors.lightPrimaryContainer,
                child: Text(
                  post.userName[0],
                  style: context.textStyles.titleMedium?.bold.withColor(LightModeColors.lightPrimary),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.userName, style: context.textStyles.titleSmall?.semiBold),
                    Text(
                      DateFormat('MMM dd, HH:mm').format(post.createdAt),
                      style: context.textStyles.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_horiz, size: 20),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(post.content, style: context.textStyles.bodyMedium),
          if (post.languageTags.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: post.languageTags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: LightModeColors.lightPrimary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Text(
                    tag,
                    style: context.textStyles.bodySmall?.copyWith(
                      color: LightModeColors.lightPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              IconButton(
                onPressed: onLike,
                icon: Icon(
                  post.isLiked ? Icons.favorite : Icons.favorite_outline,
                  color: post.isLiked ? Colors.red : null,
                ),
              ),
              Text('${post.likes}', style: context.textStyles.bodyMedium),
              const SizedBox(width: AppSpacing.md),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.comment_outlined),
              ),
              Text('${post.comments}', style: context.textStyles.bodyMedium),
              const Spacer(),
              IconButton(
                onPressed: onBookmark,
                icon: Icon(
                  post.isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                  color: post.isBookmarked ? LightModeColors.accentAmber : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
