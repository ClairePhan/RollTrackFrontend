import 'package:flutter/material.dart';
<<<<<<< HEAD
import '../models/class_model.dart';
import '/screens/phone_input_screen.dart';
=======
import 'phone_input_screen.dart';
>>>>>>> 5798e9a4e0e7ce4a3a2536e3249a62e9aff1050a

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    // Get the screen size
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PhoneInputScreen(),
          ),
        );
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFB832F5),
                Color(0xFF6A3DBE),
              ],
            ),
          ),
          child: Center(
            child: Transform.translate(
              // Use a fraction of the screen height for offset
              offset: Offset(0, -screenHeight * 0.08),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Main heading text
                  Text(
                    'Check In!',
                    style: TextStyle(
                      // Font size scales with screen width
                      fontSize: screenWidth * 0.15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.01),

                  // Row with divider lines and subtitle
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _dividerLine(screenWidth),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                        child: Text(
                          'Tap anywhere to start',
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      _dividerLine(screenWidth),
                    ],
                  ),
                ],
=======
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PhoneInputScreen(),
                ),
              );
            },
            child: Container(
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  // Check in Title
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: const Text(
                      'Check in',
                      style: TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.02,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            blurRadius: 20,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Tap anywhere to start
                  const Text(
                    'Tap anywhere to start!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                    ],
                  ),
                ),
>>>>>>> 5798e9a4e0e7ce4a3a2536e3249a62e9aff1050a
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Divider line that scales with screen width
  static Widget _dividerLine(double screenWidth) {
    return Container(
      width: screenWidth * 0.10, // 18% of screen width
      height: 2,
      color: Colors.white70,
    );
  }
}