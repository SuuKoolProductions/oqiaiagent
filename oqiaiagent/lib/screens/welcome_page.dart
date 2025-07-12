import 'package:flutter/material.dart';
import './ai_pairing_page.dart';
import './screens/welcome_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Welcome to O’Qi — Your Sustainable Life Starts Here",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            const Text(
              "O’Qi isn’t just a brand. It’s a movement. When you join the Tribe, you’re paired with your own AI Guide — built on the principles of ancient energy, regenerative nutrition, modern science, and environmental wisdom.",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const IntakePage()),
                );
              },
              child: const Text('Begin Your Journey'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                textStyle: const TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Replace IntakePage placeholder with real intake survey
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
    'Becoming an O’Qi ambassador or earning carbon credits?',
  ];

  final TextEditingController _bioController = TextEditingController();

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  void _onContinue() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AiPairingPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Let’s Get to Know You')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('1. What’s your top priority right now?', style: TextStyle(fontWeight: FontWeight.bold)),
            ...priorities.asMap().entries.map((entry) => RadioListTile<int>(
                  title: Text(entry.value),
                  value: entry.key,
                  groupValue: _priority,
                  onChanged: (val) => setState(() => _priority = val),
                )),
            const SizedBox(height: 24),
            const Text('2. Do you want help with…', style: TextStyle(fontWeight: FontWeight.bold)),
            ...helpOptions.asMap().entries.map((entry) => CheckboxListTile(
                  title: Text(entry.value),
                  value: _helpOptions[entry.key],
                  onChanged: (val) => setState(() => _helpOptions[entry.key] = val ?? false),
                )),
            const SizedBox(height: 24),
            const Text('3. Describe yourself in a few words (optional):', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _bioController,
              decoration: const InputDecoration(hintText: 'e.g. I’m 52, live in Arizona, trying to feel better, and I love the outdoors.'),
              maxLines: 2,
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: _onContinue,
                child: const Text('Continue'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 