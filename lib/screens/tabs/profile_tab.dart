import 'package:flutter/material.dart';
import '../../models/skill.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  // Mock user data - will be replaced with real user data later
  final Map<String, dynamic> _userData = {
    'name': 'John Doe',
    'email': 'john.doe@example.com',
    'avatar': 'https://i.pravatar.cc/150?img=8',
    'bio': 'Passionate about learning and teaching new skills!',
    'teachingSkills': [
      Skill(
        id: '1',
        name: 'Spanish Language',
        description: 'Fluent Spanish speaker with teaching experience',
        category: 'Languages',
        requirements: ['Basic understanding of grammar'],
        level: SkillLevel.expert,
      ),
      Skill(
        id: '2',
        name: 'Photography',
        description: 'Professional photographer',
        category: 'Arts',
        requirements: ['Own camera'],
        level: SkillLevel.intermediate,
      ),
    ],
    'learningSkills': [
      Skill(
        id: '3',
        name: 'Guitar',
        description: 'Want to learn guitar basics',
        category: 'Music',
        requirements: ['Have a guitar'],
        level: SkillLevel.beginner,
      ),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to edit profile
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: Implement refresh
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildSkillsSection(
              'Skills I Teach',
              _userData['teachingSkills'],
              onAddPressed: () {
                // TODO: Add teaching skill
              },
            ),
            const SizedBox(height: 16),
            _buildSkillsSection(
              'Skills I Want to Learn',
              _userData['learningSkills'],
              onAddPressed: () {
                // TODO: Add learning skill
              },
            ),
            const SizedBox(height: 16),
            _buildStatsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(_userData['avatar']),
              child: const Icon(Icons.person, size: 60),
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.camera_alt, color: Colors.white),
                onPressed: () {
                  // TODO: Implement image picker
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          _userData['name'],
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(
          _userData['email'],
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          _userData['bio'],
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildSkillsSection(String title, List<Skill> skills, {required VoidCallback onAddPressed}) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.add),
              onPressed: onAddPressed,
            ),
          ),
          if (skills.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text('No skills added yet'),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: skills.length,
              itemBuilder: (context, index) {
                final skill = skills[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Icon(_getCategoryIcon(skill.category)),
                  ),
                  title: Text(skill.name),
                  subtitle: Text(skill.level.displayName),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // TODO: Edit skill
                    },
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('Matches', '12'),
            _buildStatItem('Teaching Hours', '24'),
            _buildStatItem('Learning Hours', '18'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'languages':
        return Icons.language;
      case 'arts':
        return Icons.palette;
      case 'music':
        return Icons.music_note;
      case 'technology':
        return Icons.computer;
      default:
        return Icons.school;
    }
  }
} 