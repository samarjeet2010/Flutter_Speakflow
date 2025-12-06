class PostModel {
  final String id;
  final String userId;
  final String userName;
  final String? userPhotoUrl;
  final String content;
  final String? imageUrl;
  final List<String> languageTags;
  final int likes;
  final int comments;
  final bool isLiked;
  final bool isBookmarked;
  final DateTime createdAt;
  final DateTime updatedAt;

  PostModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userPhotoUrl,
    required this.content,
    this.imageUrl,
    this.languageTags = const [],
    this.likes = 0,
    this.comments = 0,
    this.isLiked = false,
    this.isBookmarked = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'userName': userName,
    'userPhotoUrl': userPhotoUrl,
    'content': content,
    'imageUrl': imageUrl,
    'languageTags': languageTags,
    'likes': likes,
    'comments': comments,
    'isLiked': isLiked,
    'isBookmarked': isBookmarked,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    id: json['id'] as String,
    userId: json['userId'] as String,
    userName: json['userName'] as String,
    userPhotoUrl: json['userPhotoUrl'] as String?,
    content: json['content'] as String,
    imageUrl: json['imageUrl'] as String?,
    languageTags: (json['languageTags'] as List<dynamic>?)?.cast<String>() ?? [],
    likes: json['likes'] as int? ?? 0,
    comments: json['comments'] as int? ?? 0,
    isLiked: json['isLiked'] as bool? ?? false,
    isBookmarked: json['isBookmarked'] as bool? ?? false,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  PostModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userPhotoUrl,
    String? content,
    String? imageUrl,
    List<String>? languageTags,
    int? likes,
    int? comments,
    bool? isLiked,
    bool? isBookmarked,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PostModel(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    userName: userName ?? this.userName,
    userPhotoUrl: userPhotoUrl ?? this.userPhotoUrl,
    content: content ?? this.content,
    imageUrl: imageUrl ?? this.imageUrl,
    languageTags: languageTags ?? this.languageTags,
    likes: likes ?? this.likes,
    comments: comments ?? this.comments,
    isLiked: isLiked ?? this.isLiked,
    isBookmarked: isBookmarked ?? this.isBookmarked,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
