class ExerciseModel {
  final String id;
  final String type;
  final String title;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String language;
  final String difficulty;
  final int xpReward;
  final DateTime createdAt;
  final DateTime updatedAt;

  ExerciseModel({
    required this.id,
    required this.type,
    required this.title,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.language,
    required this.difficulty,
    this.xpReward = 25,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'title': title,
    'question': question,
    'options': options,
    'correctAnswer': correctAnswer,
    'language': language,
    'difficulty': difficulty,
    'xpReward': xpReward,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory ExerciseModel.fromJson(Map<String, dynamic> json) => ExerciseModel(
    id: json['id'] as String,
    type: json['type'] as String,
    title: json['title'] as String,
    question: json['question'] as String,
    options: (json['options'] as List<dynamic>).cast<String>(),
    correctAnswer: json['correctAnswer'] as String,
    language: json['language'] as String,
    difficulty: json['difficulty'] as String,
    xpReward: json['xpReward'] as int? ?? 25,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  ExerciseModel copyWith({
    String? id,
    String? type,
    String? title,
    String? question,
    List<String>? options,
    String? correctAnswer,
    String? language,
    String? difficulty,
    int? xpReward,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ExerciseModel(
    id: id ?? this.id,
    type: type ?? this.type,
    title: title ?? this.title,
    question: question ?? this.question,
    options: options ?? this.options,
    correctAnswer: correctAnswer ?? this.correctAnswer,
    language: language ?? this.language,
    difficulty: difficulty ?? this.difficulty,
    xpReward: xpReward ?? this.xpReward,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
