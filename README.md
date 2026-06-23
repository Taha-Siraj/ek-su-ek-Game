# The Last Number (101)

[![Flutter](https://img.shields.io/badge/Flutter-v3.0+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Auth%20%26%20Firestore-FFCA28?logo=firebase&logoColor=white)](https://firebase.google.com)
[![AdMob](https://img.shields.io/badge/Google--AdMob-Monetization-34A853?logo=google-admob&logoColor=white)](https://admob.google.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**The Last Number (101)** is a premium, flat-designed cyberpunk mathematical strategy game built using Flutter. The game challenges players to select and match grid tiles to sum up to exactly **101** without exceeding it. Features include dynamic audio settings, responsive glassmorphic UI layout, anonymous/email Firebase authentication, dynamic global leaderboards, and AdMob ads monetization.

---

## 🎮 Features

* **Target 101 Gameplay**: A cyberpunk math challenge grid where strategic precision is key. Keep your sum at or below 101 to win; going over results in an instant Bust.
* **Double Play Modes**: Complete offline accessibility with automatic offline caching and cloud database synchronization once connectivity is restored.
* **Firebase Authentication (A to Z)**:
  * **Guest Mode**: Anonymous login for instant, frictionless gameplay.
  * **Email Auth**: Log in or register with email and password.
  * **Account Linking**: Convert a guest/anonymous account to a permanent email account to avoid losing stats and coins.
* **Dynamic Global Leaderboards**: Query, sort, and display the top 10 players globally in real-time, directly from Cloud Firestore.
* **Google AdMob Monetization**:
  * **Banner Ads**: Sticky ads at the bottom of navigation screen wrappers.
  * **Interstitial Ads**: Full-screen ads shown upon game completion (victory or defeat).
  * **Rewarded Ads**: Reward videos on the Profile tab that grant users **+100 Coins**.
* **Premium Audio Engine**: Live background loop music and spatial sound effects (win, lose, click) with customizable master, music, and SFX volume sliders.
* **Adaptive Cyberpunk Theme**: Styled with flat gold and charcoal palettes, customizable avatar badges, and glassmorphic micro-animations.

---

## 🏗️ Technical Stack & Architecture

* **Framework**: Flutter & Dart (Compatible with SDK `>=3.0.0 <4.0.0`)
* **State Management**: Provider architecture for clean data bindings.
* **Database & Auth**: Google Firebase Auth & Cloud Firestore.
* **Monetization**: Google Mobile Ads (AdMob) SDK.
* **Audio System**: Audioplayers package.

### Folder Structure
```text
lib/
├── main.dart               # SDK Initializations & Entry Point
├── navigation.dart         # Bottom Navigation Tab Controller & Banner Ad Widget
├── theme.dart              # Gold/Charcoal Color Swatches & Typography
├── services/
│   ├── ad_service.dart     # AdMob Lifecycle Manager (Banner, Interstitial, Rewarded)
│   └── audio_manager.dart  # Sound Effects, Haptics & Firebase Backend Sync
├── widgets/
│   ├── glass_card.dart     # Custom Glassmorphic Bento Cards
│   ├── hud_stats.dart      # Real-time player profile HUD header
│   ├── neon_button.dart    # Cyberpunk style buttons
│   └── neon_progress_bar.dart # Level progress indicators
└── screens/                # Onboarding, gameplay, leaderboard, and configuration views
```

---

## 🚀 Setup & Installation (A to Z)

### 1. Prerequisites
* Install [Flutter SDK](https://docs.flutter.dev/get-started/install) on your machine.
* Set up a [Firebase Project](https://console.firebase.google.com/) in the console.
* Register for a [Google AdMob Account](https://admob.google.com/).

### 2. Clone the Repository
```bash
git clone https://github.com/Taha-Siraj/ek-su-ek-Game.git
cd ek-su-ek-Game
```

### 3. Install Dependencies
```bash
flutter pub get
```

### 4. Configure Firebase
For full database synchronization, you must connect the app to your Firebase project:
1. Enable **Anonymous Auth** & **Email/Password** provider in your **Firebase Authentication Console > Sign-in method**.
2. Create a **Cloud Firestore Database** in test or production mode.
3. Install the FlutterFire CLI globally:
   ```bash
   dart pub global activate flutterfire_cli
   ```
4. Run the configuration script inside the project directory:
   ```bash
   flutterfire configure
   ```
   This will auto-generate `firebase_options.dart` inside the `lib/` directory and configure Android/iOS credentials.

### 5. Configure AdMob (Monetization setup)
The app runs on Google's official Test Ad IDs out of the box. To configure real production ads:

1. Create a new Android/iOS app inside your **Google AdMob Console** and generate Ad Unit IDs for **Banner**, **Interstitial**, and **Rewarded** formats.
2. Open [ad_service.dart](file:///c:/Users/UCom/OneDrive/Desktop/game/lib/services/ad_service.dart) and replace the Test IDs with your real Ad Unit IDs:
   ```dart
   static const String bannerAdUnitId = 'ca-app-pub-YOUR_BANNER_UNIT_ID';
   static const String interstitialAdUnitId = 'ca-app-pub-YOUR_INTERSTITIAL_UNIT_ID';
   static const String rewardedAdUnitId = 'ca-app-pub-YOUR_REWARDED_UNIT_ID';
   ```
3. Update metadata App IDs inside platform manifest folders to prevent runtime crashes:
   * **Android**: Open [AndroidManifest.xml](file:///c:/Users/UCom/OneDrive/Desktop/game/android/app/src/main/AndroidManifest.xml) and replace the metadata value with your Android App ID:
     ```xml
     <meta-data
         android:name="com.google.android.gms.ads.APPLICATION_ID"
         android:value="ca-app-pub-YOUR_ANDROID_APP_ID"/>
     ```
   * **iOS**: Open [Info.plist](file:///c:/Users/UCom/OneDrive/Desktop/game/ios/Runner/Info.plist) and replace the string key with your iOS App ID:
     ```xml
     <key>GADApplicationIdentifier</key>
     <string>ca-app-pub-YOUR_IOS_APP_ID</string>
     ```

### 6. Build and Run
Connect a physical device or emulator and execute:
```bash
flutter run
```

---

## 🔒 Security Rules (Cloud Firestore)
To prevent unauthorized writes, ensure your Firestore Database uses secure client-side rule mappings. In your Firebase Console, apply these rules:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read: if true; // Allows leaderboard reads
      allow write: if request.auth != null && request.auth.uid == userId; // Allows users to write only their own profiles
    }
  }
}
```

---

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
