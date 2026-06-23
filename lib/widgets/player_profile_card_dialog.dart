import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme.dart';
import '../services/audio_manager.dart';
import 'glass_card.dart';

class PlayerProfileCardDialog extends StatelessWidget {
  final String targetUid;
  final String playerName;
  final String? avatarUrl;
  final int avatarCode;
  final int xp;
  final int totalGames;
  final int totalWins;

  const PlayerProfileCardDialog({
    Key? key,
    required this.targetUid,
    required this.playerName,
    required this.avatarUrl,
    required this.avatarCode,
    required this.xp,
    required this.totalGames,
    required this.totalWins,
  }) : super(key: key);

  String _formatNumber(int val) {
    return val.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  double get winRate {
    if (totalGames == 0) return 0.0;
    return (totalWins / totalGames) * 100.0;
  }

  int get playerLevel {
    return 1 + (xp ~/ 8000);
  }

  @override
  Widget build(BuildContext context) {
    final audio = Provider.of<AudioManager>(context);
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    final bool isMe = currentUid == targetUid;
    final IconData avatarIcon = IconData(avatarCode, fontFamily: 'MaterialIcons');

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: GlassCard(
        padding: const EdgeInsets.all(MidnightNeonTheme.spacingLg),
        borderColor: MidnightNeonTheme.primaryContainer.withOpacity(0.2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close Button Header
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: MidnightNeonTheme.textSecondary),
                  onPressed: () {
                    audio.playClick();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),

            // Profile Picture & Level Badge
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: MidnightNeonTheme.primaryContainer,
                      width: 2.5,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundColor: MidnightNeonTheme.surfaceContainerLow,
                    backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                    child: avatarUrl == null
                        ? Icon(
                            avatarIcon,
                            color: MidnightNeonTheme.primaryContainer,
                            size: 48,
                          )
                        : null,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: MidnightNeonTheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "LEVEL $playerLevel",
                      style: MidnightNeonTheme.labelCaps.copyWith(
                        color: MidnightNeonTheme.bgPrimary,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Username
            Text(
              playerName,
              style: MidnightNeonTheme.headlineMd.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 4),
            Text(
              "PLAYER DOSSIER",
              style: MidnightNeonTheme.labelCaps.copyWith(
                color: MidnightNeonTheme.textSecondary.withOpacity(0.6),
                fontSize: 9,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 24),

            // Stats grid
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem("GAMES", _formatNumber(totalGames)),
                Container(width: 1, height: 32, color: MidnightNeonTheme.borderGlass),
                _buildStatItem("101 WINS", _formatNumber(totalWins)),
                Container(width: 1, height: 32, color: MidnightNeonTheme.borderGlass),
                _buildStatItem("WIN RATE", "${winRate.toStringAsFixed(1)}%"),
              ],
            ),
            const SizedBox(height: 32),

            // Action Buttons
            if (!isMe && currentUid != null)
              StreamBuilder<DocumentSnapshot>(
                stream: audio.streamFriendStatus(targetUid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(MidnightNeonTheme.primaryContainer),
                    );
                  }

                  String status = 'none';
                  if (snapshot.hasData && snapshot.data!.exists) {
                    final data = snapshot.data!.data() as Map<String, dynamic>?;
                    status = data?['status'] ?? 'none';
                  }

                  if (status == 'none') {
                    // Send Request button
                    return ElevatedButton.icon(
                      onPressed: () async {
                        audio.playClick();
                        audio.triggerHaptic();
                        await audio.sendFriendRequest(
                          targetUid: targetUid,
                          targetName: playerName,
                          targetAvatarUrl: avatarUrl,
                          targetAvatarCode: avatarCode,
                        );
                      },
                      icon: const Icon(Icons.person_add, color: MidnightNeonTheme.bgPrimary, size: 18),
                      label: Text(
                        "ADD FRIEND",
                        style: MidnightNeonTheme.labelCaps.copyWith(
                          color: MidnightNeonTheme.bgPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MidnightNeonTheme.primaryContainer,
                        minimumSize: const Size(double.infinity, 44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusMedium),
                        ),
                      ),
                    );
                  } else if (status == 'requested') {
                    // Cancel request / Request sent
                    return OutlinedButton.icon(
                      onPressed: () async {
                        audio.playClick();
                        audio.triggerHaptic();
                        await audio.declineFriendRequest(targetUid);
                      },
                      icon: const Icon(Icons.close, color: MidnightNeonTheme.danger, size: 18),
                      label: Text(
                        "CANCEL FRIEND REQUEST",
                        style: MidnightNeonTheme.labelCaps.copyWith(
                          color: MidnightNeonTheme.danger,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: MidnightNeonTheme.danger),
                        minimumSize: const Size(double.infinity, 44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusMedium),
                        ),
                      ),
                    );
                  } else if (status == 'received') {
                    // Accept or decline options
                    return Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              audio.playClick();
                              audio.triggerHaptic();
                              await audio.acceptFriendRequest(
                                targetUid: targetUid,
                                targetName: playerName,
                                targetAvatarUrl: avatarUrl,
                                targetAvatarCode: avatarCode,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MidnightNeonTheme.primaryContainer,
                              minimumSize: const Size(0, 44),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusMedium)),
                            ),
                            child: Text(
                              "ACCEPT",
                              style: MidnightNeonTheme.labelCaps.copyWith(
                                color: MidnightNeonTheme.bgPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              audio.playClick();
                              audio.triggerHaptic();
                              await audio.declineFriendRequest(targetUid);
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: MidnightNeonTheme.danger),
                              minimumSize: const Size(0, 44),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusMedium)),
                            ),
                            child: Text(
                              "DECLINE",
                              style: MidnightNeonTheme.labelCaps.copyWith(
                                color: MidnightNeonTheme.danger,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    // Already friends - Unfriend option
                    return OutlinedButton.icon(
                      onPressed: () async {
                        audio.playClick();
                        audio.triggerHaptic();
                        // Confirm Dialog for Unfriend
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: MidnightNeonTheme.bgSecondary,
                            title: Text(
                              "UNFRIEND $playerName?",
                              style: MidnightNeonTheme.headlineMd.copyWith(color: MidnightNeonTheme.danger, fontSize: 16),
                            ),
                            content: Text(
                              "Are you sure you want to remove $playerName from your friends list?",
                              style: MidnightNeonTheme.bodyMd.copyWith(color: Colors.white, fontSize: 13),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  "CANCEL",
                                  style: MidnightNeonTheme.labelCaps.copyWith(color: MidnightNeonTheme.textSecondary),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await audio.unfriend(targetUid);
                                },
                                child: Text(
                                  "UNFRIEND",
                                  style: MidnightNeonTheme.labelCaps.copyWith(color: MidnightNeonTheme.danger),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.person_remove, color: MidnightNeonTheme.danger, size: 18),
                      label: Text(
                        "REMOVE FRIEND",
                        style: MidnightNeonTheme.labelCaps.copyWith(
                          color: MidnightNeonTheme.danger,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: MidnightNeonTheme.danger),
                        minimumSize: const Size(double.infinity, 44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusMedium),
                        ),
                      ),
                    );
                  }
                },
              ),
            if (isMe)
              Text(
                "THIS IS YOUR PUBLIC DOSSIER",
                style: MidnightNeonTheme.labelCaps.copyWith(
                  color: MidnightNeonTheme.primaryContainer,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String val) {
    return Column(
      children: [
        Text(
          label,
          style: MidnightNeonTheme.labelCaps.copyWith(
            fontSize: 8,
            color: MidnightNeonTheme.textSecondary.withOpacity(0.5),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          val,
          style: MidnightNeonTheme.displayDigit.copyWith(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
