import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../widgets/glass_card.dart';
import '../services/audio_manager.dart';
import '../services/ad_service.dart';
import 'settings_config_screen.dart';

class PlayerProfileScreen extends StatelessWidget {
  const PlayerProfileScreen({Key? key}) : super(key: key);

  void _showAchievementDetails(
    BuildContext context,
    String title,
    String description,
    bool unlocked,
    AudioManager audio,
  ) {
    audio.playClick();
    audio.triggerHaptic();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: MidnightNeonTheme.bgSecondary,
          title: Row(
            children: [
              Icon(
                unlocked ? Icons.check_circle : Icons.lock,
                color: unlocked ? MidnightNeonTheme.success : MidnightNeonTheme.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                title.toUpperCase(),
                style: MidnightNeonTheme.headlineMd.copyWith(
                  color: MidnightNeonTheme.primaryContainer,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Text(
            unlocked
                ? "You have unlocked this achievement!\n\nRequirement: $description"
                : "This achievement is locked.\n\nRequirement: $description",
            style: MidnightNeonTheme.bodyMd.copyWith(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                audio.playClick();
                audio.toggleAchievement(title);
                Navigator.of(context).pop();
              },
              child: Text(
                "DEBUG: TOGGLE",
                style: MidnightNeonTheme.labelCaps.copyWith(
                  color: MidnightNeonTheme.danger.withOpacity(0.6),
                  fontSize: 10,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                audio.playClick();
                Navigator.of(context).pop();
              },
              child: Text(
                "CLOSE",
                style: MidnightNeonTheme.labelCaps.copyWith(
                  color: MidnightNeonTheme.primaryContainer,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatNumber(int val) {
    return val.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  String _getSeasonRank(int xp) {
    if (xp < 10000) return "Bronze I";
    if (xp < 25000) return "Bronze II";
    if (xp < 45000) return "Silver I";
    if (xp < 65000) return "Silver II";
    if (xp < 80000) return "Gold I";
    if (xp < 95000) return "Gold II";
    return "Elite IV";
  }

  @override
  Widget build(BuildContext context) {
    final audio = Provider.of<AudioManager>(context);
    final String name = audio.playerName;
    final IconData avatar = audio.playerAvatar;
    final int level = audio.playerLevel;
    final double progress = audio.levelProgress;
    final int xp = audio.xp;
    final int totalGames = audio.totalGames;
    final int totalWins = audio.totalWins;
    final double winRate = audio.winRate;

    // Dynamic stats calculations
    final String winRateStr = "${winRate.toStringAsFixed(1)}%";
    final String reactionTime = "${(240 - (level * 3)).clamp(100, 350)}ms";
    final String seasonRank = _getSeasonRank(xp);
    final int globalStandingNum = (10000 - xp ~/ 10).clamp(1, 9999);
    final String globalStanding = "#${_formatNumber(globalStandingNum)}";

    final achievements = [
      {
        "name": "First 101",
        "description": "Reach exactly 101 points in a match.",
        "icon": Icons.military_tech,
      },
      {
        "name": "Speed Demon",
        "description": "Win a match in 10 seconds or less.",
        "icon": Icons.speed,
      },
      {
        "name": "Perfect 10",
        "description": "Achieve 10 total victories.",
        "icon": Icons.star,
      },
      {
        "name": "Centurion",
        "description": "Achieve 100 total victories.",
        "icon": Icons.shield,
      },
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(decoration: MidnightNeonTheme.radialBackground),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: MidnightNeonTheme.containerMargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // Header Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: MidnightNeonTheme.primaryContainer, width: 1.5),
                              ),
                              child: CircleAvatar(
                                backgroundColor: MidnightNeonTheme.surfaceContainerLow,
                                child: Icon(avatar, color: MidnightNeonTheme.primaryContainer, size: 20),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "MY PROFILE",
                              style: MidnightNeonTheme.headlineMd.copyWith(
                                fontSize: 20,
                                color: MidnightNeonTheme.primaryContainer,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings, color: MidnightNeonTheme.primaryContainer),
                          onPressed: () {
                            audio.playClick();
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const SettingsConfigScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Avatar & Level Indicators
                    Center(
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // Avatar circle
                              Container(
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: MidnightNeonTheme.primaryContainer,
                                    width: 3.0,
                                  ),
                                ),
                                child: CircleAvatar(
                                  backgroundColor: MidnightNeonTheme.surfaceContainerLow,
                                  child: Icon(
                                    avatar,
                                    color: MidnightNeonTheme.primaryContainer,
                                    size: 64,
                                  ),
                                ),
                              ),
                              // Level overlay badge
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: MidnightNeonTheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "LEVEL $level",
                                    style: MidnightNeonTheme.labelCaps.copyWith(
                                      color: MidnightNeonTheme.bgPrimary,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Username & Verified Badge
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                name,
                                style: MidnightNeonTheme.headlineLg.copyWith(fontSize: 24),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.verified,
                                color: MidnightNeonTheme.secondaryContainer,
                                size: 18,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "PRO LEAGUE MEMBER",
                            style: MidnightNeonTheme.labelCaps.copyWith(
                              color: MidnightNeonTheme.primaryContainer,
                              fontSize: 10,
                              letterSpacing: 2.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Level Progression Bar
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "XP PROGRESS",
                              style: MidnightNeonTheme.labelCaps.copyWith(
                                fontSize: 9,
                                color: MidnightNeonTheme.textSecondary.withOpacity(0.6),
                              ),
                            ),
                            Text(
                              "${(progress * 100).toInt()}% TO LEVEL ${level + 1}",
                              style: MidnightNeonTheme.labelCaps.copyWith(
                                fontSize: 9,
                                color: MidnightNeonTheme.primaryContainer,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 8,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: MidnightNeonTheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: MidnightNeonTheme.borderGlass),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: progress,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [MidnightNeonTheme.accentPurple, MidnightNeonTheme.primaryContainer],
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Bento Statistics Grid
                    _buildSectionTitle("STATISTICS"),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.4,
                      children: [
                        _buildStatCard(Icons.sports_esports, "TOTAL GAMES", _formatNumber(totalGames), false),
                        _buildStatCard(Icons.emoji_events, "TOTAL 101s", _formatNumber(totalWins), true),
                        _buildStatCard(Icons.trending_up, "WIN RATE", winRateStr, false),
                        _buildStatCard(Icons.bolt, "AVG REACTION", reactionTime, false),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Achievements Section
                    _buildSectionTitle("ACHIEVEMENTS"),
                    SizedBox(
                      height: 140,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: achievements.length,
                        itemBuilder: (context, index) {
                          final ach = achievements[index];
                          final bool isUnlocked = audio.isAchievementUnlocked(ach['name'] as String);
                          return GestureDetector(
                            onTap: () => _showAchievementDetails(
                              context,
                              ach['name'] as String,
                              ach['description'] as String,
                              isUnlocked,
                              audio,
                            ),
                            child: _buildAchievementCard(
                              ach['icon'] as IconData,
                              ach['name'] as String,
                              isUnlocked ? "UNLOCKED" : "LOCKED",
                              isUnlocked,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Season Summary
                    GlassCard(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Season Rank", style: MidnightNeonTheme.labelCaps.copyWith(fontSize: 8)),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: MidnightNeonTheme.secondaryContainer.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Icon(Icons.workspace_premium, color: MidnightNeonTheme.secondaryContainer, size: 16),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      seasonRank,
                                      style: MidnightNeonTheme.headlineMd.copyWith(fontSize: 16, color: MidnightNeonTheme.secondary),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(width: 1, height: 40, color: MidnightNeonTheme.borderGlass),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Global Standing", style: MidnightNeonTheme.labelCaps.copyWith(fontSize: 8)),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.public, color: MidnightNeonTheme.primaryContainer, size: 18),
                                      const SizedBox(width: 8),
                                      Text(
                                        globalStanding,
                                        style: MidnightNeonTheme.headlineMd.copyWith(fontSize: 16, color: MidnightNeonTheme.primaryContainer),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Watch Ad for Coins Card
                    GlassCard(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      borderColor: MidnightNeonTheme.primaryContainer.withOpacity(0.2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: MidnightNeonTheme.primaryContainer.withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.play_circle_fill,
                                  color: MidnightNeonTheme.primaryContainer,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "FREE COINS",
                                    style: MidnightNeonTheme.labelCaps.copyWith(
                                      fontSize: 10,
                                      color: MidnightNeonTheme.primaryContainer,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "Watch Ad to get +100 Coins",
                                    style: MidnightNeonTheme.bodyMd.copyWith(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              audio.playClick();
                              audio.triggerHaptic();
                              AdService.instance.showRewardedAd(
                                context,
                                onRewardEarned: (amount) {
                                  audio.addCoins(100);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: MidnightNeonTheme.success,
                                      content: Text(
                                        "Congratulations! You earned 100 Coins!",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MidnightNeonTheme.primaryContainer,
                              foregroundColor: MidnightNeonTheme.bgPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusMedium),
                              ),
                            ),
                            child: Text(
                              "WATCH AD",
                              style: MidnightNeonTheme.labelCaps.copyWith(
                                fontSize: 10,
                                color: MidnightNeonTheme.bgPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: MidnightNeonTheme.labelCaps.copyWith(
          fontSize: 10,
          color: MidnightNeonTheme.textSecondary,
        ),
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String label, String value, bool highlight) {
    return GlassCard(
      padding: const EdgeInsets.all(MidnightNeonTheme.spacingMd),
      borderColor: highlight ? Colors.black.withOpacity(0.2) : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: highlight ? MidnightNeonTheme.secondaryContainer : MidnightNeonTheme.primaryContainer.withOpacity(0.6),
            size: 20,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: MidnightNeonTheme.labelCaps.copyWith(
              fontSize: 8,
              color: MidnightNeonTheme.textSecondary.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: MidnightNeonTheme.displayDigit.copyWith(
              fontSize: 18,
              color: highlight ? MidnightNeonTheme.secondaryContainer : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(IconData icon, String title, String status, bool unlocked) {
    return Opacity(
      opacity: unlocked ? 1.0 : 0.4,
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 16),
        child: GlassCard(
          padding: const EdgeInsets.all(MidnightNeonTheme.spacingSm),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: unlocked ? MidnightNeonTheme.primaryContainer : MidnightNeonTheme.textSecondary,
                        width: 1.5,
                      ),
                      color: MidnightNeonTheme.surfaceContainerLow,
                    ),
                    child: Center(
                      child: Icon(
                        icon,
                        color: unlocked ? MidnightNeonTheme.primaryContainer : MidnightNeonTheme.textSecondary,
                        size: 24,
                      ),
                    ),
                  ),
                  if (unlocked)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: MidnightNeonTheme.success,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check, color: Colors.white, size: 8),
                      ),
                    )
                  else
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.black45,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.lock, color: Colors.white, size: 8),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: MidnightNeonTheme.buttonText.copyWith(color: Colors.white, fontSize: 11),
              ),
              const SizedBox(height: 2),
              Text(
                status,
                style: MidnightNeonTheme.labelCaps.copyWith(
                  fontSize: 7,
                  color: unlocked ? MidnightNeonTheme.primaryContainer : MidnightNeonTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
