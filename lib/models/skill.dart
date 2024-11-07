class Skill {
  final String id;
  final String name;
  final String description;
  final String category;
  final List<String> requirements;
  final SkillLevel level;

  Skill({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.requirements,
    required this.level,
  });
}

enum SkillLevel {
  beginner,
  intermediate,
  expert;

  String get displayName {
    switch (this) {
      case SkillLevel.beginner:
        return 'Beginner';
      case SkillLevel.intermediate:
        return 'Intermediate';
      case SkillLevel.expert:
        return 'Expert';
    }
  }
} 