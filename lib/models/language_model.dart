// Modify language_model.dart
class Language {
  final String id;
  final String name;
  final String flag; // Add this
  final double progress;
  final int lessonsCompleted;
  final int totalLessons;

  Language({
    required this.id,
    required this.name,
    required this.flag,
    required this.progress,
    required this.lessonsCompleted,
    required this.totalLessons,
  });
}
