import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../widgets/glass_card.dart';
import '../services/audio_manager.dart';
import '../services/ad_service.dart';
import 'victory_screen_animated.dart';
import 'game_over_screen_animated.dart';

class GameplayGridScreen extends StatefulWidget {
  final bool isTrainingMode;
  const GameplayGridScreen({Key? key, this.isTrainingMode = false}) : super(key: key);

  @override
  State<GameplayGridScreen> createState() => _GameplayGridScreenState();
}

class _GameplayGridScreenState extends State<GameplayGridScreen> with TickerProviderStateMixin {
  int _currentScore = 0;
  final int _targetScore = 101;
  int _roundNumber = 1;
  double _timeLimit = 1.0; // 0.0 to 1.0 representing progress bar
  Timer? _gameTimer;
  final List<int> _gridNumbers = [];
  final Random _random = Random();
  int? _lastSelectedIdx;
  late AnimationController _pulseController;
  late final DateTime _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _generateGrid();
    _startTimer();
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _generateGrid() {
    _gridNumbers.clear();
    // Generate 12 numbers (between 1 and 25)
    for (int i = 0; i < 12; i++) {
      _gridNumbers.add(_random.nextInt(20) + 2); // random numbers from 2 to 21
    }
  }

  void _startTimer() {
    _gameTimer?.cancel();
    _timeLimit = 1.0;
    _gameTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted) return;
      setState(() {
        _timeLimit -= 0.005; // ~20 seconds limit
        if (_timeLimit <= 0.0) {
          _timeLimit = 0.0;
          _gameTimer?.cancel();
          _triggerBust(score: _currentScore); // Time out bust
        }
      });
    });
  }

  void _showTrainingGuideDialog(int addedValue) {
    _gameTimer?.cancel();
    final audio = Provider.of<AudioManager>(context, listen: false);
    audio.playSfx('lose');
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final remaining = _targetScore - _currentScore;
        return AlertDialog(
          backgroundColor: MidnightNeonTheme.bgSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusLarge),
            side: const BorderSide(color: MidnightNeonTheme.danger, width: 2),
          ),
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: MidnightNeonTheme.danger, size: 28),
              const SizedBox(width: 8),
              Text(
                "BUST WARNING!",
                style: MidnightNeonTheme.headlineMd.copyWith(color: MidnightNeonTheme.danger, fontSize: 18),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "You selected a card with +$addedValue.",
                style: MidnightNeonTheme.bodyMd.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "Your current score is $_currentScore. Adding $addedValue makes it ${_currentScore + addedValue}, which exceeds the 101 limit!",
                style: MidnightNeonTheme.bodyMd.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: MidnightNeonTheme.primaryContainer.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusMedium),
                  border: Border.all(color: MidnightNeonTheme.primaryContainer.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb_outline, color: MidnightNeonTheme.primaryContainer, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "GUIDE: You need exactly +$remaining to win. Select a number smaller than or equal to $remaining.",
                        style: MidnightNeonTheme.bodyMd.copyWith(color: MidnightNeonTheme.primaryContainer, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                audio.playClick();
                Navigator.of(context).pop();
                _startTimer();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: MidnightNeonTheme.primaryContainer,
                foregroundColor: MidnightNeonTheme.bgPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusMedium),
                ),
              ),
              child: Text(
                "TRY ANOTHER CARD",
                style: MidnightNeonTheme.labelCaps.copyWith(
                  color: MidnightNeonTheme.bgPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _onCellTapped(int index) {
    final audio = Provider.of<AudioManager>(context, listen: false);
    audio.playClick();
    audio.triggerHaptic();

    final addedScore = _gridNumbers[index];
    if (widget.isTrainingMode && _currentScore + addedScore > _targetScore) {
      _showTrainingGuideDialog(addedScore);
      return;
    }

    setState(() {
      _lastSelectedIdx = index;
      _currentScore += addedScore;
      _roundNumber++;

      _gridNumbers[index] = _random.nextInt(20) + 2;

      if (_currentScore == _targetScore) {
        _gameTimer?.cancel();
        _triggerVictory();
      } else if (_currentScore > _targetScore) {
        _gameTimer?.cancel();
        _triggerBust(score: _currentScore);
      }
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _lastSelectedIdx = null;
        });
      }
    });
  }

  void _triggerVictory() {
    final audio = Provider.of<AudioManager>(context, listen: false);
    final durationSeconds = DateTime.now().difference(_startTime).inSeconds;
    audio.recordGame(won: true, durationSeconds: durationSeconds);
    audio.playWin();
    
    // Show Interstitial Ad on game end
    AdService.instance.showInterstitialAd(context);

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => VictoryScreenAnimated(
          score: _currentScore,
          coins: 250,
          combo: 500,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  void _triggerBust({required int score}) {
    final audio = Provider.of<AudioManager>(context, listen: false);
    final durationSeconds = DateTime.now().difference(_startTime).inSeconds;
    audio.recordGame(won: false, durationSeconds: durationSeconds);
    audio.playLose();

    // Show Interstitial Ad on game end
    AdService.instance.showInterstitialAd(context);

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => GameOverScreenAnimated(
          score: score,
          bestScore: 98,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  void _showExitDialog() {
    _gameTimer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: MidnightNeonTheme.bgSecondary,
          title: Text(
            "ABANDON MATCH?",
            style: MidnightNeonTheme.headlineMd.copyWith(color: MidnightNeonTheme.danger),
          ),
          content: Text(
            "Giving up now counts as a bust. Do you wish to return to home dashboard?",
            style: MidnightNeonTheme.bodyMd.copyWith(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // dismiss dialog
                _startTimer(); // resume timer
              },
              child: Text(
                "CONTINUE PLAYING",
                style: MidnightNeonTheme.labelCaps.copyWith(color: MidnightNeonTheme.primaryContainer),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // dismiss dialog
                Navigator.of(context).pop(); // exit match screen
              },
              child: Text(
                "ABANDON",
                style: MidnightNeonTheme.labelCaps.copyWith(color: MidnightNeonTheme.danger),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(decoration: MidnightNeonTheme.radialBackground),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: MidnightNeonTheme.containerMargin),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // HUD: Exit & Round Details
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: MidnightNeonTheme.primaryContainer),
                          onPressed: _showExitDialog,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "ROUND ${widgetFormat(_roundNumber)}",
                              style: MidnightNeonTheme.labelCaps.copyWith(
                                fontSize: 10,
                                color: MidnightNeonTheme.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "LIMIT: 101",
                              style: MidnightNeonTheme.labelCaps.copyWith(
                                fontSize: 12,
                                color: MidnightNeonTheme.danger,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // HUD Score Meter and Progress Bar
                  Column(
                    children: [
                      Text(
                        "CURRENT TOTAL",
                        style: MidnightNeonTheme.labelCaps.copyWith(
                          fontSize: 12,
                          color: MidnightNeonTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Animated pulse of score
                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          double scale = 1.0 + (_pulseController.value * 0.05);
                          if (_currentScore > 90) scale = 1.0 + (_pulseController.value * 0.15); // intensify pulse near limit
                          return Transform.scale(
                            scale: scale,
                            child: Text(
                              "$_currentScore",
                              style: MidnightNeonTheme.displayDigit.copyWith(
                                fontSize: 64,
                                color: _currentScore > 90
                                    ? MidnightNeonTheme.danger
                                    : MidnightNeonTheme.primaryContainer,
                                shadows: [
                                  BoxShadow(color: Colors.transparent, blurRadius: 0),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      // Time progress bar
                      Container(
                        height: 6,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: MidnightNeonTheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: _timeLimit,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [MidnightNeonTheme.accentPurple, MidnightNeonTheme.primaryContainer],
                              ),
                              borderRadius: BorderRadius.circular(3),
                              boxShadow: [
                                BoxShadow(color: Colors.transparent, blurRadius: 0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Game grid container
                  GlassCard(
                    padding: const EdgeInsets.all(12.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1.25,
                      ),
                      itemCount: _gridNumbers.length,
                      itemBuilder: (context, index) {
                        final val = _gridNumbers[index];
                        final bool isHighlighted = _lastSelectedIdx == index;

                        return InkWell(
                          onTap: () => _onCellTapped(index),
                          borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusMedium),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            decoration: BoxDecoration(
                              color: isHighlighted
                                  ? MidnightNeonTheme.primaryContainer.withOpacity(0.2)
                                  : MidnightNeonTheme.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusMedium),
                              border: Border.all(
                                color: isHighlighted
                                    ? MidnightNeonTheme.primaryContainer
                                    : MidnightNeonTheme.borderGlass,
                                width: isHighlighted ? 2.0 : 1.0,
                              ),
                              boxShadow: isHighlighted
                                  ? [
                                      BoxShadow(color: Colors.transparent, blurRadius: 0),
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                "+$val",
                                style: MidnightNeonTheme.displayDigit.copyWith(
                                  fontSize: 18,
                                  color: isHighlighted
                                      ? MidnightNeonTheme.primaryContainer
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Footer utilities / cheats for testing ease
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Auto-win cheat for developer review
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _currentScore = _targetScore;
                              _triggerVictory();
                            });
                          },
                          child: Text(
                            "DEBUG: FORCE WIN",
                            style: MidnightNeonTheme.labelCaps.copyWith(
                              fontSize: 9,
                              color: MidnightNeonTheme.success.withOpacity(0.5),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _currentScore = 105;
                              _triggerBust(score: 105);
                            });
                          },
                          child: Text(
                            "DEBUG: FORCE BUST",
                            style: MidnightNeonTheme.labelCaps.copyWith(
                              fontSize: 9,
                              color: MidnightNeonTheme.danger.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ],
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

  String widgetFormat(int value) {
    return value < 10 ? "0$value" : "$value";
  }
}
