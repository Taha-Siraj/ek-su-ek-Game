import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/glass_card.dart';
import 'home_dashboard_static.dart';
import 'home_dashboard_animated.dart';
import 'onboarding_risk_screen.dart';
import 'onboarding_objective_screen.dart';
import 'onboarding_competition_screen.dart';
import 'splash_screen_static.dart';
import 'splash_screen_animated.dart';
import 'victory_screen_static.dart';
import 'victory_screen_animated.dart';
import 'game_over_screen_static.dart';
import 'game_over_screen_animated.dart';
import 'global_leaderboard_screen.dart';
import 'player_profile_screen.dart';
import 'shader_screen.dart';
import 'ek_sau_ek_logo.dart';
import 'login_guest_access_screen.dart';
import 'settings_config_screen.dart';
import 'gameplay_grid_screen.dart';
import 'reward_claimed_celebration_screen.dart';
import 'daily_challenges_popup_screen.dart';

class StitchCatalogScreen extends StatelessWidget {
  const StitchCatalogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> catalogItems = [
      {
        "title": "Login / Guest Access",
        "desc": "Initial guest access portal and connection buttons.",
        "icon": Icons.login,
        "screen": const LoginGuestAccessScreen(),
      },
      {
        "title": "Home Dashboard (Animated)",
        "desc": "Main active console view with matchmaking triggers.",
        "icon": Icons.dashboard_customize,
        "screen": const HomeDashboardAnimated(),
      },
      {
        "title": "Home Dashboard (Static)",
        "desc": "Main dashboard HUD without animations.",
        "icon": Icons.dashboard,
        "screen": const HomeDashboardStatic(),
      },
      {
        "title": "Gameplay Grid Screen",
        "desc": "Live interactive matching engine to reach exactly 101.",
        "icon": Icons.grid_on,
        "screen": const GameplayGridScreen(),
      },
      {
        "title": "Daily Challenges Popup",
        "desc": "Popup list tracking gold, XP rewards, and streaks.",
        "icon": Icons.timer_outlined,
        "screen": const DailyChallengesPopupScreen(),
      },
      {
        "title": "Reward Claimed Celebration",
        "desc": "Success banner display highlighting trophies and XP gained.",
        "icon": Icons.card_giftcard,
        "screen": const RewardClaimedCelebrationScreen(),
      },
      {
        "title": "Settings / Config",
        "desc": "Audio controls, volume sliders, and profile edits.",
        "icon": Icons.settings,
        "screen": const SettingsConfigScreen(),
      },
      {
        "title": "Global Leaderboard",
        "desc": "Ranks list showing competitor scores and items.",
        "icon": Icons.format_list_numbered,
        "screen": const GlobalLeaderboardScreen(),
      },
      {
        "title": "Player Profile",
        "desc": "User statistics cards and achievements badges.",
        "icon": Icons.account_circle,
        "screen": const PlayerProfileScreen(),
      },
      {
        "title": "Victory Screen (Animated)",
        "desc": "Winner layout with gold neon particle glows.",
        "icon": Icons.workspace_premium,
        "screen": const VictoryScreenAnimated(),
      },
      {
        "title": "Victory Screen (Static)",
        "desc": "Static success celebrate layout.",
        "icon": Icons.done,
        "screen": const VictoryScreenStatic(),
      },
      {
        "title": "Game Over Screen (Animated)",
        "desc": "Crimson pulsing overlay for bust round status.",
        "icon": Icons.error_outline,
        "screen": const GameOverScreenAnimated(),
      },
      {
        "title": "Game Over Screen (Static)",
        "desc": "Static failure layout.",
        "icon": Icons.dangerous_outlined,
        "screen": const GameOverScreenStatic(),
      },
      {
        "title": "Onboarding: The Risk",
        "desc": "First onboarding step outlining round risk constraints.",
        "icon": Icons.warning_amber,
        "screen": const OnboardingRiskScreen(),
      },
      {
        "title": "Onboarding: The Objective",
        "desc": "Second onboarding step explaining targets and wins.",
        "icon": Icons.track_changes,
        "screen": const OnboardingObjectiveScreen(),
      },
      {
        "title": "Onboarding: Competition",
        "desc": "Third onboarding step highlighting global rankings.",
        "icon": Icons.emoji_events,
        "screen": const OnboardingCompetitionScreen(),
      },
      {
        "title": "Splash Screen (Animated)",
        "desc": "Animated pulsing logo loading view.",
        "icon": Icons.flash_on,
        "screen": const SplashScreenAnimated(),
      },
      {
        "title": "Splash Screen (Static)",
        "desc": "Static loading brand view.",
        "icon": Icons.flash_off,
        "screen": const SplashScreenStatic(),
      },
      {
        "title": "Shader Screen",
        "desc": "CPU CustomPainter vector wave simulation.",
        "icon": Icons.waves,
        "screen": const ShaderScreen(),
      },
      {
        "title": "Ek Sau Ek Neon Logo",
        "desc": "Clean neon brand logo display asset.",
        "icon": Icons.grid_3x3,
        "screen": const EkSauEkLogoScreen(),
      },
    ];

    return Scaffold(
      body: Stack(
        children: [
          Container(decoration: MidnightNeonTheme.radialBackground),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(MidnightNeonTheme.containerMargin),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: MidnightNeonTheme.primaryContainer),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "STITCH SCREENS",
                            style: MidnightNeonTheme.headlineLg.copyWith(
                              color: MidnightNeonTheme.primaryContainer,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Explore all 20 visual screen designs & states",
                            style: MidnightNeonTheme.bodyMd.copyWith(
                              color: MidnightNeonTheme.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: MidnightNeonTheme.containerMargin,
                    ),
                    itemCount: catalogItems.length,
                    itemBuilder: (context, index) {
                      final item = catalogItems[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => item["screen"],
                              ),
                            );
                          },
                          child: GlassCard(
                            child: Row(
                              children: [
                                Icon(
                                  item["icon"],
                                  color: MidnightNeonTheme.primaryContainer,
                                  size: 28,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item["title"],
                                        style: MidnightNeonTheme.headlineMd.copyWith(
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        item["desc"],
                                        style: MidnightNeonTheme.bodyMd.copyWith(
                                          fontSize: 11,
                                          color: MidnightNeonTheme.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right,
                                  color: MidnightNeonTheme.textSecondary,
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
          ),
        ],
      ),
    );
  }
}
