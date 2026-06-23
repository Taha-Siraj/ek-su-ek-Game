import 'package:flutter/material.dart';
import '../theme.dart';

class NeonProgressBar extends StatelessWidget {
  final double value; // 0.0 to 1.0
  final double height;
  final List<Color>? gradientColors;
  final Color trackColor;

  const NeonProgressBar({
    Key? key,
    required this.value,
    this.height = 8.0,
    this.gradientColors,
    this.trackColor = MidnightNeonTheme.bgSecondary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double clampedValue = value.clamp(0.0, 1.0);
    final List<Color> fillColors = gradientColors ??
        [
          MidnightNeonTheme.accentPurple,
          MidnightNeonTheme.primaryContainer,
        ];

    return Container(
      height: height + 6.0, // Extra height for the glowing cap
      alignment: Alignment.centerLeft,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double totalWidth = constraints.maxWidth;
          final double fillWidth = totalWidth * clampedValue;

          return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.centerLeft,
            children: [
              // Track
              Container(
                width: totalWidth,
                height: height,
                decoration: BoxDecoration(
                  color: trackColor,
                  borderRadius: BorderRadius.circular(height / 2),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.04),
                    width: 1,
                  ),
                ),
              ),
              // Fill with gradient
              if (clampedValue > 0.0)
                Container(
                  width: fillWidth,
                  height: height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: fillColors,
                    ),
                    borderRadius: BorderRadius.circular(height / 2),
                  ),
                ),
              // Glow Spark / Cap at leading edge
              if (clampedValue > 0.0 && clampedValue < 1.0)
                Positioned(
                  left: fillWidth - (height + 6.0) / 2,
                  child: Container(
                    width: height + 6.0,
                    height: height + 6.0,
                    decoration: BoxDecoration(
                      color: fillColors.last,
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.transparent,
                          blurRadius: 0,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
