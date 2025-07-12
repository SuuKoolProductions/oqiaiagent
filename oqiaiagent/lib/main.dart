import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'providers/app_provider.dart';
import 'screens/welcome_page.dart';
import 'screens/ai_chat_page.dart';
import 'screens/dashboard_page.dart';
import 'screens/goals_page.dart';
import 'screens/profile_page.dart';
import 'models/user_profile.dart';
import 'models/ai_message.dart';
import 'models/wellness_goal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register adapters
  Hive.registerAdapter(UserProfileAdapter());
  Hive.registerAdapter(AiMessageAdapter());
  Hive.registerAdapter(WellnessGoalAdapter());
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppProvider()..initialize(),
      child: MaterialApp(
        title: 'O\'Qi AI Tribe',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4CAF50),
            brightness: Brightness.light,
          ),
          fontFamily: 'Inter',
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF4CAF50),
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          cardTheme: CardTheme(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
        ),
        home: const WelcomePage(),
        routes: {
          '/welcome': (context) => const WelcomePage(),
          '/dashboard': (context) => const DashboardPage(),
          '/chat': (context) => const AiChatPage(),
          '/goals': (context) => const GoalsPage(),
          '/profile': (context) => const ProfilePage(),
        },
      ),
    );
  }
}
