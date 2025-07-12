import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SuggestedActions extends StatelessWidget {
  final List<String> actions;
  final Function(String)? onActionTap;

  const SuggestedActions({
    Key? key,
    required this.actions,
    this.onActionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: actions.asMap().entries.map((entry) {
        final index = entry.key;
        final action = entry.value;
        
        return GestureDetector(
          onTap: () => onActionTap?.call(action),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Text(
              action,
              style: TextStyle(
                fontSize: 14,
                color: Colors.green[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ).animate().fadeIn(
          duration: Duration(milliseconds: 200 + (index * 100)),
          delay: Duration(milliseconds: index * 100),
        ).slideX(
          begin: 0.3,
          duration: Duration(milliseconds: 200 + (index * 100)),
          delay: Duration(milliseconds: index * 100),
          curve: Curves.easeOut,
        );
      }).toList(),
    );
  }
}