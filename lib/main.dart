import 'package:flutter/material.dart';
import 'screens/landing_screen.dart';
import 'screens/classes_screen.dart';

void main() {
  runApp(const RollTrackApp());
}

class RollTrackApp extends StatelessWidget {
  const RollTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RollTrack',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const LandingScreen(),
      routes: {
        '/classes': (context) => const ClassesScreen(),
      },
    );
  }
}
