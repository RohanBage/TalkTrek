import 'package:flutter/material.dart';

class LanguageCard extends StatelessWidget {
  final String languageName;
  final String flagCode;
  final int lessonCount;
  final String level;
  final double progress;
  final VoidCallback onTap;

  const LanguageCard({
    Key? key,
    required this.languageName,
    required this.flagCode,
    required this.lessonCount,
    required this.level,
    required this.progress,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildFlagCircle(),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          languageName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$lessonCount lessons • $level',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getLevelColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      level,
                      style: TextStyle(
                        color: _getLevelColor(),
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${(progress * 100).toInt()}% Complete',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[200],
                          color: _getLevelColor(),
                          borderRadius: BorderRadius.circular(10),
                          minHeight: 8,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  CircleAvatar(
                    backgroundColor: Colors.indigo.withOpacity(0.1),
                    radius: 16,
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.indigo,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlagCircle() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: _getLanguageColor(),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          flagCode,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Color _getLanguageColor() {
    switch (languageName.toLowerCase()) {
      case 'spanish':
        return Colors.red;
      case 'french':
        return Colors.blue;
      case 'german':
        return Colors.amber;
      case 'japanese':
        return Colors.deepPurple;
      case 'italian':
        return Colors.green;
      case 'chinese':
        return Colors.orange;
      default:
        return Colors.indigo;
    }
  }

  Color _getLevelColor() {
    switch (level.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.indigo;
    }
  }
}
