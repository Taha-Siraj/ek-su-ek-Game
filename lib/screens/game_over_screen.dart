import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/neon_button.dart';

class GameOverScreen extends StatelessWidget {
  const GameOverScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: MidnightNeonTheme.radialBackground,
          ),
          // Crimson glow background element
          Positioned(
            top: MediaQuery.of(context).size.height * 0.25,
            left: 0,
            right: 0,
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
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
                              // Warning icon badge
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: MidnightNeonTheme.danger,
                                    width: 3.0,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(color: Colors.transparent, blurRadius: 0),
                                  ],
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.dangerous,
                                    color: MidnightNeonTheme.danger,
                                    size: 70,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                              // Defeat Title
                              Text(
                                "GAME OVER",
                                style: MidnightNeonTheme.displayLg.copyWith(
                                  color: MidnightNeonTheme.danger,
                                  fontSize: 40,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "TOTAL EXCEEDED 101 LIMIT",
                                style: MidnightNeonTheme.labelCaps.copyWith(
                                  color: MidnightNeonTheme.textSecondary,
                                  fontSize: 12,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Stats details card
                          GlassCard(
                            borderColor: MidnightNeonTheme.danger.withOpacity(0.2),
                            child: Column(
                              children: [
                                Text(
                                  "MATCH STATS",
                                  style: MidnightNeonTheme.labelCaps.copyWith(fontSize: 10),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildStatItem("105", "Final Score", MidnightNeonTheme.danger),
                                    _buildStatItem("Round 04", "Last Round", Colors.white),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Actions buttons
                          Column(
                            children: [
                              NeonButton.primary(
                                text: "TRY AGAIN",
                                icon: Icons.replay,
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              const SizedBox(height: 12),
                              NeonButton.secondary(
                                text: "RETURN TO HUD",
                                icon: Icons.home,
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

  Widget _buildStatItem(String val, String desc, Color color) {
    return Column(
      children: [
        Text(
          val,
          style: MidnightNeonTheme.displayDigit.copyWith(
            fontSize: 22,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          desc,
          style: MidnightNeonTheme.bodyMd.copyWith(
            fontSize: 11,
            color: MidnightNeonTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}
