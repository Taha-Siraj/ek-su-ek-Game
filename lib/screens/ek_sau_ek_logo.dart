import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/neon_button.dart';

class EkSauEkLogoScreen extends StatelessWidget {
  const EkSauEkLogoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(decoration: MidnightNeonTheme.radialBackground),
          // Flowing circles in background
          Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MidnightNeonTheme.primaryContainer.withOpacity(0.04),
              ),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(MidnightNeonTheme.containerMargin),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(height: 16),
                          // Huge Logo symbol
                          Center(
                            child: Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                color: MidnightNeonTheme.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusLarge),
                                border: Border.all(
                                  color: MidnightNeonTheme.primaryContainer,
                                  width: 2,
                                ),
                                boxShadow: const [
                                  BoxShadow(color: Colors.transparent, blurRadius: 0),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusLarge),
                                child: Image.asset(
                                  'assets/images/logo.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          Column(
                            children: [
                              Text(
                                "THE LAST NUMBER",
                                style: MidnightNeonTheme.displayLg.copyWith(
                                  fontSize: 36,
                                  color: MidnightNeonTheme.primaryContainer,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "OFFICIAL BRAND MARK",
                                style: MidnightNeonTheme.labelCaps.copyWith(
                                  color: MidnightNeonTheme.textSecondary,
                                  letterSpacing: 2.0,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          Column(
                            children: [
                              NeonButton.primary(
                                text: "RETURN TO HUD",
                                icon: Icons.done,
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
