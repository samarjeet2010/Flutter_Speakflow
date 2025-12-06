class VoiceRoomModel {
  final String id;
  final String name;
  final String category;
  // Primary room language (what participants practice). For backward compatibility,
  // this mirrors learningLanguage when provided.
  final String language;
  final String hostId;
  final String hostName;
  final List<String> participantIds;
  // Current approved speakers (must be subset of participantIds). Host is always a speaker.
  final List<String> speakers;
  // Users who raised hand waiting for host approval
  final List<String> raisedHandIds;
  final int maxParticipants;
  final bool isPublic;
  final DateTime createdAt;
  final DateTime updatedAt;
  // Optional metadata for discovery
  final String? hostNativeLanguage;
  final String? learningLanguage;

  VoiceRoomModel({
    required this.id,
    required this.name,
    required this.category,
    required this.language,
    required this.hostId,
    required this.hostName,
    this.participantIds = const [],
    this.speakers = const [],
    this.raisedHandIds = const [],
    this.maxParticipants = 10,
    this.isPublic = true,
    required this.createdAt,
    required this.updatedAt,
    this.hostNativeLanguage,
    this.learningLanguage,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'language': language,
    'hostId': hostId,
    'hostName': hostName,
    'participantIds': participantIds,
    'speakers': speakers,
    'raisedHandIds': raisedHandIds,
    'maxParticipants': maxParticipants,
    'isPublic': isPublic,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'hostNativeLanguage': hostNativeLanguage,
    'learningLanguage': learningLanguage,
  };

  factory VoiceRoomModel.fromJson(Map<String, dynamic> json) => VoiceRoomModel(
    id: json['id'] as String,
    name: json['name'] as String,
    category: json['category'] as String,
    language: json['language'] as String,
    hostId: json['hostId'] as String,
    hostName: json['hostName'] as String,
    participantIds: (json['participantIds'] as List<dynamic>?)?.cast<String>() ?? [],
    speakers: (json['speakers'] as List<dynamic>?)?.cast<String>() ??
        // Backward compatibility: default speakers to [hostId]
        [json['hostId'] as String],
    raisedHandIds: (json['raisedHandIds'] as List<dynamic>?)?.cast<String>() ?? [],
    maxParticipants: json['maxParticipants'] as int? ?? 10,
    isPublic: json['isPublic'] as bool? ?? true,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
    hostNativeLanguage: json['hostNativeLanguage'] as String?,
    learningLanguage: json['learningLanguage'] as String?,
  );

  VoiceRoomModel copyWith({
    String? id,
    String? name,
    String? category,
    String? language,
    String? hostId,
    String? hostName,
    List<String>? participantIds,
    List<String>? speakers,
    List<String>? raisedHandIds,
    int? maxParticipants,
    bool? isPublic,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? hostNativeLanguage,
    String? learningLanguage,
  }) => VoiceRoomModel(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category ?? this.category,
    language: language ?? this.language,
    hostId: hostId ?? this.hostId,
    hostName: hostName ?? this.hostName,
    participantIds: participantIds ?? this.participantIds,
    speakers: speakers ?? this.speakers,
    raisedHandIds: raisedHandIds ?? this.raisedHandIds,
    maxParticipants: maxParticipants ?? this.maxParticipants,
    isPublic: isPublic ?? this.isPublic,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    hostNativeLanguage: hostNativeLanguage ?? this.hostNativeLanguage,
    learningLanguage: learningLanguage ?? this.learningLanguage,
  );
}
