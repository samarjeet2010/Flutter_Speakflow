class LessonModel {
  final String id;
  final String title;
  final String description;
  final String language;
  final List<String> vocabulary;
  final List<String> examples;
  final String difficulty;
  final int xpReward;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  LessonModel({
    required this.id,
    required this.title,
    required this.description,
    required this.language,
    required this.vocabulary,
    required this.examples,
    required this.difficulty,
    this.xpReward = 50,
    this.isCompleted = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'language': language,
    'vocabulary': vocabulary,
    'examples': examples,
    'difficulty': difficulty,
    'xpReward': xpReward,
    'isCompleted': isCompleted,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory LessonModel.fromJson(Map<String, dynamic> json) => LessonModel(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    language: json['language'] as String,
    vocabulary: (json['vocabulary'] as List<dynamic>).cast<String>(),
    examples: (json['examples'] as List<dynamic>).cast<String>(),
    difficulty: json['difficulty'] as String,
    xpReward: json['xpReward'] as int? ?? 50,
    isCompleted: json['isCompleted'] as bool? ?? false,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  LessonModel copyWith({
    String? id,
    String? title,
    String? description,
    String? language,
    List<String>? vocabulary,
    List<String>? examples,
    String? difficulty,
    int? xpReward,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => LessonModel(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    language: language ?? this.language,
    vocabulary: vocabulary ?? this.vocabulary,
    examples: examples ?? this.examples,
    difficulty: difficulty ?? this.difficulty,
    xpReward: xpReward ?? this.xpReward,
    isCompleted: isCompleted ?? this.isCompleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
