import 'package:flutter/material.dart';
import 'landing_screen.dart';

class GamificationScreen extends StatelessWidget {
  const GamificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = screenSize.width > screenSize.height;
    
    // Responsive sizing based on screen dimensions
    final iconSize = screenSize.width * 0.25;
    final titleFontSize = screenSize.width * 0.12;
    final subtitleFontSize = screenSize.width * 0.06;
    final buttonFontSize = screenSize.width * 0.05;
    final buttonPadding = screenSize.width * 0.15;
    final verticalSpacing = screenSize.height * 0.05;
    
    return Scaffold(
      body: Container(
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
                  
                  // Title
                  Text(
                    'Great Job!',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: verticalSpacing * 0.5),
                  
                  // Subtitle
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
                    child: Text(
                      'You have successfully checked in your people',
                      style: TextStyle(
                        fontSize: subtitleFontSize,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: verticalSpacing * 1.5),
                  
                  // Back to Home Button
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: buttonPadding),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LandingScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: screenSize.height * 0.03,
                          horizontal: screenSize.width * 0.1,
                        ),
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF667eea),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        'Back to Home',
                        style: TextStyle(
                          fontSize: buttonFontSize,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
