import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/neon_button.dart';

class VictoryScreen extends StatelessWidget {
  const VictoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: MidnightNeonTheme.radialBackground,
          ),
          // Radial glow background element
          Positioned(
            top: MediaQuery.of(context).size.height * 0.25,
            left: 0,
            right: 0,
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MidnightNeonTheme.secondaryContainer.withOpacity(0.08),
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
                              // Victory star badge
                              Container(
                                width: 130,
                                height: 130,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: MidnightNeonTheme.secondaryContainer,
                                    width: 3.0,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(color: Colors.transparent, blurRadius: 0),
                                  ],
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.military_tech,
                                    color: MidnightNeonTheme.secondaryContainer,
                                    size: 75,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                              // Victory Title
                              Text(
                                "VICTORY",
                                style: MidnightNeonTheme.displayLg.copyWith(
                                  color: MidnightNeonTheme.secondaryContainer,
                                  fontSize: 40,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "YOU HIT THE TARGET!",
                                style: MidnightNeonTheme.labelCaps.copyWith(
                                  color: MidnightNeonTheme.textSecondary,
                                  fontSize: 12,
                                  letterSpacing: 2.0,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Reward details card
                          GlassCard(
                            borderColor: MidnightNeonTheme.secondaryContainer.withOpacity(0.2),
                            child: Column(
                              children: [
                                Text(
                                  "MATCH REWARDS",
                                  style: MidnightNeonTheme.labelCaps.copyWith(fontSize: 10),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildRewardItem(Icons.toll, "+100 Gold", MidnightNeonTheme.secondaryContainer),
                                    _buildRewardItem(Icons.bolt, "+250 XP", MidnightNeonTheme.accentPurple),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Return button
                          Column(
                            children: [
                              NeonButton.primary(
                                text: "CLAIM REWARDS",
                                icon: Icons.done_all,
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

  Widget _buildRewardItem(IconData icon, String text, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          text,
          style: MidnightNeonTheme.displayDigit.copyWith(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
