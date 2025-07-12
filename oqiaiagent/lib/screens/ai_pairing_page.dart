import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/app_provider.dart';
import '../models/user_profile.dart';
import './dashboard_page.dart';

class AiPairingPage extends StatefulWidget {
  const AiPairingPage({Key? key}) : super(key: key);

  @override
  State<AiPairingPage> createState() => _AiPairingPageState();
}

class _AiPairingPageState extends State<AiPairingPage> {
  bool _isPairing = false;
  bool _isPaired = false;

  @override
  void initState() {
    super.initState();
    _startPairing();
  }

  void _startPairing() async {
    setState(() {
      _isPairing = true;
    });

    // Simulate AI pairing process
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      setState(() {
        _isPairing = false;
        _isPaired = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meet Your O\'Qi Guide'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green[50]!,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // AI Avatar
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.psychology,
                    size: 80,
                    color: Colors.green[700],
                  ),
                ).animate().scale(duration: 600.ms).then().shimmer(duration: 1000.ms),
                
                const SizedBox(height: 32),
                
                // Title
                Text(
                  'O\'Qi AI Companion',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  'Powered by Craig\'s Wisdom',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 32),
                
                // Status
                if (_isPairing) ...[
                  _buildPairingStatus(),
                ] else if (_isPaired) ...[
                  _buildPairedStatus(),
                ] else ...[
                  _buildInitialStatus(),
                ],
                
                const SizedBox(height: 48),
                
                // Continue Button
                if (_isPaired)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const DashboardPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Go to Dashboard'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInitialStatus() {
    return Column(
      children: [
        Text(
          'Your daily guide to living consciously — with the mind of an elder and the spirit of a healer.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.grey[700],
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Text(
          'Preparing your personalized AI guide...',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPairingStatus() {
    return Column(
      children: [
        const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
        ),
        const SizedBox(height: 24),
        Text(
          'Pairing with your AI guide...',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.green[700],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Analyzing your preferences and creating a personalized wellness plan',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildPairedStatus() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.green[200]!),
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green[600], size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Successfully paired!',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.green[700],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Welcome! You\'ve taken the first step toward a more sustainable and energized life. I\'m your O\'Qi guide — here to help you build better habits, nourish your body, and heal the planet, one breath at a time.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.grey[700],
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        _buildFeatureList(),
      ],
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, duration: 600.ms);
  }

  Widget _buildFeatureList() {
    return Column(
      children: [
        _buildFeatureItem(
          icon: Icons.favorite,
          title: 'Personalized Guidance',
          subtitle: 'Tailored to your health goals and preferences',
        ),
        const SizedBox(height: 12),
        _buildFeatureItem(
          icon: Icons.eco,
          title: 'Environmental Impact',
          subtitle: 'Track and improve your carbon footprint',
        ),
        const SizedBox(height: 12),
        _buildFeatureItem(
          icon: Icons.psychology,
          title: 'Mindful Living',
          subtitle: 'Breathwork, meditation, and stress management',
        ),
      ],
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.green[700],
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 