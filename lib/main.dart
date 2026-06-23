import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'screens/splash_screen.dart';
import 'theme.dart';
import 'services/audio_manager.dart';

import 'services/ad_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  try {
    await Firebase.initializeApp();
    print("Firebase initialized successfully");
  } catch (e) {
    print("Firebase not fully configured yet. Running in offline mode. Error: $e");
  }

  // Initialize AdMob
  try {
    await MobileAds.instance.initialize();
    print("Google Mobile Ads SDK initialized successfully");
    AdService.instance.loadInterstitialAd();
    AdService.instance.loadRewardedAd();
  } catch (e) {
    print("AdMob initialization skipped or failed: $e");
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => AudioManager()..startMusic(),
      child: const EkSauEkApp(),
    ),
  );
}

class EkSauEkApp extends StatelessWidget {
  const EkSauEkApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Last Number (101)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: MidnightNeonTheme.bgPrimary,
        primaryColor: MidnightNeonTheme.primary,
        colorScheme: const ColorScheme.dark(
          primary: MidnightNeonTheme.primary,
          primaryContainer: MidnightNeonTheme.primaryContainer,
          secondary: MidnightNeonTheme.secondary,
          secondaryContainer: MidnightNeonTheme.secondaryContainer,
          surface: MidnightNeonTheme.surface,
          error: MidnightNeonTheme.danger,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
