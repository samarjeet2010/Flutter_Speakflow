class FlashcardModel {
  final String id;
  final String userId;
  final String front;
  final String back;
  final String language;
  final String? example;
  final String difficulty;
  final int reviewCount;
  final DateTime? nextReview;
  final DateTime createdAt;
  final DateTime updatedAt;

  FlashcardModel({
    required this.id,
    required this.userId,
    required this.front,
    required this.back,
    required this.language,
    this.example,
    this.difficulty = 'medium',
    this.reviewCount = 0,
    this.nextReview,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'front': front,
    'back': back,
    'language': language,
    'example': example,
    'difficulty': difficulty,
    'reviewCount': reviewCount,
    'nextReview': nextReview?.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory FlashcardModel.fromJson(Map<String, dynamic> json) => FlashcardModel(
    id: json['id'] as String,
    userId: json['userId'] as String,
    front: json['front'] as String,
    back: json['back'] as String,
    language: json['language'] as String,
    example: json['example'] as String?,
    difficulty: json['difficulty'] as String? ?? 'medium',
    reviewCount: json['reviewCount'] as int? ?? 0,
    nextReview: json['nextReview'] != null ? DateTime.parse(json['nextReview'] as String) : null,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  FlashcardModel copyWith({
    String? id,
    String? userId,
    String? front,
    String? back,
    String? language,
    String? example,
    String? difficulty,
    int? reviewCount,
    DateTime? nextReview,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => FlashcardModel(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    front: front ?? this.front,
    back: back ?? this.back,
    language: language ?? this.language,
    example: example ?? this.example,
    difficulty: difficulty ?? this.difficulty,
    reviewCount: reviewCount ?? this.reviewCount,
    nextReview: nextReview ?? this.nextReview,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
