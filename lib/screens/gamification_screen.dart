import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;

import 'landing_screen.dart';
import '../widgets/rolltrack_animation.dart';

class GamificationScreen extends StatefulWidget {
  const GamificationScreen({super.key});

  @override
  State<GamificationScreen> createState() => _GamificationScreenState();
}

class _GamificationScreenState extends State<GamificationScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _firstOpacity;
  late Animation<double> _secondOpacity;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    // Slide animation for number 1: starts from center (0) to left (-1.5 offset)
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(-1.5, 0),
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    // Opacity: first number fades out during first half, second fades in during second half
    _firstOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.0, 0.5, curve: Curves.easeIn)),
    );

    _secondOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.5, 1.0, curve: Curves.easeOut)),
    );

    _animationController.forward();

    // After 5 seconds go back to the main/landing screen automatically
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LandingScreen()),
        (route) => false,
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox.shrink(),
    );
  }
}
