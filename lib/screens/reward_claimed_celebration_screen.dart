import 'dart:math';
import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/neon_button.dart';

class RewardClaimedCelebrationScreen extends StatefulWidget {
  final int trophies;
  final int xp;

  const RewardClaimedCelebrationScreen({
    Key? key,
    this.trophies = 50,
    this.xp = 250,
  }) : super(key: key);

  @override
  State<RewardClaimedCelebrationScreen> createState() => _RewardClaimedCelebrationScreenState();
}

class _RewardClaimedCelebrationScreenState extends State<RewardClaimedCelebrationScreen> with SingleTickerProviderStateMixin {
  late AnimationController _rayController;
  final List<Point<double>> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _rayController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // Generate random floating particles
    for (int i = 0; i < 20; i++) {
      _particles.add(Point(_random.nextDouble(), _random.nextDouble()));
    }
  }

  @override
  void dispose() {
    _rayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
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
                              const SizedBox(height: 24),
                              // Celebration Header
                              Text(
                                "REWARD",
                                style: MidnightNeonTheme.displayLg.copyWith(
                                  fontSize: 48,
                                  fontStyle: FontStyle.italic,
                                  color: MidnightNeonTheme.primaryContainer,
                                ),
                              ),
                              Text(
                                "CLAIMED",
                                style: MidnightNeonTheme.displayLg.copyWith(
                                  fontSize: 48,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          
                          // Trophy circle
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32.0),
                            child: Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: MidnightNeonTheme.secondaryContainer,
                                  width: 2,
                                ),
                                color: MidnightNeonTheme.surfaceContainerLow,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.emoji_events,
                                  color: MidnightNeonTheme.secondaryContainer,
                                  size: 80,
                                ),
                              ),
                            ),
                          ),

                          // Reward Summary Cards
                          Column(
                            children: [
                              GlassCard(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: MidnightNeonTheme.secondaryContainer.withOpacity(0.15),
                                            border: Border.all(color: MidnightNeonTheme.secondaryContainer.withOpacity(0.5)),
                                          ),
                                          child: const Icon(Icons.emoji_events, color: MidnightNeonTheme.secondaryContainer, size: 20),
                                        ),
                                        const SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("RANK POINTS", style: MidnightNeonTheme.labelCaps.copyWith(fontSize: 8)),
                                            const SizedBox(height: 2),
                                            Text(
                                              "+${widget.trophies} Trophies",
                                              style: MidnightNeonTheme.headlineMd.copyWith(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Icon(Icons.arrow_upward, color: MidnightNeonTheme.success),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              GlassCard(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.black.withOpacity(0.15),
                                            border: Border.all(color: Colors.black.withOpacity(0.15)),
                                          ),
                                          child: const Icon(Icons.bolt, color: MidnightNeonTheme.primaryContainer, size: 20),
                                        ),
                                        const SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("EXPERIENCE", style: MidnightNeonTheme.labelCaps.copyWith(fontSize: 8)),
                                            const SizedBox(height: 2),
                                            Text(
                                              "+${widget.xp} XP",
                                              style: MidnightNeonTheme.headlineMd.copyWith(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    // Mini Progress bar
                                    Container(
                                      width: 80,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: MidnightNeonTheme.surfaceContainerLow,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: FractionallySizedBox(
                                        alignment: Alignment.centerLeft,
                                        widthFactor: 0.75,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: MidnightNeonTheme.primaryContainer,
                                            borderRadius: BorderRadius.circular(3),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          // Action Button
                          Column(
                            children: [
                              NeonButton.primary(
                                text: "CONTINUE",
                                icon: Icons.arrow_forward,
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
