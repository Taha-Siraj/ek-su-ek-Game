import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/neon_button.dart';
import '../services/audio_manager.dart';
import 'reward_claimed_celebration_screen.dart';

class DailyChallengesPopupScreen extends StatefulWidget {
  const DailyChallengesPopupScreen({Key? key}) : super(key: key);

  @override
  State<DailyChallengesPopupScreen> createState() => _DailyChallengesPopupScreenState();
}

class _DailyChallengesPopupScreenState extends State<DailyChallengesPopupScreen> {
  bool _claimed = false;

  void _claimReward() {
    final audio = Provider.of<AudioManager>(context, listen: false);
    audio.playClick();
    audio.triggerHaptic();
    audio.addXp(250);
    audio.addCoins(50);

    setState(() {
      _claimed = true;
    });
    // Open reward celebration screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const RewardClaimedCelebrationScreen(
          trophies: 50,
          xp: 250,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.85),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: MidnightNeonTheme.containerMargin),
          child: GlassCard(
            padding: EdgeInsets.zero,
            child: Container(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header section
                  Container(
                    padding: const EdgeInsets.all(MidnightNeonTheme.spacingMd),
                    decoration: BoxDecoration(
                      color: MidnightNeonTheme.surfaceContainerLow.withOpacity(0.5),
                      border: const Border(bottom: BorderSide(color: MidnightNeonTheme.borderGlass)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Daily Challenges",
                              style: MidnightNeonTheme.headlineMd.copyWith(
                                color: MidnightNeonTheme.primaryContainer,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black.withOpacity(0.2)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.timer, color: MidnightNeonTheme.secondaryContainer, size: 12),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Resets in 14h 20m",
                                    style: MidnightNeonTheme.labelCaps.copyWith(
                                      color: MidnightNeonTheme.secondaryContainer,
                                      fontSize: 8,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: MidnightNeonTheme.textSecondary),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),

                  // Challenges Scroll Area
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(MidnightNeonTheme.spacingMd),
                      children: [
                        // Challenge 1: The Century Mark
                        _buildChallengeCard(
                          title: "The Century Mark",
                          desc: "Score 100 points in a single match.",
                          rewardVal: "50",
                          rewardType: "Trophy",
                          currentProgress: 100,
                          maxProgress: 100,
                          child: _claimed
                              ? Center(
                                  child: Text(
                                    "CLAIMED",
                                    style: MidnightNeonTheme.labelCaps.copyWith(color: MidnightNeonTheme.textSecondary),
                                  ),
                                )
                              : NeonButton.primary(
                                  text: "Claim Reward",
                                  icon: Icons.check_circle,
                                  onTap: _claimReward,
                                ),
                        ),
                        const SizedBox(height: 16),

                        // Challenge 2: Perfect Streak
                        _buildChallengeCard(
                          title: "Perfect Streak",
                          desc: "Win 3 matches in a row.",
                          rewardVal: "250",
                          rewardType: "XP",
                          currentProgress: 2,
                          maxProgress: 3,
                          child: InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black.withOpacity(0.15)),
                                borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusMedium),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Play Now",
                                    style: MidnightNeonTheme.buttonText.copyWith(color: MidnightNeonTheme.primaryContainer, fontSize: 14),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.play_arrow, color: MidnightNeonTheme.primaryContainer, size: 16),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Challenge 3: Quick Reflexes
                        _buildChallengeCard(
                          title: "Quick Reflexes",
                          desc: "Perform 50 perfect taps.",
                          rewardVal: "100",
                          rewardType: "XP",
                          currentProgress: 12,
                          maxProgress: 50,
                          child: InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: MidnightNeonTheme.borderGlass),
                                borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusMedium),
                                color: Colors.white.withOpacity(0.02),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Play Now",
                                    style: MidnightNeonTheme.buttonText.copyWith(color: Colors.white, fontSize: 14),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.play_arrow, color: Colors.white, size: 16),
                                ],
                              ),
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
        ),
      ),
    );
  }

  Widget _buildChallengeCard({
    required String title,
    required String desc,
    required String rewardVal,
    required String rewardType,
    required int currentProgress,
    required int maxProgress,
    required Widget child,
  }) {
    final double percent = currentProgress / maxProgress;
    final bool isCompleted = currentProgress == maxProgress;

    return Container(
      padding: const EdgeInsets.all(MidnightNeonTheme.spacingMd),
      decoration: BoxDecoration(
        color: MidnightNeonTheme.surfaceContainerLow.withOpacity(0.5),
        borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusLarge),
        border: Border.all(
          color: isCompleted ? MidnightNeonTheme.success.withOpacity(0.2) : MidnightNeonTheme.borderGlass,
          width: isCompleted ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: MidnightNeonTheme.headlineMd.copyWith(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      desc,
                      style: MidnightNeonTheme.bodyMd.copyWith(fontSize: 12, color: MidnightNeonTheme.textSecondary),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: MidnightNeonTheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: MidnightNeonTheme.borderGlass),
                ),
                child: Row(
                  children: [
                    Icon(
                      rewardType == "Trophy" ? Icons.emoji_events : Icons.bolt,
                      color: rewardType == "Trophy" ? MidnightNeonTheme.secondaryContainer : MidnightNeonTheme.accentPurple,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      rewardVal,
                      style: MidnightNeonTheme.displayDigit.copyWith(
                        fontSize: 12,
                        color: rewardType == "Trophy" ? MidnightNeonTheme.secondaryContainer : MidnightNeonTheme.accentPurple,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Progress",
                style: MidnightNeonTheme.labelCaps.copyWith(fontSize: 8, color: MidnightNeonTheme.textSecondary),
              ),
              Text(
                "$currentProgress/$maxProgress",
                style: MidnightNeonTheme.labelCaps.copyWith(
                  fontSize: 8,
                  color: isCompleted ? MidnightNeonTheme.success : MidnightNeonTheme.primaryContainer,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Progress bar
          Container(
            height: 6,
            width: double.infinity,
            decoration: BoxDecoration(
              color: MidnightNeonTheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percent,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isCompleted
                        ? [MidnightNeonTheme.success, MidnightNeonTheme.primaryContainer]
                        : [MidnightNeonTheme.accentPurple, MidnightNeonTheme.primaryContainer],
                  ),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
