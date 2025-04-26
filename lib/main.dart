import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart';
import 'screens/learn_screen.dart';
import 'screens/practice_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/feedback_screen.dart';
import 'screens/auth_screen.dart';
import 'widgets/connectivity_manager.dart';
import 'widgets/offline_screen.dart';
import 'firebase_options.dart';

void main() async {
  // Ensure Flutter is initialized before using platform channels
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MaterialApp(
      // Wrap with MaterialApp to provide Directionality
      home: ConnectivityManager(
        onlineChild: TalkTrekApp(),
        offlineChild: const OfflineScreen(),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class TalkTrekApp extends StatelessWidget {
  const TalkTrekApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TalkTrek',
      theme: ThemeData(
        primaryColor: const Color(0xFF3F51B5),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFF303F9F),
          surface: Colors.white,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
              fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
          displayMedium: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87),
          bodyLarge: TextStyle(fontSize: 16.0, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 14.0, color: Colors.black54),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: const Color(0xFF3F51B5),
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
      initialRoute: '/auth',
      routes: {
        '/auth': (context) => AuthScreen(),
        '/home': (context) => HomeScreen(),
        '/learn': (context) => const LearnScreen(),
        '/practice': (context) => const PracticeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/feedback': (context) => const FeedbackScreen(),
      },
    );
  }
}
