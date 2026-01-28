import 'package:flutter/material.dart';
import '/screens/find_your_profile_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FindYourProfilePage(),
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
              ),
            ),
          ),
        ),
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