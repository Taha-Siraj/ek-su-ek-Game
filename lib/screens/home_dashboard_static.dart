import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/neon_button.dart';
import '../widgets/hud_stats.dart';

class HomeDashboardStatic extends StatelessWidget {
  const HomeDashboardStatic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(decoration: MidnightNeonTheme.radialBackground),
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const HudStats(),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: MidnightNeonTheme.containerMargin),
                child: Column(
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black.withOpacity(0.15),
                          width: 2.0,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "THE LAST NUMBER",
                      style: MidnightNeonTheme.displayLg.copyWith(
                        fontSize: 26,
                        color: MidnightNeonTheme.primaryContainer,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "101 CHALLENGE DASHBOARD",
                      style: MidnightNeonTheme.labelCaps.copyWith(
                        color: MidnightNeonTheme.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: MidnightNeonTheme.containerMargin),
                child: GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "DAILY CHALLENGE",
                                style: MidnightNeonTheme.labelCaps.copyWith(
                                  color: MidnightNeonTheme.secondaryContainer,
                                  fontSize: 10,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Reach exactly 101",
                                style: MidnightNeonTheme.headlineMd.copyWith(fontSize: 18),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.emoji_events,
                              color: MidnightNeonTheme.secondaryContainer,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Current Reward: +500 Gold Tokens. Keep adding numbers, stay under the limit.",
                        style: MidnightNeonTheme.bodyMd.copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 24),
                      NeonButton.primary(
                        text: "PLAY GAME",
                        icon: Icons.play_arrow,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ],
    );
  }
}
