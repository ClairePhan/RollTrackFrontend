import 'package:flutter/material.dart';
import 'landing_screen.dart';

class GamificationScreen extends StatefulWidget {
  const GamificationScreen({super.key});

  @override
  State<GamificationScreen> createState() => _GamificationScreenState();
}

class _GamificationScreenState extends State<GamificationScreen>
    with TickerProviderStateMixin {
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
    final screenSize = MediaQuery.of(context).size;
    final iconSize = screenSize.width * 0.25;
    final numberFontSize = screenSize.width * 0.20;
    // removed unused button sizing since there is no manual button
    final verticalSpacing = screenSize.height * 0.05;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF667eea),
                  Color(0xFF764ba2),
                ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  // Trophy/Achievement Icon
                  Icon(
                    Icons.emoji_events,
                    size: iconSize,
                    color: Colors.yellow,
                  ),
                  SizedBox(height: verticalSpacing),

                  // Animated Number (1 to 2)
                  SizedBox(
                    height: numberFontSize * 1.5,
                    width: screenSize.width,
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            // Number 1 - slides from center to left and fades out
                            Opacity(
                              opacity: _firstOpacity.value,
                              child: SlideTransition(
                                position: _slideAnimation,
                                child: Text(
                                  '1',
                                  style: TextStyle(
                                    fontSize: numberFontSize,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),

                            // Number 2 - slides in from the right to center and fades in
                            Opacity(
                              opacity: _secondOpacity.value,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(1.5, 0),
                                  end: const Offset(0, 0),
                                ).animate(
                                  CurvedAnimation(
                                    parent: _animationController,
                                    curve: Curves.easeInOut,
                                  ),
                                ),
                                child: Text(
                                  '2',
                                  style: TextStyle(
                                    fontSize: numberFontSize,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  SizedBox(height: verticalSpacing * 1.5),

                  // Spacer to keep layout balanced (no manual button)
                      SizedBox(height: verticalSpacing),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
