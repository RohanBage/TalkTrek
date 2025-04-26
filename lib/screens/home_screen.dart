import 'package:flutter/material.dart';
import '../widgets/nav_button.dart';
import '../widgets/language_card.dart';
import '../widgets/schedule_item.dart';
import '../models/user_model.dart';
import '../models/language_model.dart';
import '../models/schedule_model.dart' show ScheduleItemModel;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late User user;
  List<Language> languages = [];
  List<ScheduleItemModel> scheduleItems = [];

  @override
  void initState() {
    super.initState();
    user = User(
      name: 'John Doe',
      email: 'john@example.com',
      profileImage: 'assets/images/profile.png',
      streak: 15,
      points: 2750,
      level: 4,
    );

    languages = [
      Language(
        id: '1',
        name: 'Spanish',
        flag: '🇪🇸',
        progress: 0.45,
        lessonsCompleted: 27,
        totalLessons: 60,
      ),
      Language(
        id: '2',
        name: 'French',
        flag: '🇫🇷',
        progress: 0.2,
        lessonsCompleted: 12,
        totalLessons: 60,
      ),
      Language(
        id: '3',
        name: 'German',
        flag: '🇩🇪',
        progress: 0.05,
        lessonsCompleted: 3,
        totalLessons: 60,
      ),
    ];

    scheduleItems = [
      ScheduleItemModel(
        id: '1',
        title: 'Spanish Verbs',
        dayOfWeek: 'Monday',
        time: '10:00 AM',
        duration: 30,
      ),
      ScheduleItemModel(
        id: '2',
        title: 'French Vocabulary',
        dayOfWeek: 'Wednesday',
        time: '2:00 PM',
        duration: 45,
      ),
      ScheduleItemModel(
        id: '3',
        title: 'Spanish Practice',
        dayOfWeek: 'Friday',
        time: '6:00 PM',
        duration: 30,
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushNamed(context, '/learn');
        break;
      case 2:
        Navigator.pushNamed(context, '/practice');
        break;
      case 3:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TalkTrek'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGreetingSection(),
            const SizedBox(height: 24),
            _buildProgressSection(),
            const SizedBox(height: 24),
            _buildScheduleSection(),
            const SizedBox(height: 24),
            _buildQuickActionsSection(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Learn'),
          BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center), label: 'Practice'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildGreetingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello, ${user.name}!',
          style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'Current streak: ${user.streak} days | Level: ${user.level}',
          style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildProgressSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('My Languages',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Column(
              children: languages
                  .map((lang) => LanguageCard(
                        languageName: lang.name,
                        flagCode: lang.flag,
                        lessonCount: lang.lessonsCompleted,
                        level: _getLevelFromProgress(lang.progress),
                        progress: lang.progress,
                        onTap: () {},
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/learn');
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 40)),
              child: const Text('Add a new language'),
            ),
          ],
        ),
      ),
    );
  }

  String _getLevelFromProgress(double progress) {
    if (progress < 0.3) return 'Beginner';
    if (progress < 0.7) return 'Intermediate';
    return 'Advanced';
  }

  Widget _buildScheduleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('This Week\'s Schedule',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: scheduleItems
                .map((item) => ScheduleItem(
                      title: item.title,
                      time: item.time,
                      icon: _getIconForScheduleItem(item),
                      color: _getColorForScheduleItem(item),
                      description: '${item.dayOfWeek} • ${item.duration} min',
                      onTap: () {},
                      isCompleted: false,
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  IconData _getIconForScheduleItem(ScheduleItemModel item) {
    if (item.title.contains('Verbs')) return Icons.article;
    if (item.title.contains('Vocabulary')) return Icons.library_books;
    return Icons.school;
  }

  Color _getColorForScheduleItem(ScheduleItemModel item) {
    if (item.title.contains('Spanish')) return Colors.red;
    if (item.title.contains('French')) return Colors.blue;
    return Colors.indigo;
  }

  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quick Actions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildQuickAction(Icons.video_library, 'Video Lessons', () {
              Navigator.pushNamed(context, '/learn');
            }),
            _buildQuickAction(Icons.quiz, 'Practice Test', () {
              Navigator.pushNamed(context, '/practice');
            }),
            _buildQuickAction(Icons.chat, 'Community', () {
              // Implement navigation
            }),
            _buildQuickAction(Icons.settings, 'Settings', () {
              // Implement navigation
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickAction(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Theme.of(context).primaryColor, size: 24),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
