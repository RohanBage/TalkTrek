import 'package:flutter/material.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  bool _isConnected = true;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final TextEditingController _feedbackController = TextEditingController();
  int _selectedRating = 0;
  String _selectedCategory = 'General';
  bool _isSending = false;
  bool _feedbackSent = false;

  final List<String> _feedbackCategories = [
    'General',
    'App Performance',
    'Lesson Content',
    'User Interface',
    'Practice Exercises',
    'Bug Report',
    'Feature Request'
  ];

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _initConnectivitySubscription();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _feedbackController.dispose();
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
      });
    });
  }

  Future<void> _submitFeedback() async {
    if (_feedbackController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your feedback')),
      );
      return;
    }

    if (_selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a rating')),
      );
      return;
    }

    setState(() {
      _isSending = true;
    });

    // Simulate API call with delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isSending = false;
      _feedbackSent = true;
    });

    // Reset form after successful submission
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _feedbackSent = false;
          _feedbackController.clear();
          _selectedRating = 0;
          _selectedCategory = 'General';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Feedback'),
        backgroundColor: Colors.indigo,
      ),
      body: !_isConnected ? _buildNoConnectionView() : _buildFeedbackForm(size),
    );
  }

  Widget _buildNoConnectionView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.signal_wifi_off,
            size: 100,
            color: Colors.red,
          ),
          SizedBox(height: 20),
          Text(
            'No Internet Connection',
            style: TextStyle(fontSize: 20, color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackForm(Size size) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Feedback Category:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          DropdownButton<String>(
            value: _selectedCategory,
            isExpanded: true,
            onChanged: (String? newValue) {
              setState(() {
                _selectedCategory = newValue!;
              });
            },
            items: _feedbackCategories.map<DropdownMenuItem<String>>(
              (String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              },
            ).toList(),
          ),
          const SizedBox(height: 20),
          const Text(
            'Rating:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Row(
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < _selectedRating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 30,
                ),
                onPressed: () {
                  setState(() {
                    _selectedRating = index + 1;
                  });
                },
              );
            }),
          ),
          const SizedBox(height: 20),
          const Text(
            'Your Feedback:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _feedbackController,
            maxLines: 5,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter your feedback here',
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSending ? null : _submitFeedback,
              child: _isSending
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Submit Feedback'),
            ),
          ),
          if (_feedbackSent)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Feedback sent successfully!',
                  style: TextStyle(color: Colors.green, fontSize: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
