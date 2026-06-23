import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/audio_manager.dart';
import '../theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/neon_button.dart';
import '../widgets/hud_stats.dart';
import 'gameplay_grid_screen.dart';
import 'daily_challenges_popup_screen.dart';

class HomeDashboardAnimated extends StatefulWidget {
  const HomeDashboardAnimated({Key? key}) : super(key: key);

  @override
  State<HomeDashboardAnimated> createState() => _HomeDashboardAnimatedState();
}

class _HomeDashboardAnimatedState extends State<HomeDashboardAnimated> {
  bool _isSearchingMatch = false;

  void _startMatchmaking() {
    final audio = Provider.of<AudioManager>(context, listen: false);
    audio.playClick();
    audio.triggerHaptic();
    setState(() {
      _isSearchingMatch = true;
    });

    // Simulate match finding
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isSearchingMatch = false;
        });

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const GameplayGridScreen(isTrainingMode: false),
          ),
        );
      }
    });
  }

  void _startTraining() {
    final audio = Provider.of<AudioManager>(context, listen: false);
    audio.playClick();
    audio.triggerHaptic();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const GameplayGridScreen(isTrainingMode: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Gradient
        Container(
          decoration: MidnightNeonTheme.radialBackground,
        ),
        // Glow effect
        Positioned(
          top: 150,
          left: 50,
          right: 50,
          child: Container(
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
            ),
          ),
        ),
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const HudStats(),
              const SizedBox(height: 16),
              // Hero Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: MidnightNeonTheme.containerMargin),
                child: Column(
                  children: [
                    // Main Logo
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black.withOpacity(0.15),
                          width: 2.0,
                        ),
                        boxShadow: [
                          BoxShadow(color: Colors.transparent, blurRadius: 0),
                        ],
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
              // Play Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: MidnightNeonTheme.containerMargin),
                child: GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Provider.of<AudioManager>(context, listen: false).playClick();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const DailyChallengesPopupScreen(),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusMedium),
                        child: Row(
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
                                  style: MidnightNeonTheme.headlineMd.copyWith(
                                    fontSize: 18,
                                  ),
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
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Current Reward: +500 Gold Tokens. Keep adding numbers, stay under the limit.",
                        style: MidnightNeonTheme.bodyMd.copyWith(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),
                      NeonButton.primary(
                        text: _isSearchingMatch ? "SEARCHING MATCH..." : "START PLAYING",
                        icon: _isSearchingMatch ? Icons.loop : Icons.play_arrow,
                        onTap: _isSearchingMatch ? () {} : _startMatchmaking,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Sub cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: MidnightNeonTheme.containerMargin),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: _isSearchingMatch ? null : _startTraining,
                        borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusLarge),
                        child: GlassCard(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.flash_on, color: MidnightNeonTheme.accentPurple, size: 24),
                              const SizedBox(height: 12),
                              Text("TRAINING", style: MidnightNeonTheme.headlineMd.copyWith(fontSize: 14)),
                              const SizedBox(height: 4),
                              Text("Solo practice mode", style: MidnightNeonTheme.bodyLg.copyWith(fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          final audio = Provider.of<AudioManager>(context, listen: false);
                          audio.playClick();
                          audio.triggerHaptic();
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: MidnightNeonTheme.bgSecondary,
                                title: Text(
                                  "TOURNAMENT MODE",
                                  style: MidnightNeonTheme.headlineMd.copyWith(
                                    color: MidnightNeonTheme.primaryContainer,
                                    fontSize: 18,
                                  ),
                                ),
                                content: Text(
                                  "Live ranked multiplayer lobbies and seasonal tournaments are coming soon in Season 2!\n\nKeep practicing in Solo mode to build your skills.",
                                  style: MidnightNeonTheme.bodyMd.copyWith(color: Colors.white),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      audio.playClick();
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "UNDERSTOOD",
                                      style: MidnightNeonTheme.labelCaps.copyWith(color: MidnightNeonTheme.primaryContainer),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusLarge),
                        child: GlassCard(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.shield, color: MidnightNeonTheme.success, size: 24),
                              const SizedBox(height: 12),
                              Text("TOURNAMENT", style: MidnightNeonTheme.headlineMd.copyWith(fontSize: 14)),
                              const SizedBox(height: 4),
                              Text("Live ranked lobbies", style: MidnightNeonTheme.bodyLg.copyWith(fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
        // Searching overlay
        if (_isSearchingMatch)
          Container(
            color: Colors.black.withOpacity(0.85),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 80,
                    height: 80,
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        MidnightNeonTheme.primaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    "FINDING GRID MATCH...",
                    style: MidnightNeonTheme.headlineMd.copyWith(
                      color: MidnightNeonTheme.primaryContainer,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Connecting to server lobbies...",
                    style: MidnightNeonTheme.bodyMd.copyWith(
                      color: MidnightNeonTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
