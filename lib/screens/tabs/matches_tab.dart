import 'package:flutter/material.dart';
import '../../models/match.dart';
import '../../models/skill.dart';
import '../chat_screen.dart';
import '../../services/match_service.dart';

class MatchesTab extends StatefulWidget {
  const MatchesTab({super.key});

  @override
  State<MatchesTab> createState() => _MatchesTabState();
}

class _MatchesTabState extends State<MatchesTab> {
  final MatchService _matchService = MatchService();
  bool _isLoading = false;

  // Mock data - will be replaced with real data later
  List<SkillMatch> get _mockMatches => [
    SkillMatch(
      id: '1',
      userId: 'user1',
      userName: 'Sarah Johnson',
      userAvatar: 'https://i.pravatar.cc/150?img=1',
      offeredSkill: Skill(
        id: '1',
        name: 'Spanish Language',
        description: 'Conversational Spanish',
        category: 'Languages',
        requirements: ['Basic grammar understanding'],
        level: SkillLevel.intermediate,
      ),
      requestedSkill: Skill(
        id: '2',
        name: 'Photography',
        description: 'Digital photography basics',
        category: 'Arts',
        requirements: ['Own camera'],
        level: SkillLevel.beginner,
      ),
      status: MatchStatus.active,
      matchDate: DateTime.now().subtract(const Duration(days: 2)),
    ),
    SkillMatch(
      id: '2',
      userId: 'user2',
      userName: 'Mike Chen',
      userAvatar: 'https://i.pravatar.cc/150?img=2',
      offeredSkill: Skill(
        id: '3',
        name: 'Guitar',
        description: 'Guitar basics',
        category: 'Music',
        requirements: ['Own guitar'],
        level: SkillLevel.beginner,
      ),
      requestedSkill: Skill(
        id: '4',
        name: 'Web Development',
        description: 'HTML and CSS',
        category: 'Technology',
        requirements: ['Computer basics'],
        level: SkillLevel.intermediate,
      ),
      status: MatchStatus.pending,
      matchDate: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];

  Future<void> _handleAccept(SkillMatch match) async {
    setState(() => _isLoading = true);
    
    try {
      await _matchService.acceptMatch(match.id);
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Match accepted! You can now start chatting.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to accept match: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleDecline(SkillMatch match) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Decline Match'),
        content: const Text(
          'Are you sure you want to decline this match? This action cannot be undone.'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Decline'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);
    
    try {
      await _matchService.declineMatch(match.id);
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Match declined'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to decline match: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Your Matches'),
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Active'),
                  Tab(text: 'History'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _buildMatchList(_mockMatches.where((m) => 
                  m.status == MatchStatus.pending || 
                  m.status == MatchStatus.active || 
                  m.status == MatchStatus.accepted
                ).toList()),
                _buildMatchList(_mockMatches.where((m) => 
                  m.status == MatchStatus.completed
                ).toList()),
              ],
            ),
          ),
        ),
        if (_isLoading)
          const Positioned.fill(
            child: ColoredBox(
              color: Colors.black26,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMatchList(List<SkillMatch> matches) {
    if (matches.isEmpty) {
      return const Center(
        child: Text('No matches found'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: matches.length,
      itemBuilder: (context, index) {
        final match = matches[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(match.userAvatar),
                  child: const Icon(Icons.person),
                ),
                title: Text(match.userName),
                subtitle: Text('Matched ${_formatDate(match.matchDate)}'),
                trailing: Chip(
                  label: Text(
                    match.status.displayName,
                    style: TextStyle(
                      color: match.status.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: match.status.color.withOpacity(0.1),
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'They Teach',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            match.offeredSkill.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(match.offeredSkill.level.displayName),
                        ],
                      ),
                    ),
                    const Icon(Icons.swap_horiz),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'You Learn',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            match.requestedSkill.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(match.requestedSkill.level.displayName),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (match.status == MatchStatus.pending)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isLoading 
                            ? null 
                            : () => _handleDecline(match),
                          child: const Text('Decline'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading 
                            ? null 
                            : () => _handleAccept(match),
                          child: const Text('Accept'),
                        ),
                      ),
                    ],
                  ),
                ),
              if (match.status == MatchStatus.active)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(match: match),
                              ),
                            );
                          },
                          icon: const Icon(Icons.chat),
                          label: const Text('Open Chat'),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final difference = DateTime.now().difference(date);
    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'just now';
    }
  }
} 