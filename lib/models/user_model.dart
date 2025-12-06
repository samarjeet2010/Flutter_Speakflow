class UserModel {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final String nativeLanguage;
  final String targetLanguage;
  final String level;
  final int dailyGoalMinutes;
  final int streak;
  final int xp;
  final List<String> badges;
  final int followers;
  final int following;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.nativeLanguage,
    required this.targetLanguage,
    required this.level,
    required this.dailyGoalMinutes,
    this.streak = 0,
    this.xp = 0,
    this.badges = const [],
    this.followers = 0,
    this.following = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'photoUrl': photoUrl,
    'nativeLanguage': nativeLanguage,
    'targetLanguage': targetLanguage,
    'level': level,
    'dailyGoalMinutes': dailyGoalMinutes,
    'streak': streak,
    'xp': xp,
    'badges': badges,
    'followers': followers,
    'following': following,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    photoUrl: json['photoUrl'] as String?,
    nativeLanguage: json['nativeLanguage'] as String,
    targetLanguage: json['targetLanguage'] as String,
    level: json['level'] as String,
    dailyGoalMinutes: json['dailyGoalMinutes'] as int,
    streak: json['streak'] as int? ?? 0,
    xp: json['xp'] as int? ?? 0,
    badges: (json['badges'] as List<dynamic>?)?.cast<String>() ?? [],
    followers: json['followers'] as int? ?? 0,
    following: json['following'] as int? ?? 0,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    String? nativeLanguage,
    String? targetLanguage,
    String? level,
    int? dailyGoalMinutes,
    int? streak,
    int? xp,
    List<String>? badges,
    int? followers,
    int? following,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => UserModel(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    photoUrl: photoUrl ?? this.photoUrl,
    nativeLanguage: nativeLanguage ?? this.nativeLanguage,
    targetLanguage: targetLanguage ?? this.targetLanguage,
    level: level ?? this.level,
    dailyGoalMinutes: dailyGoalMinutes ?? this.dailyGoalMinutes,
    streak: streak ?? this.streak,
    xp: xp ?? this.xp,
    badges: badges ?? this.badges,
    followers: followers ?? this.followers,
    following: following ?? this.following,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
