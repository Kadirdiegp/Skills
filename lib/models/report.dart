enum ReportReason {
  inappropriate,
  spam,
  harassment,
  other;

  String get displayName {
    switch (this) {
      case ReportReason.inappropriate:
        return 'Inappropriate Content';
      case ReportReason.spam:
        return 'Spam';
      case ReportReason.harassment:
        return 'Harassment';
      case ReportReason.other:
        return 'Other';
    }
  }
}

class UserReport {
  final String id;
  final String reportedUserId;
  final String reporterUserId;
  final ReportReason reason;
  final String description;
  final DateTime reportTime;
  final List<String>? evidenceUrls;
  final bool isResolved;

  UserReport({
    required this.id,
    required this.reportedUserId,
    required this.reporterUserId,
    required this.reason,
    required this.description,
    required this.reportTime,
    this.evidenceUrls,
    this.isResolved = false,
  });
} 