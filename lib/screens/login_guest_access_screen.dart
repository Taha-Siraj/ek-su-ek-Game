import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/neon_button.dart';
import '../navigation.dart';
import '../services/audio_manager.dart';

class LoginGuestAccessScreen extends StatefulWidget {
  const LoginGuestAccessScreen({Key? key}) : super(key: key);

  @override
  State<LoginGuestAccessScreen> createState() => _LoginGuestAccessScreenState();
}

class _LoginGuestAccessScreenState extends State<LoginGuestAccessScreen> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  final List<Point<double>> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..forward();

    // Generate random background particles
    for (int i = 0; i < 20; i++) {
      _particles.add(Point(
        _random.nextDouble(),
        _random.nextDouble(),
      ));
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _onLogin(String name, IconData avatar) {
    final audio = Provider.of<AudioManager>(context, listen: false);
    audio.loginAndSync(name, avatar);
    audio.playClick();
    audio.triggerHaptic();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const AppNavigationWrapper(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  void _showEmailAuthDialog(BuildContext context) {
    final audio = Provider.of<AudioManager>(context, listen: false);
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
                "EMAIL SIGN IN / SIGN UP",
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
                      "Enter your email and password. New accounts are created automatically.",
                      style: MidnightNeonTheme.bodyMd.copyWith(
                        fontSize: 11,
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
                        hintText: "example@domain.com",
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
                            await audio.loginWithEmail(email, password);
                            if (context.mounted) {
                              Navigator.of(context).pop();
                              Navigator.of(context).pushReplacement(
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) =>
                                      const AppNavigationWrapper(),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return FadeTransition(opacity: animation, child: child);
                                  },
                                  transitionDuration: const Duration(milliseconds: 600),
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
                                  content: Text("Authentication failed: ${e.toString().split(']').last.trim()}"),
                                  backgroundColor: MidnightNeonTheme.danger,
                                ),
                              );
                            }
                          }
                        },
                  child: Text(
                    "SUBMIT",
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(decoration: MidnightNeonTheme.radialBackground),

          // Particle background overlay (toggled by motionEffects)
          if (Provider.of<AudioManager>(context).motionEffects)
            ..._particles.map((p) => Positioned(
                  left: p.x * size.width,
                  top: p.y * size.height,
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: MidnightNeonTheme.primaryContainer.withOpacity(0.12),
                    ),
                  ),
                )),

          FadeTransition(
            opacity: _fadeController,
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: MidnightNeonTheme.containerMargin),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Header Icons
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: MidnightNeonTheme.spacingSm),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.help_outline, color: MidnightNeonTheme.primaryContainer),
                                    onPressed: () {
                                      Provider.of<AudioManager>(context, listen: false).playClick();
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.language, color: MidnightNeonTheme.primaryContainer),
                                    onPressed: () {
                                      Provider.of<AudioManager>(context, listen: false).playClick();
                                    },
                                  ),
                                ],
                              ),
                            ),

                            // Main Branding & Logo
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: MidnightNeonTheme.surfaceContainerLow,
                                    borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusLarge),
                                    border: Border.all(
                                      color: MidnightNeonTheme.primaryContainer,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusLarge),
                                    child: Image.asset(
                                      'assets/images/logo.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  "THE LAST NUMBER",
                                  style: MidnightNeonTheme.headlineLg.copyWith(
                                    fontSize: 22,
                                    color: MidnightNeonTheme.primary,
                                    letterSpacing: 2.0,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Master the challenge. Reach 101.",
                                  style: MidnightNeonTheme.bodyMd.copyWith(
                                    color: MidnightNeonTheme.textSecondary,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 40),

                            // Login Card options
                            Column(
                              children: [
                                GlassCard(
                                  padding: const EdgeInsets.all(MidnightNeonTheme.spacingLg),
                                  child: Column(
                                    children: [
                                      NeonButton.primary(
                                        text: "CONTINUE AS GUEST",
                                        onTap: () => _onLogin("GoldGhost", Icons.face_retouching_natural),
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          const Expanded(child: Divider(color: MidnightNeonTheme.borderGlass)),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 12),
                                            child: Text(
                                              "OR CONNECT WITH",
                                              style: MidnightNeonTheme.labelCaps.copyWith(
                                                fontSize: 9,
                                                color: MidnightNeonTheme.textSecondary.withOpacity(0.6),
                                              ),
                                            ),
                                          ),
                                          const Expanded(child: Divider(color: MidnightNeonTheme.borderGlass)),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: () => _onLogin("GoogleRacer_101", Icons.g_mobiledata),
                                              borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusMedium),
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(vertical: 14),
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: MidnightNeonTheme.borderGlass),
                                                  borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusMedium),
                                                  color: Colors.white.withOpacity(0.02),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(Icons.g_mobiledata, color: Colors.white, size: 24),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      "Google",
                                                      style: MidnightNeonTheme.buttonText.copyWith(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () => _onLogin("AppleRacer_101", Icons.apple),
                                              borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusMedium),
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(vertical: 14),
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: MidnightNeonTheme.borderGlass),
                                                  borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusMedium),
                                                  color: Colors.white.withOpacity(0.02),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(Icons.apple, color: Colors.white, size: 20),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      "Apple",
                                                      style: MidnightNeonTheme.buttonText.copyWith(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      NeonButton.secondary(
                                        text: "SIGN IN WITH EMAIL",
                                        onTap: () => _showEmailAuthDialog(context),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  "By continuing, you agree to our\nTerms of Service and Privacy Policy.",
                                  textAlign: TextAlign.center,
                                  style: MidnightNeonTheme.labelCaps.copyWith(
                                    fontSize: 9,
                                    color: MidnightNeonTheme.textSecondary.withOpacity(0.4),
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}