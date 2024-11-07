enum SessionStatus {
  scheduled,
  inProgress,
  completed,
  cancelled;

  String get displayName {
    switch (this) {
      case SessionStatus.scheduled:
        return 'Scheduled';
      case SessionStatus.inProgress:
        return 'In Progress';
      case SessionStatus.completed:
        return 'Completed';
      case SessionStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class SkillSession {
  final String id;
  final String matchId;
  final DateTime scheduledTime;
  final Duration duration;
  final String topic;
  final String notes;
  final SessionStatus status;
  final bool isOnline;
  final String? meetingLink;
  final String? location;

  SkillSession({
    required this.id,
    required this.matchId,
    required this.scheduledTime,
    required this.duration,
    required this.topic,
    required this.notes,
    required this.status,
    required this.isOnline,
    this.meetingLink,
    this.location,
  });
} 