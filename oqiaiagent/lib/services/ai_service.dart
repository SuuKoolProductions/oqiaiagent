import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ai_message.dart';
import '../models/user_profile.dart';
import '../models/wellness_goal.dart';

class AiService {
  static const String _baseUrl = 'https://api.openai.com/v1';
  static const String _model = 'gpt-4o';
  
  // In production, this should be stored securely
  static const String _apiKey = 'YOUR_OPENAI_API_KEY';

  static final AiService _instance = AiService._internal();
  factory AiService() => _instance;
  AiService._internal();

  Future<AiMessage> sendMessage({
    required String message,
    required UserProfile userProfile,
    List<AiMessage> conversationHistory = const [],
    List<WellnessGoal> activeGoals = const [],
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': _buildMessages(
            message: message,
            userProfile: userProfile,
            conversationHistory: conversationHistory,
            activeGoals: activeGoals,
          ),
          'max_tokens': 1000,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final aiResponse = data['choices'][0]['message']['content'];
        
        return AiMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: aiResponse,
          isFromUser: false,
          timestamp: DateTime.now(),
          userId: userProfile.id,
          messageType: 'text',
          karmaPoints: _extractKarmaPoints(aiResponse),
          carbonImpact: _extractCarbonImpact(aiResponse),
          suggestedActions: _extractSuggestedActions(aiResponse),
        );
      } else {
        throw Exception('Failed to get AI response: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback response if API fails
      return AiMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: _getFallbackResponse(message),
        isFromUser: false,
        timestamp: DateTime.now(),
        userId: userProfile.id,
        messageType: 'text',
      );
    }
  }

  List<Map<String, dynamic>> _buildMessages({
    required String message,
    required UserProfile userProfile,
    required List<AiMessage> conversationHistory,
    required List<WellnessGoal> activeGoals,
  }) {
    final systemPrompt = _buildSystemPrompt(userProfile, activeGoals);
    
    final messages = [
      {
        'role': 'system',
        'content': systemPrompt,
      },
    ];

    // Add conversation history
    for (final msg in conversationHistory.take(10)) {
      messages.add({
        'role': msg.isFromUser ? 'user' : 'assistant',
        'content': msg.content,
      });
    }

    // Add current message
    messages.add({
      'role': 'user',
      'content': message,
    });

    return messages;
  }

  String _buildSystemPrompt(UserProfile userProfile, List<WellnessGoal> activeGoals) {
    return '''
You are O'Qi, an AI wellness guide powered by ancient healing principles and modern regenerative practices. Your mission is to help users transform their lives through breath, food, movement, and mindful impact on Earth.

User Context:
- Name: ${userProfile.name ?? 'Tribe Member'}
- Priorities: ${userProfile.priorities.join(', ')}
- Help Areas: ${userProfile.helpAreas.join(', ')}
- Karma Points: ${userProfile.karmaPoints}
- Carbon Credits: ${userProfile.carbonCredits}
- Bio: ${userProfile.bio ?? 'Not provided'}

Active Goals: ${activeGoals.map((g) => '${g.title} (${g.progress}% complete)').join(', ')}

Core Principles:
1. **Regenerative Wellness**: Focus on healing the body through natural means
2. **Plant Paradox Nutrition**: Guide users toward lectin-free, anti-inflammatory eating
3. **Environmental Stewardship**: Every action should consider planetary impact
4. **Data Sovereignty**: Respect user privacy and data ownership
5. **Karma Points System**: Reward conscious behaviors with karma points
6. **Carbon Impact**: Help users understand their environmental footprint

Response Guidelines:
- Be warm, wise, and encouraging like an elder healer
- Always consider the user's specific priorities and health goals
- Suggest specific, actionable steps
- Include karma points (5-50) for valuable actions
- Mention carbon impact when relevant
- Reference O'Qi products and practices when appropriate
- Keep responses concise but comprehensive
- Use inclusive, empowering language

Remember: You're not just an AI assistant—you're a guide for sustainable, vibrant living. Every interaction should move the user toward their wellness goals while benefiting the planet.
''';
  }

  int? _extractKarmaPoints(String response) {
    // Simple extraction - in production, use more sophisticated parsing
    if (response.toLowerCase().contains('karma points')) {
      final regex = RegExp(r'(\d+)\s*karma points?', caseSensitive: false);
      final match = regex.firstMatch(response);
      if (match != null) {
        return int.tryParse(match.group(1) ?? '0');
      }
    }
    return null;
  }

  String? _extractCarbonImpact(String response) {
    if (response.toLowerCase().contains('carbon') || response.toLowerCase().contains('co2')) {
      // Extract carbon impact information
      return 'Positive impact on carbon footprint';
    }
    return null;
  }

  List<String>? _extractSuggestedActions(String response) {
    // Extract suggested actions from AI response
    final actions = <String>[];
    final lines = response.split('\n');
    
    for (final line in lines) {
      if (line.trim().startsWith('-') || line.trim().startsWith('•')) {
        actions.add(line.trim().substring(1).trim());
      }
    }
    
    return actions.isNotEmpty ? actions : null;
  }

  String _getFallbackResponse(String userMessage) {
    final responses = [
      "I understand you're seeking guidance on your wellness journey. Let me help you with that.",
      "Thank you for reaching out. I'm here to support your path to sustainable wellness.",
      "I hear you, and I'm ready to guide you toward your wellness goals.",
      "Your journey toward regenerative living is important. Let's work together on this.",
    ];
    
    return responses[DateTime.now().millisecond % responses.length];
  }

  Future<List<WellnessGoal>> generatePersonalizedGoals(UserProfile userProfile) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {
              'role': 'system',
              'content': '''
Generate 3 personalized wellness goals for this O'Qi Tribe member. Return as JSON array with objects containing:
- id: unique identifier
- title: short goal title
- description: detailed description
- category: health/nutrition/movement/sustainability/mindfulness
- difficulty: beginner/intermediate/advanced
- karmaPointsReward: 10-100 points
- carbonCreditsReward: 1-20 credits
- tags: relevant tags
''',
            },
            {
              'role': 'user',
              'content': '''
User Profile:
- Priorities: ${userProfile.priorities.join(', ')}
- Help Areas: ${userProfile.helpAreas.join(', ')}
- Bio: ${userProfile.bio ?? 'Not provided'}
- Current Karma: ${userProfile.karmaPoints}
- Current Carbon Credits: ${userProfile.carbonCredits}

Generate 3 personalized wellness goals that align with their priorities and current level.
''',
            },
          ],
          'max_tokens': 1500,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final aiResponse = data['choices'][0]['message']['content'];
        
        // Parse JSON response and convert to WellnessGoal objects
        final goalsJson = jsonDecode(aiResponse) as List;
        return goalsJson.map((goalJson) {
          return WellnessGoal(
            id: goalJson['id'],
            title: goalJson['title'],
            description: goalJson['description'],
            category: goalJson['category'],
            createdAt: DateTime.now(),
            userId: userProfile.id,
            karmaPointsReward: goalJson['karmaPointsReward'],
            carbonCreditsReward: goalJson['carbonCreditsReward'],
            tags: List<String>.from(goalJson['tags']),
            difficulty: goalJson['difficulty'],
          );
        }).toList();
      } else {
        return _getDefaultGoals(userProfile);
      }
    } catch (e) {
      return _getDefaultGoals(userProfile);
    }
  }

  List<WellnessGoal> _getDefaultGoals(UserProfile userProfile) {
    return [
      WellnessGoal(
        id: 'goal_1',
        title: 'Start Your Plant Paradox Journey',
        description: 'Begin transitioning to lectin-free, anti-inflammatory nutrition with O\'Qi guidance.',
        category: 'nutrition',
        createdAt: DateTime.now(),
        userId: userProfile.id,
        karmaPointsReward: 25,
        carbonCreditsReward: 5,
        tags: ['plant-paradox', 'nutrition', 'beginner'],
        difficulty: 'beginner',
      ),
      WellnessGoal(
        id: 'goal_2',
        title: 'Daily Breathwork Practice',
        description: 'Establish a daily breathwork routine for stress reduction and mental clarity.',
        category: 'mindfulness',
        createdAt: DateTime.now(),
        userId: userProfile.id,
        karmaPointsReward: 15,
        carbonCreditsReward: 2,
        tags: ['breathwork', 'mindfulness', 'stress-relief'],
        difficulty: 'beginner',
      ),
      WellnessGoal(
        id: 'goal_3',
        title: 'Track Your Carbon Footprint',
        description: 'Monitor and reduce your environmental impact through conscious daily choices.',
        category: 'sustainability',
        createdAt: DateTime.now(),
        userId: userProfile.id,
        karmaPointsReward: 30,
        carbonCreditsReward: 10,
        tags: ['sustainability', 'carbon-footprint', 'environment'],
        difficulty: 'beginner',
      ),
    ];
  }
}