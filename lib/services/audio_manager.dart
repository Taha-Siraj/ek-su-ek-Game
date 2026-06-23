import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AudioManager extends ChangeNotifier {
  late final AudioPlayer _musicPlayer;
  double _masterVolume = 0.85;
  double _musicVolume = 0.60;
  double _sfxVolume = 1.00;
  bool _hapticFeedback = true;
  bool _vibrateMode = true;
  bool _motionEffects = true;
  String? _playerAvatarUrl;

  // Global Player Profile & Gameplay State
  String _playerName = "GoldRacer_101";
  IconData _playerAvatar = Icons.face_retouching_natural;
  int _totalGames = 1240;
  int _totalWins = 89;
  int _xp = 89240;
  int _coins = 2500;
  final List<String> _unlockedAchievements = ["First 101", "Speed Demon", "Perfect 10"];

  // Local Leaderboard Fallbacks
  static const List<Map<String, dynamic>> _globalPlayersLocal = [
    {
      "rank": "1st",
      "name": "ViperStrike_99",
      "subtitle": "PRO LEAGUE CHAMPION",
      "score": "1,420,500 XP",
      "color": Color(0xFFD4AF37),
    },
    {
      "rank": "2nd",
      "name": "NeonGhost",
      "subtitle": "ELITE TIER III",
      "score": "1,388,420 XP",
      "color": Color(0xFFE5E5E5),
    },
    {
      "rank": "3rd",
      "name": "CyberRider",
      "subtitle": "ELITE TIER II",
      "score": "1,210,000 XP",
      "color": Color(0xFFCD7F32),
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

  static const List<Map<String, dynamic>> _friendsPlayersLocal = [
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

  static const List<Map<String, dynamic>> _countryPlayersLocal = [
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

  AudioManager() {
    _musicPlayer = AudioPlayer();
    _musicPlayer.setReleaseMode(ReleaseMode.loop);
    _updateMusicVolume();
    _tryAutoLogin();
  }

  // Getters and Setters for Player Profile
  String get playerName => _playerName;
  IconData get playerAvatar => _playerAvatar;
  String? get playerAvatarUrl => _playerAvatarUrl;
  int get totalGames => _totalGames;
  int get totalWins => _totalWins;
  int get xp => _xp;
  int get coins => _coins;
  List<String> get unlockedAchievements => _unlockedAchievements;

  set playerName(String name) {
    _playerName = name.trim().isEmpty ? "GoldRacer_101" : name;
    _saveProfileToCloud();
    notifyListeners();
  }

  set playerAvatar(IconData avatar) {
    _playerAvatar = avatar;
    _playerAvatarUrl = null; // Clear URL if choosing material icon
    _saveProfileToCloud();
    notifyListeners();
  }

  set playerAvatarUrl(String? url) {
    _playerAvatarUrl = url;
    _saveProfileToCloud();
    notifyListeners();
  }

  int get playerLevel {
    return 1 + (_xp ~/ 8000);
  }

  double get levelProgress {
    final currentLevelXp = _xp % 8000;
    return currentLevelXp / 8000.0;
  }

  int get xpToNextLevel {
    return 8000 - (_xp % 8000);
  }

  double get winRate {
    if (_totalGames == 0) return 0.0;
    return (_totalWins / _totalGames) * 100.0;
  }

  // Firebase Authentication & Cloud Sync API
  Future<void> _tryAutoLogin() async {
    try {
      final auth = FirebaseAuth.instance;
      if (auth.currentUser != null) {
        await _syncProfileFromCloud(auth.currentUser!.uid);
      }
    } catch (e) {
      print("Firebase auto-login skipped: $e");
    }
  }

  Future<void> loginAndSync(String name, IconData avatar) async {
    _playerName = name;
    _playerAvatar = avatar;
    _playerAvatarUrl = null;
    notifyListeners();

    try {
      final auth = FirebaseAuth.instance;
      if (auth.currentUser == null) {
        await auth.signInAnonymously();
      }
      final uid = auth.currentUser?.uid;
      if (uid != null) {
        await _syncProfileFromCloud(uid);
      }
    } catch (e) {
      print("Firebase login/sync failed (offline mode fallback): $e");
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception("Google Sign-In aborted by user.");
      }
      
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;
      
      if (user != null) {
        // Local defaults
        _playerName = user.displayName ?? "Player_${user.uid.substring(0, 5)}";
        _playerAvatarUrl = user.photoURL;
        
        await _syncProfileFromCloud(user.uid);
        
        if (_playerName.isEmpty || _playerName == "GoldGhost" || _playerName == "GoldRacer_101" || _playerName == "Player") {
          _playerName = user.displayName ?? "Player_${user.uid.substring(0, 5)}";
        }
        if (_playerAvatarUrl == null) {
          _playerAvatarUrl = user.photoURL;
        }
        
        await _saveProfileToCloud();
        notifyListeners();
      }
    } catch (e) {
      print("Google Sign-In failed: $e");
      rethrow;
    }
  }

  Future<void> loginWithEmail(String email, String password) async {
    try {
      final auth = FirebaseAuth.instance;
      UserCredential credential;
      try {
        credential = await auth.signInWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
          credential = await auth.createUserWithEmailAndPassword(
            email: email.trim(),
            password: password,
          );
        } else {
          rethrow;
        }
      }
      final uid = credential.user?.uid;
      if (uid != null) {
        await _syncProfileFromCloud(uid);
      }
    } catch (e) {
      print("Email auth/sync failed: $e");
      rethrow;
    }
  }

  Future<void> linkAccount(String email, String password) async {
    try {
      final auth = FirebaseAuth.instance;
      var user = auth.currentUser;
      if (user == null) {
        await auth.signInAnonymously();
        user = auth.currentUser;
      }
      if (user != null) {
        final credential = EmailAuthProvider.credential(
          email: email.trim(),
          password: password,
        );
        await user.linkWithCredential(credential);
        await _saveProfileToCloud();
      } else {
        throw Exception("No authenticated user session.");
      }
    } catch (e) {
      print("Account linking failed: $e");
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
    } catch (e) {
      print("Firebase logout failed: $e");
    }
    _playerName = "GoldGhost";
    _playerAvatar = Icons.face_retouching_natural;
    _playerAvatarUrl = null;
    _totalGames = 0;
    _totalWins = 0;
    _xp = 0;
    _coins = 500;
    _unlockedAchievements.clear();
    notifyListeners();
  }

  Future<void> _syncProfileFromCloud(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null) {
          _playerName = data['playerName'] ?? _playerName;
          _playerAvatarUrl = data['avatarUrl'] ?? _playerAvatarUrl;
          final avatarCode = data['avatarCode'];
          if (avatarCode != null) {
            _playerAvatar = IconData(avatarCode as int, fontFamily: 'MaterialIcons');
          }
          _totalGames = data['totalGames'] ?? _totalGames;
          _totalWins = data['totalWins'] ?? _totalWins;
          _xp = data['xp'] ?? _xp;
          _coins = data['coins'] ?? _coins;
          if (data['unlockedAchievements'] != null) {
            _unlockedAchievements.clear();
            _unlockedAchievements.addAll(List<String>.from(data['unlockedAchievements'] as List));
          }
          notifyListeners();
        }
      } else {
        await _saveProfileToCloud();
      }
    } catch (e) {
      print("Firestore profile sync error: $e");
    }
  }

  Future<void> _saveProfileToCloud() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'playerName': _playerName,
          'avatarUrl': _playerAvatarUrl,
          'avatarCode': _playerAvatar.codePoint,
          'totalGames': _totalGames,
          'totalWins': _totalWins,
          'xp': _xp,
          'coins': _coins,
          'unlockedAchievements': _unlockedAchievements,
          'lastUpdated': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    } catch (e) {
      print("Firestore profile save skipped or failed: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchLeaderboard({required String type}) async {
    try {
      // Query top 10 players sorted by XP from Firestore
      Query query = FirebaseFirestore.instance.collection('users').orderBy('xp', descending: true).limit(10);
      
      // Additional filters can be applied here based on 'type' if needed
      final snapshot = await query.get();
      if (snapshot.docs.isEmpty) {
        throw Exception("Empty cloud leaderboard");
      }

      int rank = 1;
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        String rankStr = "${rank}th";
        if (rank == 1) rankStr = "1st";
        if (rank == 2) rankStr = "2nd";
        if (rank == 3) rankStr = "3rd";
        
        final color = rank == 1
            ? const Color(0xFFD4AF37)
            : rank == 2
                ? const Color(0xFFE5E5E5)
                : rank == 3
                    ? const Color(0xFFCD7F32)
                    : const Color(0xFFAEB8C4);

        rank++;
        return {
          "uid": doc.id,
          "rank": rankStr,
          "name": data['playerName'] ?? "Player",
          "avatarUrl": data['avatarUrl'],
          "avatarCode": data['avatarCode'],
          "score": "${_formatNumber(data['xp'] ?? 0)} XP",
          "subtitle": "LEVEL ${1 + ((data['xp'] ?? 0) ~/ 8000)}",
          "color": color,
          "xp": data['xp'] ?? 0,
          "totalGames": data['totalGames'] ?? 0,
          "totalWins": data['totalWins'] ?? 0,
        };
      }).toList();
    } catch (e) {
      print("Firebase leaderboard fetch failed, using offline fallback: $e");
      if (type == "GLOBAL") return _globalPlayersLocal;
      if (type == "FRIENDS") return _friendsPlayersLocal;
      return _countryPlayersLocal;
    }
  }

  String _formatNumber(int val) {
    return val.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  void addXp(int amount) {
    _xp += amount;
    _saveProfileToCloud();
    notifyListeners();
  }

  void addCoins(int amount) {
    _coins += amount;
    _saveProfileToCloud();
    notifyListeners();
  }

  void recordGame({required bool won, int durationSeconds = 999}) {
    _totalGames++;
    if (won) {
      _totalWins++;
      _xp += 250;
      _coins += 250;
      
      if (!_unlockedAchievements.contains("First 101")) {
        _unlockedAchievements.add("First 101");
      }
      if (durationSeconds <= 10 && !_unlockedAchievements.contains("Speed Demon")) {
        _unlockedAchievements.add("Speed Demon");
      }
      if (_totalWins >= 10 && !_unlockedAchievements.contains("Perfect 10")) {
        _unlockedAchievements.add("Perfect 10");
      }
      if (_totalWins >= 100 && !_unlockedAchievements.contains("Centurion")) {
        _unlockedAchievements.add("Centurion");
      }
    } else {
      _xp += 50;
      _coins += 20;
    }
    _saveProfileToCloud();
    notifyListeners();
  }

  bool isAchievementUnlocked(String name) {
    return _unlockedAchievements.contains(name);
  }

  void toggleAchievement(String name) {
    if (_unlockedAchievements.contains(name)) {
      _unlockedAchievements.remove(name);
    } else {
      _unlockedAchievements.add(name);
    }
    _saveProfileToCloud();
    notifyListeners();
  }

  double get masterVolume => _masterVolume;
  double get musicVolume => _musicVolume;
  double get sfxVolume => _sfxVolume;
  bool get hapticFeedback => _hapticFeedback;
  bool get vibrateMode => _vibrateMode;
  bool get motionEffects => _motionEffects;

  set masterVolume(double val) {
    _masterVolume = val.clamp(0.0, 1.0);
    _updateMusicVolume();
    notifyListeners();
  }

  set musicVolume(double val) {
    _musicVolume = val.clamp(0.0, 1.0);
    _updateMusicVolume();
    notifyListeners();
  }

  set sfxVolume(double val) {
    _sfxVolume = val.clamp(0.0, 1.0);
    notifyListeners();
  }

  set hapticFeedback(bool val) {
    _hapticFeedback = val;
    notifyListeners();
  }

  set vibrateMode(bool val) {
    _vibrateMode = val;
    notifyListeners();
  }

  set motionEffects(bool val) {
    _motionEffects = val;
    notifyListeners();
  }

  void _updateMusicVolume() {
    _musicPlayer.setVolume(_masterVolume * _musicVolume);
  }

  Future<void> startMusic() async {
    try {
      await _musicPlayer.play(AssetSource('audio/music.wav'));
    } catch (e) {
      print("Error starting music: $e");
    }
  }

  Future<void> stopMusic() async {
    try {
      await _musicPlayer.stop();
    } catch (e) {
      print("Error stopping music: $e");
    }
  }

  Future<void> playSfx(String name) async {
    try {
      final player = AudioPlayer();
      await player.setVolume(_masterVolume * _sfxVolume);
      await player.play(AssetSource('audio/$name.wav'));
      player.onPlayerComplete.listen((_) {
        player.dispose();
      });
    } catch (e) {
      print("Error playing SFX ($name): $e");
    }
  }

  void playClick() {
    playSfx('click');
  }

  void playWin() {
    playSfx('win');
  }

  void playLose() {
    playSfx('lose');
  }

  void triggerHaptic() {
    if (_vibrateMode) {
      HapticFeedback.vibrate();
    } else if (_hapticFeedback) {
      HapticFeedback.lightImpact();
    }
  }

  // --- FRIENDS MANAGEMENT SYSTEM ---

  Future<void> sendFriendRequest({
    required String targetUid,
    required String targetName,
    required String? targetAvatarUrl,
    required int targetAvatarCode,
  }) async {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    if (currentUid == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUid)
          .collection('friends')
          .doc(targetUid)
          .set({
        'uid': targetUid,
        'playerName': targetName,
        'avatarUrl': targetAvatarUrl,
        'avatarCode': targetAvatarCode,
        'status': 'requested',
        'createdAt': FieldValue.serverTimestamp(),
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(targetUid)
          .collection('friends')
          .doc(currentUid)
          .set({
        'uid': currentUid,
        'playerName': _playerName,
        'avatarUrl': _playerAvatarUrl,
        'avatarCode': _playerAvatar.codePoint,
        'status': 'received',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error sending friend request: $e");
    }
  }

  Future<void> acceptFriendRequest({
    required String targetUid,
    required String targetName,
    required String? targetAvatarUrl,
    required int targetAvatarCode,
  }) async {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    if (currentUid == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUid)
          .collection('friends')
          .doc(targetUid)
          .update({'status': 'friends'});

      await FirebaseFirestore.instance
          .collection('users')
          .doc(targetUid)
          .collection('friends')
          .doc(currentUid)
          .update({'status': 'friends'});
    } catch (e) {
      print("Error accepting friend request: $e");
    }
  }

  Future<void> declineFriendRequest(String targetUid) async {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    if (currentUid == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUid)
          .collection('friends')
          .doc(targetUid)
          .delete();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(targetUid)
          .collection('friends')
          .doc(currentUid)
          .delete();
    } catch (e) {
      print("Error declining/unfriending request: $e");
    }
  }

  Future<void> unfriend(String targetUid) async {
    await declineFriendRequest(targetUid);
  }

  Stream<QuerySnapshot> streamFriends() {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    if (currentUid == null) return const Stream.empty();

    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentUid)
        .collection('friends')
        .where('status', isEqualTo: 'friends')
        .snapshots();
  }

  Stream<QuerySnapshot> streamPendingRequests() {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    if (currentUid == null) return const Stream.empty();

    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentUid)
        .collection('friends')
        .where('status', isEqualTo: 'received')
        .snapshots();
  }

  Stream<DocumentSnapshot> streamFriendStatus(String targetUid) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    if (currentUid == null) return const Stream.empty();

    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentUid)
        .collection('friends')
        .doc(targetUid)
        .snapshots();
  }
}
