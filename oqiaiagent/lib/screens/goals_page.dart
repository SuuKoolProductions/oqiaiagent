import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/app_provider.dart';
import '../models/wellness_goal.dart';

class GoalsPage extends StatefulWidget {
  const GoalsPage({Key? key}) : super(key: key);

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wellness Goals'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Health'),
            Tab(text: 'Nutrition'),
            Tab(text: 'Movement'),
            Tab(text: 'Sustainability'),
            Tab(text: 'Mindfulness'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateGoalDialog(),
          ),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          final goals = _getFilteredGoals(provider.activeGoals);
          
          return TabBarView(
            controller: _tabController,
            children: List.generate(6, (index) {
              final category = _getCategoryFromIndex(index);
              final categoryGoals = _getFilteredGoals(provider.activeGoals, category);
              
              return _buildGoalsList(categoryGoals, provider);
            }),
          );
        },
      ),
    );
  }

  Widget _buildGoalsList(List<WellnessGoal> goals, AppProvider provider) {
    if (goals.isEmpty) {
      return _buildEmptyState(provider);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: goals.length,
      itemBuilder: (context, index) {
        final goal = goals[index];
        return _buildGoalCard(goal, provider)
            .animate()
            .fadeIn(duration: 300.ms, delay: Duration(milliseconds: index * 100))
            .slideX(begin: 0.3, duration: 300.ms, delay: Duration(milliseconds: index * 100));
      },
    );
  }

  Widget _buildGoalCard(WellnessGoal goal, AppProvider provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(goal.category).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getCategoryIcon(goal.category),
                    color: _getCategoryColor(goal.category),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        goal.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) => _handleGoalAction(value, goal, provider),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'complete',
                      child: Row(
                        children: [
                          Icon(Icons.check_circle),
                          SizedBox(width: 8),
                          Text('Mark Complete'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete),
                          SizedBox(width: 8),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Progress',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${goal.progress}%',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: _getCategoryColor(goal.category),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: goal.progress / 100,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getCategoryColor(goal.category),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.favorite, size: 16, color: Colors.orange[600]),
                        const SizedBox(width: 4),
                        Text(
                          '+${goal.karmaPointsReward}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.orange[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.eco, size: 16, color: Colors.green[600]),
                        const SizedBox(width: 4),
                        Text(
                          '+${goal.carbonCreditsReward}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.green[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getDifficultyColor(goal.difficulty).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    goal.difficulty.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: _getDifficultyColor(goal.difficulty),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    goal.category.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  'Created ${_formatDate(goal.createdAt)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
            if (goal.milestones.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Milestones',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              ...goal.milestones.map((milestone) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline, size: 16, color: Colors.grey[400]),
                    const SizedBox(width: 8),
                    Text(
                      milestone,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              )),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _updateProgress(goal, provider),
                    child: const Text('Update Progress'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: goal.progress >= 100 
                        ? () => _completeGoal(goal, provider)
                        : null,
                    child: const Text('Complete'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.flag_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              'No goals yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Start your wellness journey by creating your first goal or let AI generate personalized goals for you.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _showCreateGoalDialog(),
                  icon: const Icon(Icons.add),
                  label: const Text('Create Goal'),
                ),
                ElevatedButton.icon(
                  onPressed: () => provider.generatePersonalizedGoals(),
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text('AI Generate'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateGoalDialog() {
    showDialog(
      context: context,
      builder: (context) => const CreateGoalDialog(),
    );
  }

  void _handleGoalAction(String action, WellnessGoal goal, AppProvider provider) {
    switch (action) {
      case 'edit':
        _editGoal(goal);
        break;
      case 'complete':
        _completeGoal(goal, provider);
        break;
      case 'delete':
        _deleteGoal(goal, provider);
        break;
    }
  }

  void _updateProgress(WellnessGoal goal, AppProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Progress'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Current progress: ${goal.progress}%'),
            const SizedBox(height: 16),
            Slider(
              value: goal.progress.toDouble(),
              min: 0,
              max: 100,
              divisions: 20,
              label: '${goal.progress}%',
              onChanged: (value) {
                setState(() {
                  // Update progress
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Save progress
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _completeGoal(WellnessGoal goal, AppProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Complete Goal'),
        content: Text('Are you sure you want to mark "${goal.title}" as complete?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.completeGoal(goal.id);
              Navigator.pop(context);
            },
            child: const Text('Complete'),
          ),
        ],
      ),
    );
  }

  void _editGoal(WellnessGoal goal) {
    // Show edit dialog
  }

  void _deleteGoal(WellnessGoal goal, AppProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Goal'),
        content: Text('Are you sure you want to delete "${goal.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Delete goal
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  List<WellnessGoal> _getFilteredGoals(List<WellnessGoal> goals, [String? category]) {
    if (category == null || category == 'all') {
      return goals;
    }
    return goals.where((goal) => goal.category.toLowerCase() == category.toLowerCase()).toList();
  }

  String _getCategoryFromIndex(int index) {
    switch (index) {
      case 0:
        return 'all';
      case 1:
        return 'health';
      case 2:
        return 'nutrition';
      case 3:
        return 'movement';
      case 4:
        return 'sustainability';
      case 5:
        return 'mindfulness';
      default:
        return 'all';
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'health':
        return Icons.favorite;
      case 'nutrition':
        return Icons.restaurant;
      case 'movement':
        return Icons.directions_run;
      case 'sustainability':
        return Icons.eco;
      case 'mindfulness':
        return Icons.self_improvement;
      default:
        return Icons.flag;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'health':
        return Colors.red;
      case 'nutrition':
        return Colors.orange;
      case 'movement':
        return Colors.blue;
      case 'sustainability':
        return Colors.green;
      case 'mindfulness':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class CreateGoalDialog extends StatefulWidget {
  const CreateGoalDialog({Key? key}) : super(key: key);

  @override
  State<CreateGoalDialog> createState() => _CreateGoalDialogState();
}

class _CreateGoalDialogState extends State<CreateGoalDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'health';
  String _selectedDifficulty = 'beginner';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Goal'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Goal Title',
                hintText: 'e.g., Start Plant Paradox Diet',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Describe your goal...',
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
              ),
              items: const [
                DropdownMenuItem(value: 'health', child: Text('Health')),
                DropdownMenuItem(value: 'nutrition', child: Text('Nutrition')),
                DropdownMenuItem(value: 'movement', child: Text('Movement')),
                DropdownMenuItem(value: 'sustainability', child: Text('Sustainability')),
                DropdownMenuItem(value: 'mindfulness', child: Text('Mindfulness')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedDifficulty,
              decoration: const InputDecoration(
                labelText: 'Difficulty',
              ),
              items: const [
                DropdownMenuItem(value: 'beginner', child: Text('Beginner')),
                DropdownMenuItem(value: 'intermediate', child: Text('Intermediate')),
                DropdownMenuItem(value: 'advanced', child: Text('Advanced')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedDifficulty = value!;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _createGoal,
          child: const Text('Create'),
        ),
      ],
    );
  }

  void _createGoal() {
    if (_formKey.currentState!.validate()) {
      // Create goal logic
      Navigator.pop(context);
    }
  }
}