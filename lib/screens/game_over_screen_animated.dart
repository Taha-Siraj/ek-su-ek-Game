import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/audio_manager.dart';
import '../theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/neon_button.dart';

class GameOverScreenAnimated extends StatefulWidget {
  final int score;
  final int bestScore;

  const GameOverScreenAnimated({
    Key? key,
    this.score = 105,
    this.bestScore = 98,
  }) : super(key: key);

  @override
  State<GameOverScreenAnimated> createState() => _GameOverScreenAnimatedState();
}

class _GameOverScreenAnimatedState extends State<GameOverScreenAnimated> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient (Danger-themed deep charcoal, flat and premium)
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  Color(0xFF1E1515), // Very subtle warm dark tint
                  MidnightNeonTheme.bgPrimary,
                ],
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
                          // Header Section
                          Column(
                            children: [
                              const SizedBox(height: 16),
                              Text(
                                "TOO FAR!",
                                style: MidnightNeonTheme.displayLg.copyWith(
                                  color: MidnightNeonTheme.danger,
                                  fontSize: 48,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "LIMIT EXCEEDED",
                                style: MidnightNeonTheme.labelCaps.copyWith(
                                  color: MidnightNeonTheme.danger.withOpacity(0.8),
                                  fontSize: 10,
                                  letterSpacing: 4.0,
                                ),
                              ),
                            ],
                          ),

                          // Score Section
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24.0),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Text(
                                  "${widget.score}",
                                  style: MidnightNeonTheme.displayDigit.copyWith(
                                    fontSize: 110,
                                    color: MidnightNeonTheme.danger,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                // Decorative line slash
                                Transform.rotate(
                                  angle: -0.15,
                                  child: Container(
                                    height: 6,
                                    width: 220,
                                    color: MidnightNeonTheme.danger,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Stats Glass Card
                          GlassCard(
                            padding: const EdgeInsets.all(MidnightNeonTheme.spacingLg),
                            borderColor: MidnightNeonTheme.danger.withOpacity(0.2),
                            child: Column(
                              children: [
                                Text(
                                  "You flew too close to the sun. Better luck next time.",
                                  textAlign: TextAlign.center,
                                  style: MidnightNeonTheme.bodyMd.copyWith(
                                    color: MidnightNeonTheme.textSecondary,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildBentoItem(
                                        "FINAL SCORE",
                                        "${widget.score}",
                                        MidnightNeonTheme.danger,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildBentoItem(
                                        "BEST SCORE",
                                        "${widget.bestScore}",
                                        MidnightNeonTheme.primaryContainer,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Actions
                          Column(
                            children: [
                              NeonButton.primary(
                                text: "TRY AGAIN",
                                icon: Icons.refresh,
                                onTap: () {
                                  Provider.of<AudioManager>(context, listen: false).playClick();
                                  Navigator.of(context).pop();
                                },
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: NeonButton.secondary(
                                      text: "HOME",
                                      icon: Icons.home,
                                      onTap: () {
                                        Provider.of<AudioManager>(context, listen: false).playClick();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: NeonButton.tertiary(
                                      text: "RANK",
                                      icon: Icons.leaderboard,
                                      onTap: () {
                                        Provider.of<AudioManager>(context, listen: false).playClick();
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

  Widget _buildBentoItem(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: MidnightNeonTheme.surfaceContainerLow.withOpacity(0.5),
        border: Border.all(color: MidnightNeonTheme.borderGlass),
        borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusMedium),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: MidnightNeonTheme.labelCaps.copyWith(fontSize: 8, color: MidnightNeonTheme.textSecondary),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: MidnightNeonTheme.displayDigit.copyWith(fontSize: 24, color: color),
          ),
        ],
      ),
    );
  }
}
