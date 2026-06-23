import 'package:flutter/material.dart';
import '../theme.dart';

class SplashScreenStatic extends StatelessWidget {
  const SplashScreenStatic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(decoration: MidnightNeonTheme.radialBackground),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: MidnightNeonTheme.primaryContainer,
                      width: 3.0,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  "THE LAST NUMBER",
                  style: MidnightNeonTheme.displayLg.copyWith(
                    color: MidnightNeonTheme.primaryContainer,
                    fontSize: 32,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "THE 101 CHALLENGE",
                  style: MidnightNeonTheme.labelCaps.copyWith(
                    color: MidnightNeonTheme.textSecondary,
                    fontSize: 12,
                    letterSpacing: 2.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
