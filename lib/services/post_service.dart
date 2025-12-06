import 'package:flutter/foundation.dart';
import 'package:untitled_2/models/post_model.dart';
import 'package:untitled_2/services/local_storage_service.dart';

class PostService {
  static const String _postsKey = 'posts';
  final LocalStorageService _storage;

  PostService(this._storage);

  Future<List<PostModel>> getAllPosts() async {
    try {
      final postsData = await _storage.getData(_postsKey);  // ❗ FIXED

      if (postsData == null) {
        final samplePosts = _getSamplePosts();
        await _storage.setData(
          _postsKey,
          samplePosts.map((p) => p.toJson()).toList(),
        );
        return samplePosts;
      }

      return (postsData as List)
          .map((p) => PostModel.fromJson(p as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error getting posts: $e');
      return [];
    }
  }

  Future<bool> createPost(PostModel post) async {
    try {
      final posts = await getAllPosts();
      posts.insert(0, post);

      await _storage.setData(
        _postsKey,
        posts.map((p) => p.toJson()).toList(),
      );
      return true;
    } catch (e) {
      debugPrint('Error creating post: $e');
      return false;
    }
  }

  Future<bool> toggleLike(String postId) async {
    try {
      final posts = await getAllPosts();
      final index = posts.indexWhere((p) => p.id == postId);

      if (index != -1) {
        final post = posts[index];

        posts[index] = post.copyWith(
          isLiked: !post.isLiked,
          likes: post.isLiked ? post.likes - 1 : post.likes + 1,
        );

        await _storage.setData(
          _postsKey,
          posts.map((p) => p.toJson()).toList(),
        );
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error toggling like: $e');
      return false;
    }
  }

  Future<bool> toggleBookmark(String postId) async {
    try {
      final posts = await getAllPosts();
      final index = posts.indexWhere((p) => p.id == postId);

      if (index != -1) {
        posts[index] = posts[index].copyWith(
          isBookmarked: !posts[index].isBookmarked,
        );

        await _storage.setData(
          _postsKey,
          posts.map((p) => p.toJson()).toList(),
        );

        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error toggling bookmark: $e');
      return false;
    }
  }

  List<PostModel> _getSamplePosts() {
    final now = DateTime.now();
    return [
      PostModel(
        id: 'post_1',
        userId: 'user_2',
        userName: 'Maria Garcia',
        userPhotoUrl: null,
        content:
        '¡Hola amigos! 🎉 Just mastered the subjunctive mood in Spanish. Who else finds it challenging?',
        imageUrl: null,
        languageTags: ['Spanish', 'Grammar'],
        likes: 234,
        comments: 45,
        isLiked: false,
        isBookmarked: false,
        createdAt: now.subtract(const Duration(hours: 2)),
        updatedAt: now.subtract(const Duration(hours: 2)),
      ),

      PostModel(
        id: 'post_2',
        userId: 'user_3',
        userName: 'Yuki Tanaka',
        userPhotoUrl: null,
        content:
        'Learning kanji is tough but rewarding! 📚 Here are my favorite study techniques...',
        imageUrl: null,
        languageTags: ['Japanese', 'Study Tips'],
        likes: 456,
        comments: 89,
        isLiked: true,
        isBookmarked: true,
        createdAt: now.subtract(const Duration(hours: 5)),
        updatedAt: now.subtract(const Duration(hours: 5)),
      ),

      PostModel(
        id: 'post_3',
        userId: 'user_4',
        userName: 'Pierre Dubois',
        userPhotoUrl: null,
        content:
        'French idioms that will blow your mind! 🤯 #1: "Avoir le cafard" literally means "to have the cockroach" but it actually means to feel sad!',
        imageUrl: null,
        languageTags: ['French', 'Idioms'],
        likes: 789,
        comments: 123,
        isLiked: false,
        isBookmarked: false,
        createdAt: now.subtract(const Duration(hours: 8)),
        updatedAt: now.subtract(const Duration(hours: 8)),
      ),

      PostModel(
        id: 'post_4',
        userId: 'user_5',
        userName: 'Anna Schmidt',
        userPhotoUrl: null,
        content:
        'German compound words are amazing! Schadenfreude, Fernweh, Wanderlust... 🇩🇪',
        imageUrl: null,
        languageTags: ['German', 'Vocabulary'],
        likes: 567,
        comments: 67,
        isLiked: false,
        isBookmarked: false,
        createdAt: now.subtract(const Duration(hours: 12)),
        updatedAt: now.subtract(const Duration(hours: 12)),
      ),
    ];
  }
}
