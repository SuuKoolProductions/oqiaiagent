import 'package:hive/hive.dart';

part 'wellness_goal.g.dart';

@HiveType(typeId: 2)
class WellnessGoal extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  String category; // 'health', 'nutrition', 'movement', 'sustainability', 'mindfulness'

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime? targetDate;

  @HiveField(6)
  bool isCompleted;

  @HiveField(7)
  int progress; // 0-100

  @HiveField(8)
  String? userId;

  @HiveField(9)
  List<String> milestones = [];

  @HiveField(10)
  Map<String, dynamic> metrics = {};

  @HiveField(11)
  int karmaPointsReward;

  @HiveField(12)
  int carbonCreditsReward;

  @HiveField(13)
  String? aiAgentId;

  @HiveField(14)
  List<String> tags = [];

  @HiveField(15)
  String difficulty; // 'beginner', 'intermediate', 'advanced'

  @HiveField(16)
  Map<String, dynamic>? customData;

  WellnessGoal({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.createdAt,
    this.targetDate,
    this.isCompleted = false,
    this.progress = 0,
    this.userId,
    this.milestones = const [],
    this.metrics = const {},
    this.karmaPointsReward = 0,
    this.carbonCreditsReward = 0,
    this.aiAgentId,
    this.tags = const [],
    this.difficulty = 'beginner',
    this.customData,
  });

  WellnessGoal copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    DateTime? createdAt,
    DateTime? targetDate,
    bool? isCompleted,
    int? progress,
    String? userId,
    List<String>? milestones,
    Map<String, dynamic>? metrics,
    int? karmaPointsReward,
    int? carbonCreditsReward,
    String? aiAgentId,
    List<String>? tags,
    String? difficulty,
    Map<String, dynamic>? customData,
  }) {
    return WellnessGoal(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      targetDate: targetDate ?? this.targetDate,
      isCompleted: isCompleted ?? this.isCompleted,
      progress: progress ?? this.progress,
      userId: userId ?? this.userId,
      milestones: milestones ?? this.milestones,
      metrics: metrics ?? this.metrics,
      karmaPointsReward: karmaPointsReward ?? this.karmaPointsReward,
      carbonCreditsReward: carbonCreditsReward ?? this.carbonCreditsReward,
      aiAgentId: aiAgentId ?? this.aiAgentId,
      tags: tags ?? this.tags,
      difficulty: difficulty ?? this.difficulty,
      customData: customData ?? this.customData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'targetDate': targetDate?.toIso8601String(),
      'isCompleted': isCompleted,
      'progress': progress,
      'userId': userId,
      'milestones': milestones,
      'metrics': metrics,
      'karmaPointsReward': karmaPointsReward,
      'carbonCreditsReward': carbonCreditsReward,
      'aiAgentId': aiAgentId,
      'tags': tags,
      'difficulty': difficulty,
      'customData': customData,
    };
  }

  factory WellnessGoal.fromJson(Map<String, dynamic> json) {
    return WellnessGoal(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      createdAt: DateTime.parse(json['createdAt']),
      targetDate: json['targetDate'] != null ? DateTime.parse(json['targetDate']) : null,
      isCompleted: json['isCompleted'] ?? false,
      progress: json['progress'] ?? 0,
      userId: json['userId'],
      milestones: List<String>.from(json['milestones'] ?? []),
      metrics: Map<String, dynamic>.from(json['metrics'] ?? {}),
      karmaPointsReward: json['karmaPointsReward'] ?? 0,
      carbonCreditsReward: json['carbonCreditsReward'] ?? 0,
      aiAgentId: json['aiAgentId'],
      tags: List<String>.from(json['tags'] ?? []),
      difficulty: json['difficulty'] ?? 'beginner',
      customData: json['customData'],
    );
  }
}