import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 0)
class UserProfile extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? email;

  @HiveField(3)
  int? age;

  @HiveField(4)
  String? location;

  @HiveField(5)
  List<String> priorities = [];

  @HiveField(6)
  List<String> helpAreas = [];

  @HiveField(7)
  String? bio;

  @HiveField(8)
  int karmaPoints = 0;

  @HiveField(9)
  int carbonCredits = 0;

  @HiveField(10)
  DateTime? joinDate;

  @HiveField(11)
  Map<String, dynamic> healthMetrics = {};

  @HiveField(12)
  Map<String, dynamic> sustainabilityMetrics = {};

  @HiveField(13)
  List<String> badges = [];

  @HiveField(14)
  String? aiAgentId;

  @HiveField(15)
  Map<String, dynamic> preferences = {};

  @HiveField(16)
  bool isPremium = false;

  @HiveField(17)
  String? tribeId;

  @HiveField(18)
  List<String> completedChallenges = [];

  @HiveField(19)
  Map<String, int> habitStreaks = {};

  UserProfile({
    this.id,
    this.name,
    this.email,
    this.age,
    this.location,
    this.priorities = const [],
    this.helpAreas = const [],
    this.bio,
    this.karmaPoints = 0,
    this.carbonCredits = 0,
    this.joinDate,
    this.healthMetrics = const {},
    this.sustainabilityMetrics = const {},
    this.badges = const [],
    this.aiAgentId,
    this.preferences = const {},
    this.isPremium = false,
    this.tribeId,
    this.completedChallenges = const [],
    this.habitStreaks = const {},
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    int? age,
    String? location,
    List<String>? priorities,
    List<String>? helpAreas,
    String? bio,
    int? karmaPoints,
    int? carbonCredits,
    DateTime? joinDate,
    Map<String, dynamic>? healthMetrics,
    Map<String, dynamic>? sustainabilityMetrics,
    List<String>? badges,
    String? aiAgentId,
    Map<String, dynamic>? preferences,
    bool? isPremium,
    String? tribeId,
    List<String>? completedChallenges,
    Map<String, int>? habitStreaks,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
      location: location ?? this.location,
      priorities: priorities ?? this.priorities,
      helpAreas: helpAreas ?? this.helpAreas,
      bio: bio ?? this.bio,
      karmaPoints: karmaPoints ?? this.karmaPoints,
      carbonCredits: carbonCredits ?? this.carbonCredits,
      joinDate: joinDate ?? this.joinDate,
      healthMetrics: healthMetrics ?? this.healthMetrics,
      sustainabilityMetrics: sustainabilityMetrics ?? this.sustainabilityMetrics,
      badges: badges ?? this.badges,
      aiAgentId: aiAgentId ?? this.aiAgentId,
      preferences: preferences ?? this.preferences,
      isPremium: isPremium ?? this.isPremium,
      tribeId: tribeId ?? this.tribeId,
      completedChallenges: completedChallenges ?? this.completedChallenges,
      habitStreaks: habitStreaks ?? this.habitStreaks,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'location': location,
      'priorities': priorities,
      'helpAreas': helpAreas,
      'bio': bio,
      'karmaPoints': karmaPoints,
      'carbonCredits': carbonCredits,
      'joinDate': joinDate?.toIso8601String(),
      'healthMetrics': healthMetrics,
      'sustainabilityMetrics': sustainabilityMetrics,
      'badges': badges,
      'aiAgentId': aiAgentId,
      'preferences': preferences,
      'isPremium': isPremium,
      'tribeId': tribeId,
      'completedChallenges': completedChallenges,
      'habitStreaks': habitStreaks,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      age: json['age'],
      location: json['location'],
      priorities: List<String>.from(json['priorities'] ?? []),
      helpAreas: List<String>.from(json['helpAreas'] ?? []),
      bio: json['bio'],
      karmaPoints: json['karmaPoints'] ?? 0,
      carbonCredits: json['carbonCredits'] ?? 0,
      joinDate: json['joinDate'] != null ? DateTime.parse(json['joinDate']) : null,
      healthMetrics: Map<String, dynamic>.from(json['healthMetrics'] ?? {}),
      sustainabilityMetrics: Map<String, dynamic>.from(json['sustainabilityMetrics'] ?? {}),
      badges: List<String>.from(json['badges'] ?? []),
      aiAgentId: json['aiAgentId'],
      preferences: Map<String, dynamic>.from(json['preferences'] ?? {}),
      isPremium: json['isPremium'] ?? false,
      tribeId: json['tribeId'],
      completedChallenges: List<String>.from(json['completedChallenges'] ?? []),
      habitStreaks: Map<String, int>.from(json['habitStreaks'] ?? {}),
    );
  }
}