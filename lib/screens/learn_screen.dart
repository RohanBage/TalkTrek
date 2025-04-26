import 'package:flutter/material.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({Key? key}) : super(key: key);

  @override
  _LearnScreenState createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  // Sample data for learning resources
  final List<Map<String, dynamic>> _learningResources = [
    {
      'title': 'Video Lessons',
      'description': 'Interactive video tutorials with native speakers',
      'icon': Icons.video_library,
      'count': 24,
      'color': Colors.blue.shade700,
    },
    {
      'title': 'Audio Books',
      'description': 'Listen to stories narrated in your target language',
      'icon': Icons.headphones,
      'count': 12,
      'color': Colors.green.shade700,
    },
    {
      'title': 'Flashcards',
      'description': 'Practice vocabulary with digital flashcards',
      'icon': Icons.layers,
      'count': 150,
      'color': Colors.orange.shade700,
    },
    {
      'title': 'Grammar Guides',
      'description': 'Comprehensive guides to language grammar rules',
      'icon': Icons.menu_book,
      'count': 8,
      'color': Colors.purple.shade700,
    }
  ];

  // Currently selected language (would come from user settings in a real app)
  String _selectedLanguage = 'Spanish';

  // List of available languages
  final List<String> _languages = [
    'Spanish',
    'French',
    'German',
    'Japanese',
    'Italian',
    'Korean',
    'Mandarin',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Learn',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo.shade800,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Implement filter functionality
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLanguageSelector(),
          _buildLearningPathProgress(),
          Expanded(
            child: _buildLearningResources(),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Container(
      color: Colors.indigo.shade800,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Language',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedLanguage,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                isExpanded: true,
                dropdownColor: Colors.indigo.shade700,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedLanguage = newValue;
                    });
                  }
                },
                items: _languages.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildLearningPathProgress() {
    // Current user progress (would come from user data in a real app)
    const int completedLessons = 18;
    const int totalLessons = 30;
    const double progressPercentage = completedLessons / totalLessons;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$_selectedLanguage Learning Path',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$completedLessons/$totalLessons',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progressPercentage,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo.shade600),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Current Level: Intermediate',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to detailed progress view
                },
                child: Text(
                  'View Details',
                  style: TextStyle(
                    color: Colors.indigo.shade700,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildLearningResources() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Text(
            'Learning Resources',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.9,
          ),
          itemCount: _learningResources.length,
          itemBuilder: (context, index) {
            final resource = _learningResources[index];
            return _buildResourceCard(
              title: resource['title'],
              description: resource['description'],
              icon: resource['icon'],
              count: resource['count'],
              color: resource['color'],
            );
          },
        ),
        const SizedBox(height: 24),
        _buildRecommendedLessons(),
      ],
    );
  }

  Widget _buildResourceCard({
    required String title,
    required String description,
    required IconData icon,
    required int count,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        // Navigate to the specific resource type
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Text(
                '$count items',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendedLessons() {
    // Recommended lessons based on user progress (sample data)
    final List<Map<String, dynamic>> recommendedLessons = [
      {
        'title': 'Mastering Past Tense',
        'duration': '15 min',
        'level': 'Intermediate',
      },
      {
        'title': 'Essential Travel Phrases',
        'duration': '10 min',
        'level': 'Beginner',
      },
      {
        'title': 'Food and Dining Vocabulary',
        'duration': '20 min',
        'level': 'Intermediate',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recommended For You',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'See All',
              style: TextStyle(
                color: Colors.indigo,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...recommendedLessons.map((lesson) => _buildLessonCard(
              title: lesson['title'],
              duration: lesson['duration'],
              level: lesson['level'],
            )),
      ],
    );
  }

  Widget _buildLessonCard({
    required String title,
    required String duration,
    required String level,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '$level • $duration',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.play_circle_filled,
            color: Colors.indigo,
            size: 36,
          ),
          onPressed: () {
            // Start the lesson
          },
        ),
      ),
    );
  }
}
