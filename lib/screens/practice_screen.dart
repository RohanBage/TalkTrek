import 'package:flutter/material.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({Key? key}) : super(key: key);

  @override
  _PracticeScreenState createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  bool _isConnected = true;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  List<Map<String, dynamic>> _practiceItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _initConnectivitySubscription();
    _fetchPracticeItems();
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
        if (_isConnected && _practiceItems.isEmpty) {
          _fetchPracticeItems();
        }
      });
    });
  }

  Future<void> _fetchPracticeItems() async {
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
      _practiceItems = [
        {
          'title': 'Vocabulary Quiz',
          'description': 'Test your knowledge of basic vocabulary',
          'level': 'Beginner',
          'duration': '10 min',
          'icon': Icons.quiz,
          'progress': 0.0,
          'type': 'quiz'
        },
        {
          'title': 'Listening Exercise',
          'description': 'Improve your listening comprehension skills',
          'level': 'Intermediate',
          'duration': '15 min',
          'icon': Icons.headphones,
          'progress': 0.3,
          'type': 'listening'
        },
        {
          'title': 'Grammar Test',
          'description': 'Practice your grammar knowledge',
          'level': 'Advanced',
          'duration': '20 min',
          'icon': Icons.rule,
          'progress': 0.7,
          'type': 'grammar'
        },
        {
          'title': 'Pronunciation Challenge',
          'description': 'Perfect your accent with these exercises',
          'level': 'All levels',
          'duration': '10 min',
          'icon': Icons.record_voice_over,
          'progress': 0.5,
          'type': 'pronunciation'
        },
        {
          'title': 'Conversation Scenarios',
          'description': 'Practice real-world conversations',
          'level': 'Intermediate',
          'duration': '15 min',
          'icon': Icons.chat_bubble,
          'progress': 0.2,
          'type': 'conversation'
        },
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice'),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchPracticeItems,
          ),
        ],
      ),
      body: !_isConnected
          ? _buildNoConnectionView()
          : _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildPracticeList(),
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

  Widget _buildPracticeList() {
    return RefreshIndicator(
      onRefresh: _fetchPracticeItems,
      child: _practiceItems.isEmpty
          ? const Center(child: Text('No practice exercises available'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _practiceItems.length,
              itemBuilder: (context, index) {
                final item = _practiceItems[index];
                return _buildPracticeCard(item);
              },
            ),
    );
  }

  Widget _buildPracticeCard(Map<String, dynamic> item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Handle practice item tap
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Starting ${item['title']}')),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.indigo.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      item['icon'],
                      color: Colors.indigo,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['description'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildInfoChip(item['level'], Icons.signal_cellular_alt),
                  const SizedBox(width: 8),
                  _buildInfoChip(item['duration'], Icons.access_time),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: item['progress'],
                backgroundColor: Colors.grey[200],
                color: Colors.indigo,
                borderRadius: BorderRadius.circular(10),
                minHeight: 8,
              ),
              const SizedBox(height: 8),
              Text(
                '${(item['progress'] * 100).toInt()}% Complete',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.grey[700],
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
