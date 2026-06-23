import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/neon_button.dart';

class OnboardingCompetitionScreen extends StatelessWidget {
  final VoidCallback? onNext;
  final VoidCallback? onSkip;

  const OnboardingCompetitionScreen({
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
                                "Global Grid",
                                style: MidnightNeonTheme.headlineLg.copyWith(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Face players worldwide in real-time. Rise through ranks to secure exclusive legendary skins.",
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
                                    text: "Get Started",
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.leaderboard_outlined, color: MidnightNeonTheme.primaryContainer, size: 20),
              const SizedBox(width: 8),
              Text(
                "GLOBAL RANKS",
                style: MidnightNeonTheme.labelCaps.copyWith(fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildRankRow("#1", "CyberRacer", "10,240 XP", MidnightNeonTheme.primaryContainer),
          _buildRankRow("#2", "Veloce_0", "9,890 XP", MidnightNeonTheme.secondary),
          _buildRankRow("#3", "You (GoldRacer)", "9,120 XP", Colors.white, isSelf: true),
        ],
      ),
    );
  }

  Widget _buildRankRow(String rank, String name, String xp, Color color, {bool isSelf = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isSelf ? Colors.white.withOpacity(0.04) : Colors.transparent,
        borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusSmall),
        border: isSelf ? Border.all(color: MidnightNeonTheme.primaryContainer.withOpacity(0.2)) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                rank,
                style: MidnightNeonTheme.displayDigit.copyWith(fontSize: 13, color: color),
              ),
              const SizedBox(width: 12),
              Text(
                name,
                style: MidnightNeonTheme.bodyMd.copyWith(
                  color: isSelf ? Colors.white : MidnightNeonTheme.textSecondary,
                  fontWeight: isSelf ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
          Text(
            xp,
            style: MidnightNeonTheme.displayDigit.copyWith(
              fontSize: 12,
              color: isSelf ? MidnightNeonTheme.primaryContainer : MidnightNeonTheme.textSecondary.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );