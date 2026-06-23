import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../widgets/glass_card.dart';
import '../services/audio_manager.dart';
import '../widgets/player_profile_card_dialog.dart';

class GlobalLeaderboardScreen extends StatefulWidget {
  const GlobalLeaderboardScreen({Key? key}) : super(key: key);

  @override
  State<GlobalLeaderboardScreen> createState() => _GlobalLeaderboardScreenState();
}

class _GlobalLeaderboardScreenState extends State<GlobalLeaderboardScreen> {
  int _activeTab = 0; // 0: Global, 1: Friends, 2: Country

  final List<Map<String, dynamic>> _globalPlayers = [
    {
      "rank": "1st",
      "name": "ViperStrike_99",
      "subtitle": "PRO LEAGUE CHAMPION",
      "score": "1,420,500 XP",
      "color": Color(0xFFD4AF37), // Gold
    },
    {
      "rank": "2nd",
      "name": "NeonGhost",
      "subtitle": "ELITE TIER III",
      "score": "1,388,420 XP",
      "color": Color(0xFFE5E5E5), // Platinum
    },
    {
      "rank": "3rd",
      "name": "CyberRider",
      "subtitle": "ELITE TIER II",
      "score": "1,210,000 XP",
      "color": Color(0xFFCD7F32), // Bronze
    },
    {
      "rank": "04",
      "name": "PixelLord",
      "score": "982,500 XP",
    },
    {
      "rank": "05",
      "name": "QuantumX",
      "score": "975,000 XP",
    },
    {
      "rank": "06",
      "name": "ShadowWalker",
      "score": "968,200 XP",
    },
  ];

  final List<Map<String, dynamic>> _friendsPlayers = [
    {
      "rank": "1st",
      "name": "NeonGhost",
      "subtitle": "ELITE TIER III",
      "score": "1,388,420 XP",
      "color": Color(0xFFD4AF37),
    },
    {
      "rank": "2nd",
      "name": "BabarCoverDrive",
      "subtitle": "PRO LEAGUE CHAMPION",
      "score": "1,205,400 XP",
      "color": Color(0xFFE5E5E5),
    },
    {
      "rank": "3rd",
      "name": "CyberRider",
      "subtitle": "ELITE TIER II",
      "score": "1,210,000 XP",
      "color": Color(0xFFCD7F32),
    },
  ];

  final List<Map<String, dynamic>> _countryPlayers = [
    {
      "rank": "1st",
      "name": "BabarCoverDrive",
      "subtitle": "PRO LEAGUE CHAMPION",
      "score": "1,205,400 XP",
      "color": Color(0xFFD4AF37),
    },
    {
      "rank": "2nd",
      "name": "Afridi_BoomBoom",
      "subtitle": "ELITE TIER III",
      "score": "1,090,200 XP",
      "color": Color(0xFFE5E5E5),
    },
    {
      "rank": "3rd",
      "name": "LahoreRacer",
      "subtitle": "ELITE TIER II",
      "score": "980,500 XP",
      "color": Color(0xFFCD7F32),
    },
    {
      "rank": "04",
      "name": "KarachiKing",
      "score": "890,000 XP",
    },
    {
      "rank": "05",
      "name": "PeshawarGhost",
      "score": "845,300 XP",
    },
  ];

  String _formatNumber(int val) {
    return val.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  @override
  Widget build(BuildContext context) {
    final audio = Provider.of<AudioManager>(context);
    final String myName = audio.playerName;
    final IconData myAvatar = audio.playerAvatar;
    final int myLevel = audio.playerLevel;
    final int myXp = audio.xp;
    final double myProgress = audio.levelProgress;
    final int myXpToNext = audio.xpToNextLevel;

    final int globalRankNum = (10000 - myXp ~/ 10).clamp(1, 9999);
    final String globalRank = "#${_formatNumber(globalRankNum)}";

    return Scaffold(
      body: Stack(
        children: [
          Container(decoration: MidnightNeonTheme.radialBackground),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: MidnightNeonTheme.containerMargin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "RANKINGS",
                        style: MidnightNeonTheme.headlineLg.copyWith(
                          color: MidnightNeonTheme.primaryContainer,
                        ),
                      ),
                      const Icon(Icons.emoji_events_outlined, color: MidnightNeonTheme.primaryContainer),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Top User Standing Card
                  GlassCard(
                    padding: const EdgeInsets.all(MidnightNeonTheme.spacingMd),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                 CircleAvatar(
                                   backgroundColor: MidnightNeonTheme.primaryContainer.withOpacity(0.1),
                                   radius: 20,
                                   backgroundImage: audio.playerAvatarUrl != null ? NetworkImage(audio.playerAvatarUrl!) : null,
                                   child: audio.playerAvatarUrl == null
                                       ? Icon(myAvatar, color: MidnightNeonTheme.primaryContainer, size: 20)
                                       : null,
                                 ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      myName,
                                      style: MidnightNeonTheme.headlineMd.copyWith(fontSize: 16),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "LEVEL $myLevel",
                                      style: MidnightNeonTheme.labelCaps.copyWith(
                                        fontSize: 9,
                                        color: MidnightNeonTheme.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  globalRank,
                                  style: MidnightNeonTheme.displayDigit.copyWith(
                                    fontSize: 18,
                                    color: MidnightNeonTheme.primaryContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "GLOBAL RANK",
                                  style: MidnightNeonTheme.labelCaps.copyWith(
                                    fontSize: 8,
                                    color: MidnightNeonTheme.textSecondary.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${_formatNumber(myXp)} XP",
                              style: MidnightNeonTheme.labelCaps.copyWith(
                                fontSize: 9,
                                color: MidnightNeonTheme.textSecondary,
                              ),
                            ),
                            Text(
                              "${_formatNumber(myXpToNext)} XP TO LEVEL ${myLevel + 1}",
                              style: MidnightNeonTheme.labelCaps.copyWith(
                                fontSize: 9,
                                color: MidnightNeonTheme.primaryContainer,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Linear progress indicator
                        ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            value: myProgress,
                            backgroundColor: MidnightNeonTheme.surfaceContainerLow,
                            valueColor: const AlwaysStoppedAnimation<Color>(MidnightNeonTheme.primaryContainer),
                            minHeight: 4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Tab Buttons Selector
                  Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: MidnightNeonTheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusMedium),
                    ),
                    child: Row(
                      children: [
                        _buildTabButton(0, "GLOBAL"),
                        _buildTabButton(1, "FRIENDS"),
                        _buildTabButton(2, "COUNTRY"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Leaderboard scroll list
                  Expanded(
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: audio.fetchLeaderboard(
                        type: _activeTab == 0
                            ? "GLOBAL"
                            : _activeTab == 1
                                ? "FRIENDS"
                                : "COUNTRY",
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                MidnightNeonTheme.primaryContainer,
                              ),
                            ),
                          );
                        }
                        final list = snapshot.data ?? [];
                        if (list.isEmpty) {
                          return Center(
                            child: Text(
                              "NO ENTRIES FOUND",
                              style: MidnightNeonTheme.labelCaps.copyWith(
                                color: MidnightNeonTheme.textSecondary,
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            final player = list[index];
                            final isPodium = index < 3;
                            final Color podiumColor = player['color'] ?? MidnightNeonTheme.textSecondary;

                            return InkWell(
                              onTap: () {
                                audio.playClick();
                                audio.triggerHaptic();
                                if (player['uid'] != null) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => PlayerProfileCardDialog(
                                      targetUid: player['uid'],
                                      playerName: player['name'],
                                      avatarUrl: player['avatarUrl'],
                                      avatarCode: player['avatarCode'] ?? Icons.face_retouching_natural.codePoint,
                                      xp: player['xp'] ?? 0,
                                      totalGames: player['totalGames'] ?? 0,
                                      totalWins: player['totalWins'] ?? 0,
                                    ),
                                  );
                                }
                              },
                              borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusMedium),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: isPodium
                                      ? podiumColor.withOpacity(0.06)
                                      : MidnightNeonTheme.surfaceContainerLow.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusMedium),
                                  border: Border.all(
                                    color: isPodium
                                        ? podiumColor.withOpacity(0.25)
                                        : Colors.white.withOpacity(0.03),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        // Rank badge
                                        Container(
                                          width: 36,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            color: isPodium ? podiumColor.withOpacity(0.12) : Colors.transparent,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              player['rank'],
                                              style: MidnightNeonTheme.displayDigit.copyWith(
                                                fontSize: 12,
                                                color: podiumColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              player['name'],
                                              style: MidnightNeonTheme.headlineMd.copyWith(
                                                fontSize: 15,
                                                color: isPodium ? Colors.white : MidnightNeonTheme.textSecondary,
                                              ),
                                            ),
                                            if (player['subtitle'] != null) ...[
                                              const SizedBox(height: 2),
                                              Text(
                                                player['subtitle'],
                                                style: MidnightNeonTheme.labelCaps.copyWith(
                                                  fontSize: 8,
                                                  color: MidnightNeonTheme.textSecondary.withOpacity(0.5),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ],
                                    ),
                                    Text(
                                      player['score'],
                                      style: MidnightNeonTheme.displayDigit.copyWith(
                                        fontSize: 14,
                                        color: isPodium ? player['color'] : MidnightNeonTheme.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String label) {
    final bool isActive = _activeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          final audio = Provider.of<AudioManager>(context, listen: false);
          audio.playClick();
          audio.triggerHaptic();
          setState(() {
            _activeTab = index;
          });
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive ? MidnightNeonTheme.primaryContainer : Colors.transparent,
            borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusMedium),
          ),
          child: Text(
            label,
            style: MidnightNeonTheme.labelCaps.copyWith(
              fontSize: 10,
              color: isActive ? MidnightNeonTheme.bgPrimary : MidnightNeonTheme.textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}