class AchievementModel {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int requiredValue;
  final String type;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.requiredValue,
    required this.type,
    this.isUnlocked = false,
    this.unlockedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'icon': icon,
    'requiredValue': requiredValue,
    'type': type,
    'isUnlocked': isUnlocked,
    'unlockedAt': unlockedAt?.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory AchievementModel.fromJson(Map<String, dynamic> json) => AchievementModel(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    icon: json['icon'] as String,
    requiredValue: json['requiredValue'] as int,
    type: json['type'] as String,
    isUnlocked: json['isUnlocked'] as bool? ?? false,
    unlockedAt: json['unlockedAt'] != null ? DateTime.parse(json['unlockedAt'] as String) : null,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  AchievementModel copyWith({
    String? id,
    String? title,
    String? description,
    String? icon,
    int? requiredValue,
    String? type,
    bool? isUnlocked,
    DateTime? unlockedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => AchievementModel(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    icon: icon ?? this.icon,
    requiredValue: requiredValue ?? this.requiredValue,
    type: type ?? this.type,
    isUnlocked: isUnlocked ?? this.isUnlocked,
    unlockedAt: unlockedAt ?? this.unlockedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
