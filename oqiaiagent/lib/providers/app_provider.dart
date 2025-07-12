import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_profile.dart';
import '../models/ai_message.dart';
import '../models/wellness_goal.dart';
import '../services/ai_service.dart';

class AppProvider with ChangeNotifier {
  UserProfile? _userProfile;
  List<AiMessage> _conversationHistory = [];
  List<WellnessGoal> _activeGoals = [];
  bool _isLoading = false;
  String? _error;
  
  // Getters
  UserProfile? get userProfile => _userProfile;
  List<AiMessage> get conversationHistory => _conversationHistory;
  List<WellnessGoal> get activeGoals => _activeGoals;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialize Hive and load data
  Future<void> initialize() async {
    await Hive.initFlutter();
    
    // Register adapters
    Hive.registerAdapter(UserProfileAdapter());
    Hive.registerAdapter(AiMessageAdapter());
    Hive.registerAdapter(WellnessGoalAdapter());
    
    // Open boxes
    await Hive.openBox<UserProfile>('userProfile');
    await Hive.openBox<AiMessage>('conversationHistory');
    await Hive.openBox<WellnessGoal>('wellnessGoals');
    
    // Load data
    await _loadUserProfile();
    await _loadConversationHistory();
    await _loadActiveGoals();
  }

  // User Profile Management
  Future<void> _loadUserProfile() async {
    final box = Hive.box<UserProfile>('userProfile');
    _userProfile = box.get('currentUser');
    notifyListeners();
  }

  Future<void> saveUserProfile(UserProfile profile) async {
    final box = Hive.box<UserProfile>('userProfile');
    await box.put('currentUser', profile);
    _userProfile = profile;
    notifyListeners();
  }

  Future<void> updateUserProfile({
    String? name,
    String? email,
    int? age,
    String? location,
    List<String>? priorities,
    List<String>? helpAreas,
    String? bio,
    int? karmaPoints,
    int? carbonCredits,
    List<String>? badges,
    Map<String, dynamic>? healthMetrics,
    Map<String, dynamic>? sustainabilityMetrics,
  }) async {
    if (_userProfile != null) {
      final updatedProfile = _userProfile!.copyWith(
        name: name,
        email: email,
        age: age,
        location: location,
        priorities: priorities,
        helpAreas: helpAreas,
        bio: bio,
        karmaPoints: karmaPoints,
        carbonCredits: carbonCredits,
        badges: badges,
        healthMetrics: healthMetrics,
        sustainabilityMetrics: sustainabilityMetrics,
      );
      await saveUserProfile(updatedProfile);
    }
  }

  // Conversation Management
  Future<void> _loadConversationHistory() async {
    final box = Hive.box<AiMessage>('conversationHistory');
    final messages = box.values.toList();
    _conversationHistory = messages;
    notifyListeners();
  }

  Future<void> addMessage(AiMessage message) async {
    final box = Hive.box<AiMessage>('conversationHistory');
    await box.add(message);
    _conversationHistory.add(message);
    notifyListeners();
  }

  Future<void> sendMessageToAI(String message) async {
    if (_userProfile == null) return;

    // Add user message
    final userMessage = AiMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: message,
      isFromUser: true,
      timestamp: DateTime.now(),
      userId: _userProfile!.id,
    );
    
    await addMessage(userMessage);
    
    // Show loading
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Get AI response
      final aiResponse = await AiService().sendMessage(
        message: message,
        userProfile: _userProfile!,
        conversationHistory: _conversationHistory,
        activeGoals: _activeGoals,
      );
      
      await addMessage(aiResponse);
      
      // Update karma points if awarded
      if (aiResponse.karmaPoints != null && aiResponse.karmaPoints! > 0) {
        await updateUserProfile(
          karmaPoints: (_userProfile!.karmaPoints + aiResponse.karmaPoints!),
        );
      }
      
    } catch (e) {
      _error = 'Failed to get AI response: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Goals Management
  Future<void> _loadActiveGoals() async {
    final box = Hive.box<WellnessGoal>('wellnessGoals');
    final goals = box.values.where((goal) => !goal.isCompleted).toList();
    _activeGoals = goals;
    notifyListeners();
  }

  Future<void> addGoal(WellnessGoal goal) async {
    final box = Hive.box<WellnessGoal>('wellnessGoals');
    await box.add(goal);
    _activeGoals.add(goal);
    notifyListeners();
  }

  Future<void> updateGoalProgress(String goalId, int progress) async {
    final box = Hive.box<WellnessGoal>('wellnessGoals');
    final goalIndex = _activeGoals.indexWhere((goal) => goal.id == goalId);
    
    if (goalIndex != -1) {
      final updatedGoal = _activeGoals[goalIndex].copyWith(progress: progress);
      await box.put(goalIndex, updatedGoal);
      _activeGoals[goalIndex] = updatedGoal;
      notifyListeners();
    }
  }

  Future<void> completeGoal(String goalId) async {
    final box = Hive.box<WellnessGoal>('wellnessGoals');
    final goalIndex = _activeGoals.indexWhere((goal) => goal.id == goalId);
    
    if (goalIndex != -1) {
      final goal = _activeGoals[goalIndex];
      final completedGoal = goal.copyWith(
        isCompleted: true,
        progress: 100,
      );
      
      await box.put(goalIndex, completedGoal);
      _activeGoals.removeAt(goalIndex);
      
      // Award karma points and carbon credits
      if (_userProfile != null) {
        await updateUserProfile(
          karmaPoints: _userProfile!.karmaPoints + goal.karmaPointsReward,
          carbonCredits: _userProfile!.carbonCredits + goal.carbonCreditsReward,
        );
      }
      
      notifyListeners();
    }
  }

  Future<void> generatePersonalizedGoals() async {
    if (_userProfile == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final goals = await AiService().generatePersonalizedGoals(_userProfile!);
      
      for (final goal in goals) {
        await addGoal(goal);
      }
    } catch (e) {
      _error = 'Failed to generate goals: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Karma Points and Carbon Credits
  Future<void> addKarmaPoints(int points) async {
    if (_userProfile != null) {
      await updateUserProfile(
        karmaPoints: _userProfile!.karmaPoints + points,
      );
    }
  }

  Future<void> addCarbonCredits(int credits) async {
    if (_userProfile != null) {
      await updateUserProfile(
        carbonCredits: _userProfile!.carbonCredits + credits,
      );
    }
  }

  // Badges and Achievements
  Future<void> addBadge(String badge) async {
    if (_userProfile != null && !_userProfile!.badges.contains(badge)) {
      final updatedBadges = List<String>.from(_userProfile!.badges)..add(badge);
      await updateUserProfile(badges: updatedBadges);
    }
  }

  // Health and Sustainability Metrics
  Future<void> updateHealthMetrics(Map<String, dynamic> metrics) async {
    if (_userProfile != null) {
      final updatedMetrics = Map<String, dynamic>.from(_userProfile!.healthMetrics);
      updatedMetrics.addAll(metrics);
      await updateUserProfile(healthMetrics: updatedMetrics);
    }
  }

  Future<void> updateSustainabilityMetrics(Map<String, dynamic> metrics) async {
    if (_userProfile != null) {
      final updatedMetrics = Map<String, dynamic>.from(_userProfile!.sustainabilityMetrics);
      updatedMetrics.addAll(metrics);
      await updateUserProfile(sustainabilityMetrics: updatedMetrics);
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Dispose
  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}