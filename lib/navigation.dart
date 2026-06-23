import 'package:flutter/material.dart';
import 'theme.dart';
import 'widgets/glass_card.dart';
import 'screens/home_dashboard_animated.dart';
import 'screens/global_leaderboard_screen.dart';
import 'screens/player_profile_screen.dart';
import 'screens/settings_config_screen.dart';

import 'package:provider/provider.dart';
import 'services/audio_manager.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'services/ad_service.dart';

class AppNavigationWrapper extends StatefulWidget {
  const AppNavigationWrapper({Key? key}) : super(key: key);

  @override
  State<AppNavigationWrapper> createState() => _AppNavigationWrapperState();
}

class _AppNavigationWrapperState extends State<AppNavigationWrapper> {
  int _currentIndex = 0;
  BannerAd? _bannerAd;

  final List<Widget> _screens = const [
    HomeDashboardAnimated(),
    GlobalLeaderboardScreen(),
    PlayerProfileScreen(),
    SettingsConfigScreen(),
  ];

  @override
  void initState() {
    super.initState();
    try {
      _bannerAd = AdService.instance.createBannerAd();
    } catch (e) {
      print("Error creating banner ad: $e");
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Allow body to expand behind glass navbar
      body: _screens[_currentIndex],
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_bannerAd != null)
              Container(
                alignment: Alignment.center,
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: MidnightNeonTheme.containerMargin,
                vertical: 12,
              ),
              child: GlassCard(
                padding: const EdgeInsets.symmetric(vertical: 8),
                borderRadius: 30, // Fully rounded glass container
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(index: 0, icon: Icons.home, label: "Home"),
                    _buildNavItem(index: 1, icon: Icons.leaderboard, label: "Rank"),
                    _buildNavItem(index: 2, icon: Icons.person, label: "Profile"),
                    _buildNavItem(index: 3, icon: Icons.settings, label: "Config"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final bool isSelected = _currentIndex == index;
    final Color color = isSelected
        ? MidnightNeonTheme.primaryContainer
        : MidnightNeonTheme.textSecondary;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (_currentIndex != index) {
          final audio = Provider.of<AudioManager>(context, listen: false);
          audio.playClick();
          audio.triggerHaptic();
          setState(() {
            _currentIndex = index;
          });
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: MidnightNeonTheme.labelCaps.copyWith(
              color: color,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
