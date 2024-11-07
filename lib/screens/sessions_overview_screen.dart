import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/session.dart';
import 'session_details_screen.dart';

class SessionsOverviewScreen extends StatelessWidget {
  final List<SkillSession> sessions = [
    // Mock data
    SkillSession(
      id: '1',
      matchId: 'match1',
      scheduledTime: DateTime.now().add(const Duration(days: 1)),
      duration: const Duration(hours: 1),
      topic: 'Spanish Basics',
      notes: 'Focus on greetings and basic conversation',
      status: SessionStatus.scheduled,
      isOnline: true,
      meetingLink: 'https://meet.example.com/abc123',
    ),
    // Add more mock sessions...
  ];

  SessionsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Your Sessions'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Past'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildSessionsList(
              context,
              sessions.where((s) => 
                s.status == SessionStatus.scheduled || 
                s.status == SessionStatus.inProgress
              ).toList(),
            ),
            _buildSessionsList(
              context,
              sessions.where((s) => s.status == SessionStatus.completed).toList(),
            ),
            _buildSessionsList(
              context,
              sessions.where((s) => s.status == SessionStatus.cancelled).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionsList(BuildContext context, List<SkillSession> sessions) {
    if (sessions.isEmpty) {
      return const Center(
        child: Text('No sessions found'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        return Card(
          child: ListTile(
            leading: Icon(
              session.isOnline ? Icons.video_call : Icons.location_on,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(session.topic),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('MMM d, y - HH:mm').format(session.scheduledTime),
                ),
                Text(
                  'Duration: ${session.duration.inMinutes} minutes',
                ),
              ],
            ),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'details',
                  child: Text('View Details'),
                ),
                if (session.status == SessionStatus.scheduled)
                  const PopupMenuItem(
                    value: 'cancel',
                    child: Text('Cancel Session'),
                  ),
              ],
              onSelected: (value) {
                if (value == 'details') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SessionDetailsScreen(session: session),
                    ),
                  );
                } else if (value == 'cancel') {
                  // TODO: Implement cancel session
                }
              },
            ),
          ),
        );
      },
    );
  }
} 