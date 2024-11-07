import '../models/match.dart';

class MatchService {
  // Singleton pattern
  static final MatchService _instance = MatchService._internal();
  factory MatchService() => _instance;
  MatchService._internal();

  // Mock data storage - will be replaced with backend calls
  final List<SkillMatch> _matches = [];

  Future<void> acceptMatch(String matchId) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    final index = _matches.indexWhere((match) => match.id == matchId);
    if (index != -1) {
      final match = _matches[index];
      _matches[index] = SkillMatch(
        id: match.id,
        userId: match.userId,
        userName: match.userName,
        userAvatar: match.userAvatar,
        offeredSkill: match.offeredSkill,
        requestedSkill: match.requestedSkill,
        status: MatchStatus.active,
        matchDate: match.matchDate,
      );
    }
  }

  Future<void> declineMatch(String matchId) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    _matches.removeWhere((match) => match.id == matchId);
  }
} 