// Modify user_model.dart
class User {
  final String name;
  final String email;
  final String profileImage; // Add this
  final int streak; // Add this
  final int points;
  final int level; // Add this

  User({
    required this.name,
    required this.email,
    required this.profileImage,
    required this.streak,
    required this.points,
    required this.level,
  });
}
