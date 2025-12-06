class NotificationModel {
  final String id;
  final String userId;
  final String type;
  final String title;
  final String message;
  final bool isRead;
  final Map<String, dynamic>? data;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    this.isRead = false,
    this.data,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'type': type,
    'title': title,
    'message': message,
    'isRead': isRead,
    'data': data,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    id: json['id'] as String,
    userId: json['userId'] as String,
    type: json['type'] as String,
    title: json['title'] as String,
    message: json['message'] as String,
    isRead: json['isRead'] as bool? ?? false,
    data: json['data'] as Map<String, dynamic>?,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  NotificationModel copyWith({
    String? id,
    String? userId,
    String? type,
    String? title,
    String? message,
    bool? isRead,
    Map<String, dynamic>? data,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => NotificationModel(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    type: type ?? this.type,
    title: title ?? this.title,
    message: message ?? this.message,
    isRead: isRead ?? this.isRead,
    data: data ?? this.data,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
