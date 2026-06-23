import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/neon_button.dart';

class VictoryScreenStatic extends StatelessWidget {
  final int score;
  final int coins;
  final int combo;

  const VictoryScreenStatic({
    Key? key,
    this.score = 101,
    this.coins = 250,
    this.combo = 500,
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: MidnightNeonTheme.containerMargin,
                        vertical: MidnightNeonTheme.spacingLg,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              const SizedBox(height: 16),
                              // Title
                              Text(
                                "PERFECT 101!",
                                style: MidnightNeonTheme.displayLg.copyWith(
                                  color: MidnightNeonTheme.primaryContainer,
                                  fontSize: 36,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 32),

                              // Trophy central frame
                              Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: MidnightNeonTheme.surfaceContainerLow,
                                  border: Border.all(
                                    color: MidnightNeonTheme.primaryContainer,
                                    width: 2.0,
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.emoji_events,
                                    color: MidnightNeonTheme.secondaryContainer,
                                    size: 72,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Bento details
                          GlassCard(
                            padding: const EdgeInsets.all(MidnightNeonTheme.spacingLg),
                            child: Column(
                              children: [
                                _buildBentoRow("Score", "$score", MidnightNeonTheme.primaryContainer),
                                const SizedBox(height: 12),
                                _buildBentoRow("Combo Bonus", "+$combo", MidnightNeonTheme.accentPurple),
                                const SizedBox(height: 12),
                                _buildBentoRow("Coins Earned", "$coins", MidnightNeonTheme.secondaryContainer),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Actions
                          Column(
                            children: [
                              NeonButton.primary(
                                text: "CONTINUE",
                                icon: Icons.done_all,
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: NeonButton.secondary(
                                      text: "SHARE",
                                      onTap: () {},
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: NeonButton.tertiary(
                                      text: "HOME",
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                ],
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

  Widget _buildBentoRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label.toUpperCase(),
            style: MidnightNeonTheme.labelCaps.copyWith(
              fontSize: 10,
              color: MidnightNeonTheme.textSecondary,
            ),
          ),
          Text(
            value,
            style: MidnightNeonTheme.displayDigit.copyWith(
              fontSize: 20,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
