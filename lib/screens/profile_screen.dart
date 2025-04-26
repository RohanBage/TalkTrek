import 'package:flutter/material.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isConnected = true;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _isLoading = true;
  Map<String, dynamic> _userData = {};
  List<Map<String, dynamic>> _achievements = [];
  bool _isDarkMode = false;
  bool _isNotificationsEnabled = true;
  String _selectedLanguage = 'English';

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _initConnectivitySubscription();
    _loadUserData();
    _loadSettings();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _checkConnectivity() async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = result != ConnectivityResult.none;
    });
  }

  void _initConnectivitySubscription() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {
        _isConnected = result != ConnectivityResult.none;
        if (_isConnected && _userData.isEmpty) {
          _loadUserData();
        }
      });
    });
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('darkMode') ?? false;
      _isNotificationsEnabled = prefs.getBool('notifications') ?? true;
      _selectedLanguage = prefs.getString('appLanguage') ?? 'English';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', _isDarkMode);
    await prefs.setBool('notifications', _isNotificationsEnabled);
    await prefs.setString('appLanguage', _selectedLanguage);
  }

  Future<void> _loadUserData() async {
    // Simulate API call with delay
    setState(() {
      _isLoading = true;
    });

    if (!_isConnected) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock data - in a real app you would fetch this from an API
    setState(() {
      _userData = {
        'name': 'Alex Johnson',
        'email': 'alex.johnson@example.com',
        'profileImageUrl': 'https://example.com/profile.jpg',
        'level': 'Intermediate',
        'points': 1250,
        'streak': 15,
        'joined': 'January 2023',
        'languagesLearning': ['Spanish', 'French'],
        'completedLessons': 42,
        'totalPracticeTime': '38h 15m',
      };

      _achievements = [
        {
          'title': '7-Day Streak',
          'description': 'Practice every day for a week',
          'iconData': Icons.local_fire_department,
          'earned': true,
          'date': '2023-03-15',
        },
        {
          'title': 'Vocabulary Master',
          'description': 'Learn 500 new words',
          'iconData': Icons.menu_book,
          'earned': true,
          'date': '2023-04-02',
        },
        {
          'title': 'Perfect Score',
          'description': 'Get 100% on any practice test',
          'iconData': Icons.star,
          'earned': true,
          'date': '2023-05-10',
        },
        {
          'title': 'Conversation Expert',
          'description': 'Complete all conversation scenarios',
          'iconData': Icons.chat,
          'earned': false,
          'date': null,
        },
        {
          'title': '30-Day Streak',
          'description': 'Practice every day for a month',
          'iconData': Icons.whatshot,
          'earned': false,
          'date': null,
        },
      ];

      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              _showSettingsDialog(context);
            },
          ),
        ],
      ),
      body: !_isConnected
          ? _buildNoConnectionView()
          : _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildProfileContent(),
    );
  }

  Widget _buildNoConnectionView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.signal_wifi_off,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            'No internet connection',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Check your connection and try again',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _checkConnectivity,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 16),
          _buildStatsSection(),
          const SizedBox(height: 24),
          _buildAchievementsSection(),
          const SizedBox(height: 16),
          _buildActionsSection(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.indigo,
      ),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _userData['name'] ?? 'User Name',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _userData['email'] ?? 'user@example.com',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.indigo.shade700,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              _userData['level'] ?? 'Beginner',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Progress',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatCard(
                Icons.emoji_events,
                '${_userData['points'] ?? 0}',
                'Points',
                Colors.amber,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                Icons.local_fire_department,
                '${_userData['streak'] ?? 0}',
                'Day Streak',
                Colors.deepOrange,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatCard(
                Icons.book,
                '${_userData['completedLessons'] ?? 0}',
                'Lessons',
                Colors.green,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                Icons.access_time,
                _userData['totalPracticeTime'] ?? '0h',
                'Practice Time',
                Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      IconData icon, String value, String label, Color color) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Achievements',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(
            _achievements.length,
            (index) => _buildAchievementItem(_achievements[index]),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(Map<String, dynamic> achievement) {
    final bool earned = achievement['earned'] ?? false;
    final Color color = earned ? Colors.indigo : Colors.grey;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: earned ? Colors.indigo.withOpacity(0.3) : Colors.transparent,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                achievement['iconData'] ?? Icons.emoji_events,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    achievement['title'] ?? 'Achievement',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: earned ? Colors.black87 : Colors.grey,
                    ),
                  ),
                  Text(
                    achievement['description'] ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (earned)
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 20,
              )
            else
              const Icon(
                Icons.lock,
                color: Colors.grey,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Account',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            Icons.edit,
            'Edit Profile',
            () {
              // Handle edit profile
            },
          ),
          _buildActionButton(
            Icons.language,
            'Languages',
            () {
              // Handle languages
            },
          ),
          _buildActionButton(
            Icons.help_outline,
            'Help & Support',
            () {
              // Handle help & support
            },
          ),
          _buildActionButton(
            Icons.exit_to_app,
            'Log Out',
            () {
              // Handle logout
              _showLogoutConfirmationDialog(context);
            },
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    VoidCallback onPressed, {
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? Colors.red : Colors.indigo,
              size: 22,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: isDestructive ? Colors.red : Colors.black87,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Settings'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  title: const Text('Dark Mode'),
                  value: _isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      _isDarkMode = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text('Notifications'),
                  value: _isNotificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _isNotificationsEnabled = value;
                    });
                  },
                ),
                ListTile(
                  title: const Text('App Language'),
                  trailing: DropdownButton<String>(
                    value: _selectedLanguage,
                    items: const [
                      DropdownMenuItem(
                          value: 'English', child: Text('English')),
                      DropdownMenuItem(
                          value: 'Spanish', child: Text('Spanish')),
                      DropdownMenuItem(value: 'French', child: Text('French')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedLanguage = value;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  _saveSettings();
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle logout logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out successfully')),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}
