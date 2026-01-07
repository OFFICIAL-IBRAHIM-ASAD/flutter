import 'package:flutter/material.dart';
import '../../core/theme/app_colours.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // UPDATED DATA: Using 'IconData' instead of image paths
  final List<Map<String, dynamic>> _onboardingData = [
    {
      "title": "Build Habits That Stick",
      "subtitle":
      "Easily track your daily activities and watch your progress grow over time.",
      "icon": Icons.local_florist, // Plant icon representing growth
    },
    {
      "title": "Track Your Progress",
      "subtitle": "Stay motivated by watching your successful days add up.",
      "icon": Icons.trending_up, // Chart icon representing progress
    },
    {
      "title": "Join a Thriving Community",
      "subtitle":
      "Get motivation from friends or understand your journey through detailed charts.",
      "icon": Icons.groups, // Group icon representing community
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // 1. SKIP BUTTON
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Skip",
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            // 2. SLIDING CONTENT
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // --- ICON DISPLAY (Replaces Image) ---
                        Container(
                          height: 250,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            // FIX: Changed .withOpacity to .withValues
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            _onboardingData[index]["icon"],
                            size: 100,
                            color: AppColors.primary,
                          ),
                        ),

                        // -------------------------------------
                        const SizedBox(height: 40),

                        // Title
                        Text(
                          _onboardingData[index]["title"],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.textMain,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Subtitle
                        Text(
                          _onboardingData[index]["subtitle"],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // 3. BOTTOM SECTION
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onboardingData.length,
                          (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppColors.primary
                          // FIX: Changed .withOpacity to .withValues
                              : AppColors.primary.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Continue Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentPage < _onboardingData.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        } else {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _currentPage == _onboardingData.length - 1
                            ? "Get Started"
                            : "Continue",
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}