class MessageModel {
  final String id;
  final String conversationId;
  final String senderId;
  final String content;
  final bool isAI;
  final String? audioUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    this.isAI = false,
    this.audioUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'conversationId': conversationId,
    'senderId': senderId,
    'content': content,
    'isAI': isAI,
    'audioUrl': audioUrl,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    id: json['id'] as String,
    conversationId: json['conversationId'] as String,
    senderId: json['senderId'] as String,
    content: json['content'] as String,
    isAI: json['isAI'] as bool? ?? false,
    audioUrl: json['audioUrl'] as String?,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  MessageModel copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? content,
    bool? isAI,
    String? audioUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => MessageModel(
    id: id ?? this.id,
    conversationId: conversationId ?? this.conversationId,
    senderId: senderId ?? this.senderId,
    content: content ?? this.content,
    isAI: isAI ?? this.isAI,
    audioUrl: audioUrl ?? this.audioUrl,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
