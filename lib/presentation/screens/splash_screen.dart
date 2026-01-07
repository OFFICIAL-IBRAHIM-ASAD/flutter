import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colours.dart';
import 'onboarding_screen.dart'; // Import Onboarding to navigate there

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  // FIX: Moved navigation here to safely check if the widget is still on screen
  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    // --- SMART NAVIGATION LOGIC ---
    final authProvider = context.read<AuthProvider>();

    if (authProvider.user != null) {
      // 1. User is already logged in -> Go to Home
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // 2. No user found -> Go to Onboarding
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen())
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Stack(
          children: [
            // Center Part: Logo and Text
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 1. The Logo Circle
                  Container(
                    height: 96,
                    width: 96,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.spa,
                      color: AppColors.white,
                      size: 64,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 2. Headline "HealthyHabits"
                  const Text(
                    "HealthyHabits",
                    style: TextStyle(
                      color: AppColors.textMain,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 3. Subtitle
                  const Text(
                    "Build a Better You",
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Part: Loading Dots
            Positioned(
              bottom: 48,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDot(),
                  const SizedBox(width: 8),
                  _buildDot(),
                  const SizedBox(width: 8),
                  _buildDot(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot() {
    return Container(
      height: 8,
      width: 8,
      decoration: BoxDecoration(
        // FIX: Changed .withValues(alpha:) to .withValues(alpha: ...)
        color: AppColors.primary.withValues(alpha: 0.5),
        shape: BoxShape.circle,
      ),
    );
  }
}