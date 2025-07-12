import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/app_provider.dart';
import '../models/ai_message.dart';
import '../widgets/message_bubble.dart';
import '../widgets/suggested_actions.dart';

class AiChatPage extends StatefulWidget {
  const AiChatPage({Key? key}) : super(key: key);

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    final provider = Provider.of<AppProvider>(context, listen: false);
    
    _messageController.clear();
    _scrollToBottom();

    await provider.sendMessageToAI(message);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('O\'Qi AI Guide'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showAiInfo();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Karma Points and Carbon Credits Display
          Consumer<AppProvider>(
            builder: (context, provider, child) {
              final userProfile = provider.userProfile;
              if (userProfile == null) return const SizedBox.shrink();
              
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  border: Border(
                    bottom: BorderSide(color: Colors.green[200]!),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildMetricCard(
                      icon: Icons.favorite,
                      label: 'Karma Points',
                      value: '${userProfile.karmaPoints}',
                      color: Colors.orange,
                    ),
                    _buildMetricCard(
                      icon: Icons.eco,
                      label: 'Carbon Credits',
                      value: '${userProfile.carbonCredits}',
                      color: Colors.green,
                    ),
                  ],
                ),
              );
            },
          ),
          
          // Messages List
          Expanded(
            child: Consumer<AppProvider>(
              builder: (context, provider, child) {
                final messages = provider.conversationHistory;
                
                if (messages.isEmpty) {
                  return _buildWelcomeMessage();
                }
                
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length + (provider.isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == messages.length && provider.isLoading) {
                      return _buildTypingIndicator();
                    }
                    
                    final message = messages[index];
                    return MessageBubble(
                      message: message,
                      onSuggestedActionTap: (action) {
                        _messageController.text = action;
                        _sendMessage();
                      },
                    ).animate().fadeIn(duration: 300.ms).slideY(
                      begin: 0.3,
                      duration: 300.ms,
                      curve: Curves.easeOut,
                    );
                  },
                );
              },
            ),
          ),
          
          // Error Display
          Consumer<AppProvider>(
            builder: (context, provider, child) {
              if (provider.error != null) {
                return Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red[600]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          provider.error!,
                          style: TextStyle(color: Colors.red[700]),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: provider.clearError,
                        color: Colors.red[600],
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          
          // Input Area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Ask your O\'Qi guide anything...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 12),
                Consumer<AppProvider>(
                  builder: (context, provider, child) {
                    return FloatingActionButton(
                      onPressed: provider.isLoading ? null : _sendMessage,
                      backgroundColor: provider.isLoading 
                          ? Colors.grey 
                          : Theme.of(context).primaryColor,
                      child: provider.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Icons.send),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.eco,
              size: 64,
              color: Colors.green[400],
            ),
            const SizedBox(height: 24),
            Text(
              'Welcome to O\'Qi',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'I\'m your AI wellness guide, here to help you transform your life through breath, food, movement, and mindful impact on Earth.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            SuggestedActions(
              actions: [
                'Help me with nutrition',
                'I want to reduce my carbon footprint',
                'Show me some breathwork exercises',
                'What are my daily wellness goals?',
              ],
              onActionTap: (action) {
                _messageController.text = action;
                _sendMessage();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0),
                _buildDot(1),
                _buildDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedBuilder(
      animation: _typingAnimation,
      builder: (context, child) {
        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: Colors.grey[600],
            shape: BoxShape.circle,
          ),
          child: _typingAnimation.value > index * 0.3
              ? Container()
              : null,
        );
      },
    );
  }

  AnimationController get _typingAnimation {
    return AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: color,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: color.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAiInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About O\'Qi AI Guide'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your O\'Qi AI guide is powered by ancient healing principles and modern regenerative practices.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'I can help you with:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('• Plant Paradox nutrition guidance'),
            Text('• Breathwork and mindfulness practices'),
            Text('• Environmental impact tracking'),
            Text('• Wellness goal setting and tracking'),
            Text('• Karma points and carbon credits'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}