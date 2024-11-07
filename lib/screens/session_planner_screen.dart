import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/match.dart';
import '../models/session.dart';

class SessionPlannerScreen extends StatefulWidget {
  final SkillMatch match;

  const SessionPlannerScreen({
    super.key,
    required this.match,
  });

  @override
  State<SessionPlannerScreen> createState() => _SessionPlannerScreenState();
}

class _SessionPlannerScreenState extends State<SessionPlannerScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 14, minute: 0);
  Duration _duration = const Duration(hours: 1);
  bool _isOnline = true;
  final _topicController = TextEditingController();
  final _notesController = TextEditingController();
  final _locationController = TextEditingController();
  final _meetingLinkController = TextEditingController();

  @override
  void dispose() {
    _topicController.dispose();
    _notesController.dispose();
    _locationController.dispose();
    _meetingLinkController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _scheduleSession() async {
    if (!_formKey.currentState!.validate()) return;

    // TODO: Implement session scheduling with backend
    final session = SkillSession(
      id: DateTime.now().toString(),
      matchId: widget.match.id,
      scheduledTime: DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      ),
      duration: _duration,
      topic: _topicController.text,
      notes: _notesController.text,
      status: SessionStatus.scheduled,
      isOnline: _isOnline,
      meetingLink: _isOnline ? _meetingLinkController.text : null,
      location: !_isOnline ? _locationController.text : null,
    );

    // Show confirmation
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Session Scheduled'),
        content: Text(
          'Your session has been scheduled for ${DateFormat('MMM d, y').format(_selectedDate)} at ${_selectedTime.format(context)}',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Return to chat
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Session'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Session with ${widget.match.userName}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.match.offeredSkill.name} (${widget.match.offeredSkill.level.displayName})',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _topicController,
              decoration: const InputDecoration(
                labelText: 'Topic',
                hintText: 'What will you focus on in this session?',
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter a topic';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('Date'),
                    subtitle: Text(
                      DateFormat('MMM d, y').format(_selectedDate),
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: _selectDate,
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text('Time'),
                    subtitle: Text(_selectedTime.format(context)),
                    trailing: const Icon(Icons.access_time),
                    onTap: _selectTime,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Duration>(
              value: _duration,
              decoration: const InputDecoration(
                labelText: 'Duration',
              ),
              items: [
                const Duration(minutes: 30),
                const Duration(hours: 1),
                const Duration(hours: 1, minutes: 30),
                const Duration(hours: 2),
              ].map((duration) {
                final hours = duration.inHours;
                final minutes = duration.inMinutes % 60;
                return DropdownMenuItem(
                  value: duration,
                  child: Text(
                    hours > 0
                        ? minutes > 0
                            ? '$hours hr $minutes min'
                            : '$hours hr'
                        : '$minutes min',
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _duration = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Online Session'),
              subtitle: Text(
                _isOnline ? 'Via video call' : 'In-person meeting',
              ),
              value: _isOnline,
              onChanged: (value) {
                setState(() {
                  _isOnline = value;
                });
              },
            ),
            const SizedBox(height: 16),
            if (_isOnline)
              TextFormField(
                controller: _meetingLinkController,
                decoration: const InputDecoration(
                  labelText: 'Meeting Link',
                  hintText: 'Enter video call link',
                ),
                validator: (value) {
                  if (_isOnline && (value?.isEmpty ?? true)) {
                    return 'Please enter a meeting link';
                  }
                  return null;
                },
              )
            else
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  hintText: 'Enter meeting location',
                ),
                validator: (value) {
                  if (!_isOnline && (value?.isEmpty ?? true)) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes',
                hintText: 'Any additional information',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _scheduleSession,
              child: const Text('Schedule Session'),
            ),
          ],
        ),
      ),
    );
  }
} 