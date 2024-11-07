import 'package:flutter/material.dart';
import '../../models/skill.dart';

class DiscoverTab extends StatefulWidget {
  const DiscoverTab({super.key});

  @override
  State<DiscoverTab> createState() => _DiscoverTabState();
}

class _DiscoverTabState extends State<DiscoverTab> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  Set<SkillLevel> _selectedLevels = {};

  List<Skill> get _filteredSkills => _mockSkills.where((skill) {
    // Filter by search query
    if (_searchQuery.isNotEmpty && 
        !skill.name.toLowerCase().contains(_searchQuery.toLowerCase())) {
      return false;
    }
    
    // Filter by category
    if (_selectedCategory != 'All' && skill.category != _selectedCategory) {
      return false;
    }

    // Filter by level
    if (_selectedLevels.isNotEmpty && !_selectedLevels.contains(skill.level)) {
      return false;
    }

    return true;
  }).toList();

  List<Skill> get _mockSkills => [
    Skill(
      id: '1',
      name: 'Spanish Language',
      description: 'Learn conversational Spanish for everyday use',
      category: 'Languages',
      requirements: ['Dedication to practice', 'Basic understanding of grammar'],
      level: SkillLevel.beginner,
    ),
    Skill(
      id: '2',
      name: 'Photography Basics',
      description: 'Master the fundamentals of digital photography',
      category: 'Arts',
      requirements: ['Digital camera', 'Basic photo editing software'],
      level: SkillLevel.intermediate,
    ),
    Skill(
      id: '3',
      name: 'Guitar for Beginners',
      description: 'Start your journey into playing guitar',
      category: 'Music',
      requirements: ['Own guitar', 'Music theory basics'],
      level: SkillLevel.beginner,
    ),
    Skill(
      id: '4',
      name: 'Web Development',
      description: 'Learn HTML, CSS, and JavaScript',
      category: 'Technology',
      requirements: ['Computer', 'Internet connection', 'Basic computer skills'],
      level: SkillLevel.intermediate,
    ),
    Skill(
      id: '5',
      name: 'French Cuisine',
      description: 'Master the art of French cooking',
      category: 'Cooking',
      requirements: ['Basic cooking equipment', 'Access to ingredients'],
      level: SkillLevel.expert,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Skills'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => FilterSheet(
                  selectedLevels: _selectedLevels,
                  onLevelsChanged: (levels) {
                    setState(() {
                      _selectedLevels = levels;
                    });
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
            child: Column(
              children: [
                SearchBar(
                  hintText: 'Search skills...',
                  leading: const Icon(Icons.search),
                  elevation: MaterialStateProperty.all(0),
                  backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.surface,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text('All'),
                        selected: _selectedCategory == 'All',
                        onSelected: (bool selected) {
                          setState(() {
                            _selectedCategory = 'All';
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      ...['Languages', 'Arts', 'Music', 'Technology', 'Cooking']
                          .map((category) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: FilterChip(
                                  label: Text(category),
                                  selected: _selectedCategory == category,
                                  onSelected: (bool selected) {
                                    setState(() {
                                      _selectedCategory = selected ? category : 'All';
                                    });
                                  },
                                ),
                              ))
                          .toList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_filteredSkills.isEmpty)
            const Expanded(
              child: Center(
                child: Text('No skills found matching your criteria'),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _filteredSkills.length,
                itemBuilder: (context, index) {
                  final skill = _filteredSkills[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                            child: Icon(
                              _getCategoryIcon(skill.category),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          title: Text(
                            skill.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(skill.category),
                          trailing: Chip(
                            label: Text(
                              skill.level.displayName,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                            ),
                            backgroundColor: _getLevelColor(skill.level),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                skill.description,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Requirements:',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              ...skill.requirements.map((req) => Padding(
                                    padding: const EdgeInsets.only(left: 8, bottom: 4),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle_outline,
                                          size: 16,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(child: Text(req)),
                                      ],
                                    ),
                                  )),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // TODO: Implement skill details navigation
                                      },
                                      child: const Text('Learn More'),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.favorite_border),
                                    onPressed: () {
                                      // TODO: Implement favorites
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
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

  Color _getLevelColor(SkillLevel level) {
    switch (level) {
      case SkillLevel.beginner:
        return Colors.green.shade100;
      case SkillLevel.intermediate:
        return Colors.orange.shade100;
      case SkillLevel.expert:
        return Colors.red.shade100;
    }
  }
}

class FilterSheet extends StatefulWidget {
  final Set<SkillLevel> selectedLevels;
  final Function(Set<SkillLevel>) onLevelsChanged;

  const FilterSheet({
    super.key, 
    required this.selectedLevels,
    required this.onLevelsChanged,
  });

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late Set<SkillLevel> _selectedLevels;

  @override
  void initState() {
    super.initState();
    _selectedLevels = Set.from(widget.selectedLevels);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter Skills',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                onPressed: _selectedLevels.isEmpty ? null : () {
                  setState(() {
                    _selectedLevels.clear();
                  });
                },
                child: const Text('Clear All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Skill Level'),
          Wrap(
            spacing: 8,
            children: SkillLevel.values
                .map((level) => FilterChip(
                      label: Text(level.displayName),
                      selected: _selectedLevels.contains(level),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _selectedLevels.add(level);
                          } else {
                            _selectedLevels.remove(level);
                          }
                        });
                      },
                    ))
                .toList(),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onLevelsChanged(_selectedLevels);
                Navigator.pop(context);
              },
              child: const Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }
} 