import 'package:flutter/material.dart';
import 'skill.dart';

class SkillMatch {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final Skill offeredSkill;
  final Skill requestedSkill;
  final MatchStatus status;
  final DateTime matchDate;

  SkillMatch({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.offeredSkill,
    required this.requestedSkill,
    required this.status,
    required this.matchDate,
  });
}

enum MatchStatus {
  pending,
  accepted,
  active,
  completed;

  String get displayName {
    switch (this) {
      case MatchStatus.pending:
        return 'Pending';
      case MatchStatus.accepted:
        return 'Accepted';
      case MatchStatus.active:
        return 'In Progress';
      case MatchStatus.completed:
        return 'Completed';
    }
  }

  Color get color {
    switch (this) {
      case MatchStatus.pending:
        return Colors.orange;
      case MatchStatus.accepted:
        return Colors.blue;
      case MatchStatus.active:
        return Colors.green;
      case MatchStatus.completed:
        return Colors.grey;
    }
  }
} 