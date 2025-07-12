import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/ai_message.dart';
import 'suggested_actions.dart';

class MessageBubble extends StatelessWidget {
  final AiMessage message;
  final Function(String)? onSuggestedActionTap;

  const MessageBubble({
    Key? key,
    required this.message,
    this.onSuggestedActionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isFromUser) ...[
            _buildAvatar(),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: message.isFromUser 
                  ? CrossAxisAlignment.end 
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: message.isFromUser 
                        ? Theme.of(context).primaryColor
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(16).copyWith(
                      bottomLeft: message.isFromUser ? const Radius.circular(16) : const Radius.circular(4),
                      bottomRight: message.isFromUser ? const Radius.circular(4) : const Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.content,
                        style: TextStyle(
                          color: message.isFromUser ? Colors.white : Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                      if (message.karmaPoints != null && message.karmaPoints! > 0) ...[
                        const SizedBox(height: 8),
                        _buildKarmaPointsBadge(message.karmaPoints!),
                      ],
                      if (message.carbonImpact != null) ...[
                        const SizedBox(height: 8),
                        _buildCarbonImpactBadge(message.carbonImpact!),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTime(message.timestamp),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                if (message.suggestedActions != null && message.suggestedActions!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  SuggestedActions(
                    actions: message.suggestedActions!,
                    onActionTap: onSuggestedActionTap,
                  ),
                ],
              ],
            ),
          ),
          if (message.isFromUser) ...[
            const SizedBox(width: 8),
            _buildAvatar(),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: message.isFromUser 
            ? Colors.grey[300]
            : Colors.green[400],
        shape: BoxShape.circle,
      ),
      child: Icon(
        message.isFromUser ? Icons.person : Icons.eco,
        color: message.isFromUser ? Colors.grey[600] : Colors.white,
        size: 18,
      ),
    );
  }

  Widget _buildKarmaPointsBadge(int points) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.favorite,
            size: 14,
            color: Colors.orange[700],
          ),
          const SizedBox(width: 4),
          Text(
            '+$points Karma Points',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.orange[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarbonImpactBadge(String impact) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.eco,
            size: 14,
            color: Colors.green[700],
          ),
          const SizedBox(width: 4),
          Text(
            impact,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.green[700],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}