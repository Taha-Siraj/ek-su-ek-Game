import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../services/audio_manager.dart';
import 'glass_card.dart';

class HudStats extends StatelessWidget {
  const HudStats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audio = Provider.of<AudioManager>(context);
    final int level = audio.playerLevel;
    final String username = audio.playerName;
    final int tokens = audio.coins;
    final IconData avatarIcon = audio.playerAvatar;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: MidnightNeonTheme.containerMargin,
        vertical: MidnightNeonTheme.spacingMd,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Player info block
          GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            borderRadius: 30, // Pill shaped HUD
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: MidnightNeonTheme.primaryContainer,
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: MidnightNeonTheme.surfaceContainerLow,
                    backgroundImage: audio.playerAvatarUrl != null ? NetworkImage(audio.playerAvatarUrl!) : null,
                    child: audio.playerAvatarUrl == null
                        ? Icon(avatarIcon, color: MidnightNeonTheme.primaryContainer, size: 16)
                        : null,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "LVL $level",
                      style: MidnightNeonTheme.labelCaps.copyWith(
                        color: MidnightNeonTheme.textSecondary,
                        fontSize: 10,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      username,
                      style: MidnightNeonTheme.buttonText.copyWith(
                        color: MidnightNeonTheme.primary,
                        fontSize: 14,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Tokens count block
          GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            borderRadius: 30,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.toll, // Cyber currency token icon
                  color: MidnightNeonTheme.primaryContainer,
                  size: 20,
                ),
                const SizedBox(width: 6),
                Text(
                  tokens.toString().replaceAllMapped(
                        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                        (Match m) => '${m[1]},',
                      ),
                  style: MidnightNeonTheme.displayDigit.copyWith(
                    fontSize: 18,
                    color: MidnightNeonTheme.secondary,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

