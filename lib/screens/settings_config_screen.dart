import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme.dart';
import '../widgets/glass_card.dart';
import '../services/audio_manager.dart';
import 'login_guest_access_screen.dart';

class SettingsConfigScreen extends StatelessWidget {
  const SettingsConfigScreen({Key? key}) : super(key: key);

  void _showChangeUsernameDialog(BuildContext context, AudioManager audio) {
    final controller = TextEditingController(text: audio.playerName);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: MidnightNeonTheme.bgSecondary,
          title: Text(
            "EDIT USERNAME",
            style: MidnightNeonTheme.headlineMd.copyWith(color: MidnightNeonTheme.primaryContainer, fontSize: 18),
          ),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: "Enter username",
              hintStyle: TextStyle(color: Colors.white30),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: MidnightNeonTheme.borderGlass),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: MidnightNeonTheme.primaryContainer),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                audio.playClick();
                Navigator.of(context).pop();
              },
              child: Text(
                "CANCEL",
                style: MidnightNeonTheme.labelCaps.copyWith(color: MidnightNeonTheme.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () {
                audio.playClick();
                audio.playerName = controller.text;
                Navigator.of(context).pop();
              },
              child: Text(
                "SAVE",
                style: MidnightNeonTheme.labelCaps.copyWith(color: MidnightNeonTheme.primaryContainer),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showChangeAvatarDialog(BuildContext context, AudioManager audio) {
    final List<String> presetImages = [
      'https://api.dicebear.com/7.x/bottts/png?seed=Cyber1',
      'https://api.dicebear.com/7.x/bottts/png?seed=Cyber2',
      'https://api.dicebear.com/7.x/bottts/png?seed=Neon3',
      'https://api.dicebear.com/7.x/bottts/png?seed=Retro4',
      'https://api.dicebear.com/7.x/bottts/png?seed=Gold5',
      'https://api.dicebear.com/7.x/bottts/png?seed=Pixel6',
    ];

    final List<IconData> presetIcons = [
      Icons.face_retouching_natural,
      Icons.emoji_events,
      Icons.bolt,
      Icons.star,
      Icons.shield,
      Icons.favorite,
      Icons.pets,
      Icons.public,
    ];

    final googlePhotoUrl = FirebaseAuth.instance.currentUser?.photoURL;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: MidnightNeonTheme.bgSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusLarge),
            side: const BorderSide(color: MidnightNeonTheme.borderGlass),
          ),
          title: Text(
            "CHOOSE AVATAR",
            style: MidnightNeonTheme.headlineMd.copyWith(color: MidnightNeonTheme.primaryContainer, fontSize: 18),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (googlePhotoUrl != null) ...[
                    Text(
                      "GOOGLE PROFILE PHOTO",
                      style: MidnightNeonTheme.labelCaps.copyWith(fontSize: 10, color: MidnightNeonTheme.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () {
                        audio.playClick();
                        audio.playerAvatarUrl = googlePhotoUrl;
                        Navigator.of(context).pop();
                      },
                      borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusMedium),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: audio.playerAvatarUrl == googlePhotoUrl
                              ? MidnightNeonTheme.primaryContainer.withOpacity(0.15)
                              : MidnightNeonTheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusMedium),
                          border: Border.all(
                            color: audio.playerAvatarUrl == googlePhotoUrl
                                ? MidnightNeonTheme.primaryContainer
                                : MidnightNeonTheme.borderGlass,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(googlePhotoUrl),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "Use Google Account Photo",
                              style: MidnightNeonTheme.bodyMd.copyWith(color: Colors.white, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Text(
                    "PREMIUM CYBER AVATARS",
                    style: MidnightNeonTheme.labelCaps.copyWith(fontSize: 10, color: MidnightNeonTheme.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1,
                    ),
                    itemCount: presetImages.length,
                    itemBuilder: (context, index) {
                      final url = presetImages[index];
                      final isSelected = audio.playerAvatarUrl == url;
                      return InkWell(
                        onTap: () {
                          audio.playClick();
                          audio.playerAvatarUrl = url;
                          Navigator.of(context).pop();
                        },
                        borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusMedium),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? MidnightNeonTheme.primaryContainer.withOpacity(0.15)
                                : MidnightNeonTheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusMedium),
                            border: Border.all(
                              color: isSelected
                                  ? MidnightNeonTheme.primaryContainer
                                  : MidnightNeonTheme.borderGlass,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusMedium),
                            child: Image.network(
                              url,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Center(
                                child: Icon(Icons.broken_image, color: Colors.white24),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "CLASSIC ICONS",
                    style: MidnightNeonTheme.labelCaps.copyWith(fontSize: 10, color: MidnightNeonTheme.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1,
                    ),
                    itemCount: presetIcons.length,
                    itemBuilder: (context, index) {
                      final icon = presetIcons[index];
                      final isSelected = audio.playerAvatarUrl == null && audio.playerAvatar == icon;
                      return InkWell(
                        onTap: () {
                          audio.playClick();
                          audio.playerAvatar = icon;
                          Navigator.of(context).pop();
                        },
                        borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusMedium),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? MidnightNeonTheme.primaryContainer.withOpacity(0.15)
                                : MidnightNeonTheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusMedium),
                            border: Border.all(
                              color: isSelected
                                  ? MidnightNeonTheme.primaryContainer
                                  : MidnightNeonTheme.borderGlass,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Icon(
                            icon,
                            color: isSelected ? MidnightNeonTheme.primaryContainer : Colors.white,
                            size: 24,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showLinkAccountDialog(BuildContext context, AudioManager audio) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: MidnightNeonTheme.bgSecondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusLarge),
                side: const BorderSide(color: MidnightNeonTheme.borderGlass),
              ),
              title: Text(
                "LINK PERMANENT ACCOUNT",
                style: MidnightNeonTheme.headlineMd.copyWith(
                  color: MidnightNeonTheme.primaryContainer,
                  fontSize: 16,
                  letterSpacing: 1.0,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Link your email and password to sync and save your game profile to the cloud.",
                      style: MidnightNeonTheme.bodyMd.copyWith(
                        fontSize: 12,
                        color: MidnightNeonTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: emailController,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "EMAIL ADDRESS",
                        labelStyle: TextStyle(color: MidnightNeonTheme.primaryContainer, fontSize: 10),
                        hintText: "yourname@domain.com",
                        hintStyle: TextStyle(color: Colors.white24, fontSize: 12),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: MidnightNeonTheme.borderGlass),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: MidnightNeonTheme.primaryContainer),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: passwordController,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "PASSWORD",
                        labelStyle: TextStyle(color: MidnightNeonTheme.primaryContainer, fontSize: 10),
                        hintText: "••••••••",
                        hintStyle: TextStyle(color: Colors.white24, fontSize: 12),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: MidnightNeonTheme.borderGlass),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: MidnightNeonTheme.primaryContainer),
                        ),
                      ),
                    ),
                    if (isLoading) ...[
                      const SizedBox(height: 20),
                      const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(MidnightNeonTheme.primaryContainer),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          audio.playClick();
                          Navigator.of(context).pop();
                        },
                  child: Text(
                    "CANCEL",
                    style: MidnightNeonTheme.labelCaps.copyWith(
                      color: MidnightNeonTheme.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          final email = emailController.text.trim();
                          final password = passwordController.text;

                          if (email.isEmpty || password.length < 6) {
                            audio.playClick();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please enter a valid email and 6+ character password."),
                                backgroundColor: MidnightNeonTheme.danger,
                              ),
                            );
                            return;
                          }

                          setDialogState(() {
                            isLoading = true;
                          });

                          try {
                            await audio.linkAccount(email, password);
                            if (context.mounted) {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: MidnightNeonTheme.success,
                                  content: Text(
                                    "Account linked successfully to $email!",
                                    style: MidnightNeonTheme.bodyMd.copyWith(color: Colors.white, fontSize: 14),
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              setDialogState(() {
                                isLoading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Linking failed: ${e.toString().split(']').last.trim()}"),
                                  backgroundColor: MidnightNeonTheme.danger,
                                ),
                              );
                            }
                          }
                        },
                  child: Text(
                    "LINK",
                    style: MidnightNeonTheme.labelCaps.copyWith(
                      color: MidnightNeonTheme.primaryContainer,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showPrivacyPolicyDialog(BuildContext context, AudioManager audio) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: MidnightNeonTheme.bgSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusLarge),
            side: const BorderSide(color: MidnightNeonTheme.borderGlass),
          ),
          title: Text(
            "PRIVACY POLICY",
            style: MidnightNeonTheme.headlineMd.copyWith(
              color: MidnightNeonTheme.primaryContainer,
              fontSize: 16,
              letterSpacing: 1.0,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Effective Date: June 24, 2026",
                    style: MidnightNeonTheme.bodyMd.copyWith(
                      fontSize: 12,
                      color: MidnightNeonTheme.primaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Welcome to The Last Number (101). Your privacy is important to us. This Privacy Policy details how we collect, use, and protect your information.",
                    style: MidnightNeonTheme.bodyMd.copyWith(fontSize: 12, color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "1. Information We Collect",
                    style: MidnightNeonTheme.headlineMd.copyWith(fontSize: 13, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "• Account Data: When you sign in with Google or create an account, we store your profile name, email, and avatar picture on Firebase.\n"
                    "• Game Progress: Wins, losses, level progression, and coins are synced to secure cloud databases to allow cross-device play.",
                    style: MidnightNeonTheme.bodyMd.copyWith(fontSize: 12, color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "2. How We Use Information",
                    style: MidnightNeonTheme.headlineMd.copyWith(fontSize: 13, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "We use your details to maintain the global leaderboard standings, personalize your gaming experience, sync data across your sessions, and secure our online systems.",
                    style: MidnightNeonTheme.bodyMd.copyWith(fontSize: 12, color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "3. Third-Party Services",
                    style: MidnightNeonTheme.headlineMd.copyWith(fontSize: 13, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "We integrate with Google Play Services, Firebase Authentication, Cloud Firestore, and Google Mobile Ads to deliver secure authentication, real-time data sync, and non-intrusive rewarded ads.",
                    style: MidnightNeonTheme.bodyMd.copyWith(fontSize: 12, color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "4. Data Security & Deletion",
                    style: MidnightNeonTheme.headlineMd.copyWith(fontSize: 13, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Your profile data is protected using industrial Firebase security protocols. You may request account and data deletion at any time by contacting our support team.",
                    style: MidnightNeonTheme.bodyMd.copyWith(fontSize: 11, color: MidnightNeonTheme.textSecondary),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                audio.playClick();
                Navigator.of(context).pop();
              },
              child: Text(
                "CLOSE",
                style: MidnightNeonTheme.labelCaps.copyWith(
                  color: MidnightNeonTheme.primaryContainer,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final audio = Provider.of<AudioManager>(context);

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
                    // Header Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "CONFIG",
                          style: MidnightNeonTheme.headlineLg.copyWith(
                            color: MidnightNeonTheme.primaryContainer,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.help_outline, color: MidnightNeonTheme.primaryContainer),
                          onPressed: () {
                            audio.playClick();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // User Profile Summary Card
                    GlassCard(
                      padding: const EdgeInsets.all(MidnightNeonTheme.spacingMd),
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: MidnightNeonTheme.primaryContainer, width: 2),
                                  boxShadow: const [
                                    BoxShadow(color: Colors.transparent, blurRadius: 0),
                                  ],
                                ),
                                child: CircleAvatar(
                                  backgroundColor: MidnightNeonTheme.surfaceContainerLow,
                                  backgroundImage: audio.playerAvatarUrl != null ? NetworkImage(audio.playerAvatarUrl!) : null,
                                  child: audio.playerAvatarUrl == null
                                      ? Icon(audio.playerAvatar, color: MidnightNeonTheme.primaryContainer, size: 36)
                                      : null,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: MidnightNeonTheme.success,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: MidnightNeonTheme.surface, width: 2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                audio.playerName,
                                style: MidnightNeonTheme.headlineMd.copyWith(fontSize: 18),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.workspace_premium, color: MidnightNeonTheme.secondaryContainer, size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    "PRO LEAGUE",
                                    style: MidnightNeonTheme.labelCaps.copyWith(
                                      color: MidnightNeonTheme.secondaryContainer,
                                      fontSize: 9,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, color: MidnightNeonTheme.primaryContainer),
                            onPressed: () {
                              audio.playClick();
                              _showChangeUsernameDialog(context, audio);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Gameplay Settings Group
                    _buildSectionHeader("GAMEPLAY"),
                    GlassCard(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          _buildSwitchRow(
                            icon: Icons.vibration,
                            title: "Vibration Mode",
                            value: audio.vibrateMode,
                            onChanged: (val) {
                              audio.vibrateMode = val;
                              audio.triggerHaptic();
                            },
                          ),
                          Divider(color: MidnightNeonTheme.borderGlass, height: 1),
                          _buildSwitchRow(
                            icon: Icons.smartphone,
                            title: "Haptic Feedback",
                            value: audio.hapticFeedback,
                            onChanged: (val) {
                              audio.hapticFeedback = val;
                              audio.triggerHaptic();
                            },
                          ),
                          Divider(color: MidnightNeonTheme.borderGlass, height: 1),
                          _buildSwitchRow(
                            icon: Icons.blur_on,
                            title: "Motion Effects",
                            value: audio.motionEffects,
                            onChanged: (val) {
                              audio.motionEffects = val;
                              audio.playClick();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Audio Settings Group
                    _buildSectionHeader("AUDIO"),
                    GlassCard(
                      padding: const EdgeInsets.all(MidnightNeonTheme.spacingMd),
                      child: Column(
                        children: [
                          _buildSliderRow(
                            icon: Icons.volume_up,
                            title: "Master Volume",
                            value: audio.masterVolume * 100.0,
                            onChanged: (val) {
                              audio.masterVolume = val / 100.0;
                            },
                            onChangeEnd: (val) {
                              audio.playClick();
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildSliderRow(
                            icon: Icons.music_note,
                            title: "Music",
                            value: audio.musicVolume * 100.0,
                            onChanged: (val) {
                              audio.musicVolume = val / 100.0;
                            },
                            onChangeEnd: (val) {
                              audio.playClick();
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildSliderRow(
                            icon: Icons.campaign,
                            title: "SFX",
                            value: audio.sfxVolume * 100.0,
                            onChanged: (val) {
                              audio.sfxVolume = val / 100.0;
                            },
                            onChangeEnd: (val) {
                              audio.playClick();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Account Settings Group
                    _buildSectionHeader("ACCOUNT"),
                    GlassCard(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          _buildNavigationRow("Link Account", Icons.link, () {
                            audio.playClick();
                            _showLinkAccountDialog(context, audio);
                          }),
                          Divider(color: MidnightNeonTheme.borderGlass, height: 1),
                          _buildNavigationRow("Change Avatar", Icons.face, () {
                            audio.playClick();
                            _showChangeAvatarDialog(context, audio);
                          }),
                          Divider(color: MidnightNeonTheme.borderGlass, height: 1),
                          _buildNavigationRow("Privacy Policy", Icons.policy, () {
                            audio.playClick();
                            _showPrivacyPolicyDialog(context, audio);
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Community/Socials Group
                    _buildSectionHeader("COMMUNITY"),
                    GlassCard(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          _buildNavigationRow("Join Discord Community", Icons.chat_bubble_outline, () {
                            audio.playClick();
                            _copyLinkAndShowSnackbar(context, "https://discord.gg/eksauek101", "Discord Link");
                          }),
                          Divider(color: MidnightNeonTheme.borderGlass, height: 1),
                          _buildNavigationRow("Follow on X / Twitter", Icons.alternate_email, () {
                            audio.playClick();
                            _copyLinkAndShowSnackbar(context, "https://x.com/eksauek101", "X / Twitter Link");
                          }),
                          Divider(color: MidnightNeonTheme.borderGlass, height: 1),
                          _buildNavigationRow("Visit Website", Icons.language, () {
                            audio.playClick();
                            _copyLinkAndShowSnackbar(context, "https://eksauek101.com", "Website URL");
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Danger Zone
                    _buildSectionHeader("DANGER ZONE", isDanger: true),
                    InkWell(
                      onTap: () async {
                        audio.playClick();
                        await audio.logout();
                        if (context.mounted) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => const LoginGuestAccessScreen()),
                            (route) => false,
                          );
                        }
                      },
                      borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusLarge),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusLarge),
                          border: Border.all(color: Colors.transparent),
                          color: Colors.transparent,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.logout, color: MidnightNeonTheme.danger),
                            const SizedBox(width: 8),
                            Text(
                              "LOGOUT",
                              style: MidnightNeonTheme.buttonText.copyWith(
                                color: MidnightNeonTheme.danger,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 120), // Bottom padding for navigation spacing
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {bool isDanger = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: MidnightNeonTheme.labelCaps.copyWith(
          fontSize: 10,
          color: isDanger ? MidnightNeonTheme.danger : MidnightNeonTheme.textSecondary,
        ),
      ),
    );
  }

  Widget _buildSwitchRow({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: MidnightNeonTheme.primaryContainer, size: 20),
              const SizedBox(width: 12),
              Text(title, style: MidnightNeonTheme.bodyMd.copyWith(color: Colors.white)),
            ],
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: MidnightNeonTheme.primaryContainer,
            activeTrackColor: Colors.black.withValues(alpha: 0.2),
            inactiveThumbColor: MidnightNeonTheme.textSecondary,
            inactiveTrackColor: MidnightNeonTheme.surfaceContainerLow,
          ),
        ],
      ),
    );
  }

  Widget _buildSliderRow({
    required IconData icon,
    required String title,
    required double value,
    required ValueChanged<double> onChanged,
    required ValueChanged<double> onChangeEnd,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: MidnightNeonTheme.primaryContainer, size: 20),
                const SizedBox(width: 12),
                Text(title, style: MidnightNeonTheme.bodyMd.copyWith(color: Colors.white)),
              ],
            ),
            Text(
              "${value.toInt()}%",
              style: MidnightNeonTheme.labelCaps.copyWith(color: MidnightNeonTheme.primaryContainer),
            ),
          ],
        ),
        Slider(
          value: value,
          min: 0.0,
          max: 100.0,
          divisions: 20,
          activeColor: MidnightNeonTheme.primaryContainer,
          inactiveColor: MidnightNeonTheme.surfaceContainerLow,
          onChanged: onChanged,
          onChangeEnd: onChangeEnd,
        ),
      ],
    );
  }

  Widget _buildNavigationRow(String title, IconData icon, VoidCallback onTap, {Color? iconColor}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor ?? MidnightNeonTheme.primaryContainer, size: 20),
                const SizedBox(width: 12),
                Text(title, style: MidnightNeonTheme.bodyMd.copyWith(color: Colors.white)),
              ],
            ),
            const Icon(Icons.chevron_right, color: MidnightNeonTheme.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }

  void _copyLinkAndShowSnackbar(BuildContext context, String url, String type) {
    Clipboard.setData(ClipboardData(text: url));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: MidnightNeonTheme.success,
        content: Text(
          "$type copied to clipboard! Open it in your browser.",
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
      ),
    );
  }
}
