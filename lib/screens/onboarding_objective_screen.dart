import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/neon_button.dart';

class OnboardingObjectiveScreen extends StatelessWidget {
  final VoidCallback? onNext;
  final VoidCallback? onSkip;

  const OnboardingObjectiveScreen({
    Key? key,
    this.onNext,
    this.onSkip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(decoration: MidnightNeonTheme.radialBackground),
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
                      padding: const EdgeInsets.symmetric(horizontal: MidnightNeonTheme.containerMargin),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              const SizedBox(height: 24),
                              Text(
                                "THE LAST NUMBER",
                                style: MidnightNeonTheme.headlineMd.copyWith(
                                  color: MidnightNeonTheme.primary.withOpacity(0.6),
                                  fontSize: 16,
                                  letterSpacing: 2.0,
                                ),
                              ),
                              const SizedBox(height: 40),
                              _buildIllustration(),
                              const SizedBox(height: 40),
                              Text(
                                "Target 101",
                                style: MidnightNeonTheme.headlineLg.copyWith(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Match numbers strategically to get exactly 101. Earn massive multipliers on perfect wins.",
                                textAlign: TextAlign.center,
                                style: MidnightNeonTheme.bodyMd.copyWith(height: 1.5),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 140.0, top: 40.0),
                            child: Column(
                              children: [
                                if (onNext != null)
                                  NeonButton.primary(
                                    text: "Next",
                                    icon: Icons.arrow_forward,
                                    onTap: onNext!,
                                  ),
                                const SizedBox(height: 16),
                                if (onSkip != null)
                                  TextButton(
                                    onPressed: onSkip!,
                                    child: Text(
                                      "SKIP ONBOARDING",
                                      style: MidnightNeonTheme.labelCaps.copyWith(
                                        color: MidnightNeonTheme.textSecondary.withOpacity(0.6),
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
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

  Widget _buildIllustration() {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNumberCell("95", Colors.white),
              const Icon(Icons.add, color: Colors.white60, size: 24),
              _buildNumberCell("6", MidnightNeonTheme.primaryContainer),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 1,
            color: Colors.white10,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "TOTAL SUM",
                style: MidnightNeonTheme.labelCaps.copyWith(fontSize: 10),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: MidnightNeonTheme.primaryContainer.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  "101",
                  style: MidnightNeonTheme.displayDigit.copyWith(
                    fontSize: 20,
                    color: MidnightNeonTheme.primaryContainer,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "STATUS",
                style: MidnightNeonTheme.labelCaps.copyWith(fontSize: 10),
              ),
              Row(
                children: [
                  const Icon(Icons.check_circle_outline, color: MidnightNeonTheme.success, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    "PERFECT WIN",
                    style: MidnightNeonTheme.labelCaps.copyWith(
                      fontSize: 10,
                      color: MidnightNeonTheme.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumberCell(String val, Color color) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: MidnightNeonTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusMedium),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Center(
        child: Text(
          val,
          style: MidnightNeonTheme.displayDigit.copyWith(
            fontSize: 24,
            color: color,
          ),
        ),
      ),
    );
  }
}