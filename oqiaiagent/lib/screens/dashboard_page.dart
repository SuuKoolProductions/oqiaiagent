import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("O’Qi Tribe Dashboard")),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Daily Goals'),
              subtitle: const Text('Health tip, breathwork, food choice, O’Qi act'),
              onTap: () {},
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.show_chart),
              title: const Text('Progress Tracker'),
              subtitle: const Text('Basic habit logging'),
              onTap: () {},
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.public),
              title: const Text('Eco Impact Meter'),
              subtitle: const Text('Track your eco actions'),
              onTap: () {},
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.menu_book),
              title: const Text('Knowledge Center'),
              subtitle: const Text('Plant Paradox, yoga videos, environmental policy'),
              onTap: () {},
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.shopping_bag),
              title: const Text('OG Product Shop'),
              subtitle: const Text('Supplements, gear, nutrition kits'),
              onTap: () {},
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.group_add),
              title: const Text('Invite Others to Join the Tribe'),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
} 