import 'package:flutter/material.dart';
import '../theme.dart';
import 'login_guest_access_screen.dart';
import 'onboarding_risk_screen.dart';
import 'onboarding_objective_screen.dart';
import 'onboarding_competition_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginGuestAccessScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: MidnightNeonTheme.radialBackground,
          ),
          // PageView of distinct steps
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              OnboardingRiskScreen(
                onNext: _onNextPressed,
                onSkip: _finishOnboarding,
              ),
              OnboardingObjectiveScreen(
                onNext: _onNextPressed,
                onSkip: _finishOnboarding,
              ),
              OnboardingCompetitionScreen(
                onNext: _finishOnboarding,
                onSkip: _finishOnboarding,
              ),
            ],
          ),
          // Floating page indicators at bottom center
          Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) => _buildIndicator(index)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(int index) {
    bool isActive = index == _currentPage;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 6.0,
      width: isActive ? 30.0 : 6.0,
      decoration: BoxDecoration(
        color: isActive
            ? MidnightNeonTheme.primaryContainer
            : MidnightNeonTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(3.0),
        boxShadow: isActive
            ? [
                BoxShadow(color: Colors.transparent, blurRadius: 0)
              ]
            : null,
      ),
    );
  }
}
