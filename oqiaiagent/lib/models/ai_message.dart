import 'package:hive/hive.dart';

part 'ai_message.g.dart';

@HiveType(typeId: 1)
class AiMessage extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String content;

  @HiveField(2)
  bool isFromUser;

  @HiveField(3)
  DateTime timestamp;

  @HiveField(4)
  String? userId;

  @HiveField(5)
  Map<String, dynamic>? metadata;

  @HiveField(6)
  String? messageType; // 'text', 'suggestion', 'goal', 'reminder'

  @HiveField(7)
  List<String>? suggestedActions;

  @HiveField(8)
  int? karmaPoints;

  @HiveField(9)
  String? carbonImpact;

  AiMessage({
    required this.id,
    required this.content,
    required this.isFromUser,
    required this.timestamp,
    this.userId,
    this.metadata,
    this.messageType = 'text',
    this.suggestedActions,
    this.karmaPoints,
    this.carbonImpact,
  });

  AiMessage copyWith({
    String? id,
    String? content,
    bool? isFromUser,
    DateTime? timestamp,
    String? userId,
    Map<String, dynamic>? metadata,
    String? messageType,
    List<String>? suggestedActions,
    int? karmaPoints,
    String? carbonImpact,
  }) {
    return AiMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      isFromUser: isFromUser ?? this.isFromUser,
      timestamp: timestamp ?? this.timestamp,
      userId: userId ?? this.userId,
      metadata: metadata ?? this.metadata,
      messageType: messageType ?? this.messageType,
      suggestedActions: suggestedActions ?? this.suggestedActions,
      karmaPoints: karmaPoints ?? this.karmaPoints,
      carbonImpact: carbonImpact ?? this.carbonImpact,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'isFromUser': isFromUser,
      'timestamp': timestamp.toIso8601String(),
      'userId': userId,
      'metadata': metadata,
      'messageType': messageType,
      'suggestedActions': suggestedActions,
      'karmaPoints': karmaPoints,
      'carbonImpact': carbonImpact,
    };
  }

  factory AiMessage.fromJson(Map<String, dynamic> json) {
    return AiMessage(
      id: json['id'],
      content: json['content'],
      isFromUser: json['isFromUser'],
      timestamp: DateTime.parse(json['timestamp']),
      userId: json['userId'],
      metadata: json['metadata'],
      messageType: json['messageType'] ?? 'text',
      suggestedActions: json['suggestedActions'] != null 
          ? List<String>.from(json['suggestedActions']) 
          : null,
      karmaPoints: json['karmaPoints'],
      carbonImpact: json['carbonImpact'],
    );
  }
}