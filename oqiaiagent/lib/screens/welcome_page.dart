import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/user_profile.dart';
import './ai_pairing_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                // Logo and Title
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.eco,
                        size: 64,
                        color: Colors.green[700],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Welcome to O'Qi",
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Your Sustainable Life Starts Here",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                
                const SizedBox(height: 48),
                
                // Description
                Text(
                  "O'Qi isn't just a brand. It's a movement. When you join the Tribe, you're paired with your own AI Guide — built on the principles of ancient energy, regenerative nutrition, modern science, and environmental wisdom.",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 48),
                
                // Features
                _buildFeatureItem(
                  icon: Icons.psychology,
                  title: 'AI-Powered Guidance',
                  subtitle: 'Personal wellness coach powered by GPT-4o',
                ),
                const SizedBox(height: 16),
                _buildFeatureItem(
                  icon: Icons.favorite,
                  title: 'Karma Points System',
                  subtitle: 'Earn rewards for conscious living',
                ),
                const SizedBox(height: 16),
                _buildFeatureItem(
                  icon: Icons.eco,
                  title: 'Carbon Credits',
                  subtitle: 'Track your environmental impact',
                ),
                
                const SizedBox(height: 48),
                
                // Start Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const IntakePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('Begin Your Journey'),
                ),
                
                const SizedBox(height: 24),
                
                // Terms
                Text(
                  "By continuing, you agree to our Terms of Service and Privacy Policy",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
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
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.green[700],
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class IntakePage extends StatefulWidget {
  const IntakePage({Key? key}) : super(key: key);

  @override
  State<IntakePage> createState() => _IntakePageState();
}

class _IntakePageState extends State<IntakePage> {
  int? _priority;
  final List<String> priorities = [
    'Better health',
    'Healing a condition (e.g., psoriasis, inflammation, cancer support)',
    'Eating cleaner',
    'Getting fit',
    'Saving the planet',
    'Parenting/kids health',
    'All of the above',
  ];

  final List<bool> _helpOptions = List.generate(5, (_) => false);
  final List<String> helpOptions = [
    'Lectin-free or Plant Paradox nutrition?',
    'Supplement routines?',
    'Environmental action?',
    'Yoga, breathwork, or mental clarity?',
    'Becoming an O\'Qi ambassador or earning carbon credits?',
  ];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _onContinue() async {
    if (_priority == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your top priority')),
      );
      return;
    }

    final provider = Provider.of<AppProvider>(context, listen: false);
    
    // Create user profile
    final userProfile = UserProfile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.isNotEmpty ? _nameController.text : null,
      email: _emailController.text.isNotEmpty ? _emailController.text : null,
      age: _ageController.text.isNotEmpty ? int.tryParse(_ageController.text) : null,
      location: _locationController.text.isNotEmpty ? _locationController.text : null,
      priorities: [_priority!],
      helpAreas: _helpOptions.asMap().entries
          .where((entry) => entry.value)
          .map((entry) => helpOptions[entry.key])
          .toList(),
      bio: _bioController.text.isNotEmpty ? _bioController.text : null,
      joinDate: DateTime.now(),
    );

    await provider.saveUserProfile(userProfile);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AiPairingPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Let\'s Get to Know You'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Information',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name (optional)',
                hintText: 'Enter your name',
              ),
            ),
            const SizedBox(height: 16),
            
            // Email
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email (optional)',
                hintText: 'Enter your email',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            
            // Age
            TextFormField(
              controller: _ageController,
              decoration: const InputDecoration(
                labelText: 'Age (optional)',
                hintText: 'Enter your age',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            
            // Location
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location (optional)',
                hintText: 'City, State, or Country',
              ),
            ),
            const SizedBox(height: 24),
            
            Text(
              '1. What\'s your top priority right now?',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...priorities.asMap().entries.map((entry) => RadioListTile<int>(
              title: Text(entry.value),
              value: entry.key,
              groupValue: _priority,
              onChanged: (val) => setState(() => _priority = val),
              contentPadding: EdgeInsets.zero,
            )),
            
            const SizedBox(height: 24),
            
            Text(
              '2. Do you want help with…',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...helpOptions.asMap().entries.map((entry) => CheckboxListTile(
              title: Text(entry.value),
              value: _helpOptions[entry.key],
              onChanged: (val) => setState(() => _helpOptions[entry.key] = val ?? false),
              contentPadding: EdgeInsets.zero,
            )),
            
            const SizedBox(height: 24),
            
            Text(
              '3. Tell us about yourself (optional):',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _bioController,
              decoration: const InputDecoration(
                hintText: 'e.g. I\'m 52, live in Arizona, trying to feel better, and I love the outdoors.',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            
            const SizedBox(height: 32),
            
            Center(
              child: ElevatedButton(
                onPressed: _onContinue,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                child: const Text('Continue to AI Pairing'),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 