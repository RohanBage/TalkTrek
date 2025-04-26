import 'package:flutter/material.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityManager extends StatefulWidget {
  final Widget onlineChild;
  final Widget offlineChild;

  const ConnectivityManager({
    super.key,
    required this.onlineChild,
    required this.offlineChild,
  });

  @override
  State<ConnectivityManager> createState() => _ConnectivityManagerState();
}

class _ConnectivityManagerState extends State<ConnectivityManager> {
  bool _isConnected = true;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _initConnectivitySubscription();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    _updateConnectionStatus(result);
  }

  void _initConnectivitySubscription() {
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    final isConnected = result != ConnectivityResult.none;
    if (_isConnected != isConnected) {
      setState(() {
        _isConnected = isConnected;
      });

      // Show connection status snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isConnected
                ? 'Connected to the internet'
                : 'No internet connection',
          ),
          backgroundColor: isConnected ? Colors.green : Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isConnected ? widget.onlineChild : widget.offlineChild;
  }
}
