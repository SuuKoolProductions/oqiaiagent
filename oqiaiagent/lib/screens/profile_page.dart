import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/app_provider.dart';
import '../models/user_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettings(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Achievements'),
            Tab(text: 'Stats'),
          ],
        ),
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          final userProfile = provider.userProfile;
          if (userProfile == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildOverviewTab(userProfile, provider),
              _buildAchievementsTab(userProfile),
              _buildStatsTab(userProfile),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOverviewTab(UserProfile userProfile, AppProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildProfileHeader(userProfile),
          const SizedBox(height: 24),
          _buildMetricsCards(userProfile),
          const SizedBox(height: 24),
          _buildProfileInfo(userProfile),
          const SizedBox(height: 24),
          _buildQuickActions(provider),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(UserProfile userProfile) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.green[100],
              child: Icon(
                Icons.eco,
                size: 50,
                color: Colors.green[700],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              userProfile.name ?? 'Tribe Member',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Member since ${_formatDate(userProfile.joinDate ?? DateTime.now())}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem('Karma Points', '${userProfile.karmaPoints}', Icons.favorite, Colors.orange),
                _buildStatItem('Carbon Credits', '${userProfile.carbonCredits}', Icons.eco, Colors.green),
                _buildStatItem('Badges', '${userProfile.badges.length}', Icons.emoji_events, Colors.amber),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.3, duration: 400.ms);
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricsCards(UserProfile userProfile) {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            title: 'Wellness Score',
            value: '${_calculateWellnessScore(userProfile)}',
            subtitle: 'Based on your goals and activities',
            color: Colors.blue,
            icon: Icons.health_and_safety,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            title: 'Eco Impact',
            value: '${_calculateEcoImpact(userProfile)}',
            subtitle: 'Environmental contribution',
            color: Colors.green,
            icon: Icons.eco,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
    required IconData icon,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfo(UserProfile userProfile) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile Information',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Name', userProfile.name ?? 'Not set'),
            _buildInfoRow('Email', userProfile.email ?? 'Not set'),
            _buildInfoRow('Age', userProfile.age?.toString() ?? 'Not set'),
            _buildInfoRow('Location', userProfile.location ?? 'Not set'),
            if (userProfile.bio != null) ...[
              const SizedBox(height: 16),
              Text(
                'Bio',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                userProfile.bio!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                ),
              ),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _editProfile(userProfile),
              child: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(AppProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildActionCard(
                  icon: Icons.share,
                  title: 'Invite Friends',
                  onTap: () => _inviteFriends(),
                ),
                _buildActionCard(
                  icon: Icons.download,
                  title: 'Export Data',
                  onTap: () => _exportData(),
                ),
                _buildActionCard(
                  icon: Icons.help,
                  title: 'Get Help',
                  onTap: () => _getHelp(),
                ),
                _buildActionCard(
                  icon: Icons.feedback,
                  title: 'Send Feedback',
                  onTap: () => _sendFeedback(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: Colors.green[600]),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementsTab(UserProfile userProfile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildBadgesSection(userProfile),
          const SizedBox(height: 24),
          _buildCompletedChallenges(userProfile),
        ],
      ),
    );
  }

  Widget _buildBadgesSection(UserProfile userProfile) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Badges & Achievements',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (userProfile.badges.isEmpty)
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.emoji_events_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No badges yet',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Complete goals and activities to earn badges',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              )
            else
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: userProfile.badges.map((badge) => _buildBadge(badge)).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String badge) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.emoji_events, color: Colors.amber[700], size: 20),
          const SizedBox(width: 8),
          Text(
            badge,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.amber[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedChallenges(UserProfile userProfile) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Completed Challenges',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (userProfile.completedChallenges.isEmpty)
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.flag_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No completed challenges yet',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              )
            else
              ...userProfile.completedChallenges.map((challenge) => ListTile(
                leading: Icon(Icons.check_circle, color: Colors.green[600]),
                title: Text(challenge),
                subtitle: Text('Completed'),
              )),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsTab(UserProfile userProfile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildProgressChart(),
          const SizedBox(height: 24),
          _buildHealthMetrics(userProfile),
          const SizedBox(height: 24),
          _buildSustainabilityMetrics(userProfile),
        ],
      ),
    );
  }

  Widget _buildProgressChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Progress',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        const FlSpot(0, 3),
                        const FlSpot(2.6, 2),
                        const FlSpot(4.9, 5),
                        const FlSpot(6.8, 3.1),
                        const FlSpot(8, 4),
                        const FlSpot(9.5, 3),
                        const FlSpot(11, 4),
                      ],
                      isCurved: true,
                      color: Colors.green[600],
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.green[100]!,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthMetrics(UserProfile userProfile) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Health Metrics',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (userProfile.healthMetrics.isEmpty)
              Center(
                child: Text(
                  'No health metrics recorded yet',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
                ),
              )
            else
              ...userProfile.healthMetrics.entries.map((entry) => ListTile(
                title: Text(entry.key),
                subtitle: Text(entry.value.toString()),
                leading: Icon(Icons.favorite, color: Colors.red[400]),
              )),
          ],
        ),
      ),
    );
  }

  Widget _buildSustainabilityMetrics(UserProfile userProfile) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sustainability Metrics',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (userProfile.sustainabilityMetrics.isEmpty)
              Center(
                child: Text(
                  'No sustainability metrics recorded yet',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
                ),
              )
            else
              ...userProfile.sustainabilityMetrics.entries.map((entry) => ListTile(
                title: Text(entry.key),
                subtitle: Text(entry.value.toString()),
                leading: Icon(Icons.eco, color: Colors.green[400]),
              )),
          ],
        ),
      ),
    );
  }

  int _calculateWellnessScore(UserProfile userProfile) {
    // Simple calculation based on karma points and completed challenges
    return (userProfile.karmaPoints / 10).round() + (userProfile.completedChallenges.length * 5);
  }

  int _calculateEcoImpact(UserProfile userProfile) {
    // Simple calculation based on carbon credits
    return userProfile.carbonCredits * 2;
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.year}';
  }

  void _editProfile(UserProfile userProfile) {
    // Show edit profile dialog
  }

  void _showSettings() {
    // Show settings dialog
  }

  void _inviteFriends() {
    // Show invite friends dialog
  }

  void _exportData() {
    // Export user data
  }

  void _getHelp() {
    // Show help dialog
  }

  void _sendFeedback() {
    // Show feedback dialog
  }
}