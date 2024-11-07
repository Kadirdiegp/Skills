import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/session.dart';

class SessionDetailsScreen extends StatelessWidget {
  final SkillSession session;

  const SessionDetailsScreen({
    super.key,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Details'),
        actions: [
          if (session.status == SessionStatus.scheduled)
            PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Text('Edit Session'),
                ),
                const PopupMenuItem(
                  value: 'cancel',
                  child: Text('Cancel Session'),
                ),
              ],
              onSelected: (value) {
                // TODO: Implement actions
              },
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildStatusCard(context),
          const SizedBox(height: 16),
          _buildDetailsCard(context),
          const SizedBox(height: 16),
          _buildLocationCard(context),
          const SizedBox(height: 16),
          _buildNotesCard(context),
          const SizedBox(height: 24),
          if (session.status == SessionStatus.scheduled)
            ElevatedButton(
              onPressed: () {
                // TODO: Implement start session
              },
              child: const Text('Start Session'),
            ),
          if (session.status == SessionStatus.inProgress)
            ElevatedButton(
              onPressed: () {
                // TODO: Implement end session
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('Complete Session'),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          _getStatusIcon(),
          color: _getStatusColor(context),
          size: 32,
        ),
        title: Text(
          session.status.displayName,
          style: TextStyle(
            color: _getStatusColor(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          _getStatusDescription(),
        ),
      ),
    );
  }

  Widget _buildDetailsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Session Details',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              context,
              'Topic',
              session.topic,
              Icons.subject,
            ),
            const Divider(),
            _buildDetailRow(
              context,
              'Date',
              DateFormat('EEEE, MMMM d, y').format(session.scheduledTime),
              Icons.calendar_today,
            ),
            const Divider(),
            _buildDetailRow(
              context,
              'Time',
              DateFormat('HH:mm').format(session.scheduledTime),
              Icons.access_time,
            ),
            const Divider(),
            _buildDetailRow(
              context,
              'Duration',
              '${session.duration.inMinutes} minutes',
              Icons.timelapse,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              session.isOnline ? 'Online Meeting' : 'Meeting Location',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (session.isOnline && session.meetingLink != null)
              ListTile(
                leading: const Icon(Icons.video_call),
                title: const Text('Video Call Link'),
                subtitle: Text(session.meetingLink!),
                trailing: IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    // TODO: Implement copy to clipboard
                  },
                ),
              )
            else if (!session.isOnline && session.location != null)
              ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text('Meeting Location'),
                subtitle: Text(session.location!),
                trailing: IconButton(
                  icon: const Icon(Icons.map),
                  onPressed: () {
                    // TODO: Implement open in maps
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notes',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text(session.notes),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon() {
    switch (session.status) {
      case SessionStatus.scheduled:
        return Icons.event;
      case SessionStatus.inProgress:
        return Icons.play_circle;
      case SessionStatus.completed:
        return Icons.check_circle;
      case SessionStatus.cancelled:
        return Icons.cancel;
    }
  }

  Color _getStatusColor(BuildContext context) {
    switch (session.status) {
      case SessionStatus.scheduled:
        return Colors.blue;
      case SessionStatus.inProgress:
        return Colors.green;
      case SessionStatus.completed:
        return Colors.grey;
      case SessionStatus.cancelled:
        return Colors.red;
    }
  }

  String _getStatusDescription() {
    switch (session.status) {
      case SessionStatus.scheduled:
        return 'This session is scheduled and ready to start';
      case SessionStatus.inProgress:
        return 'This session is currently in progress';
      case SessionStatus.completed:
        return 'This session has been completed';
      case SessionStatus.cancelled:
        return 'This session was cancelled';
    }
  }
} 