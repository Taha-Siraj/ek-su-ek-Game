import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final double blur;
  final double borderRadius;
  final Color? borderColor;
  final EdgeInsetsGeometry padding;
  final List<Color>? gradientColors;

  const GlassCard({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.blur = 12.0,
    this.borderRadius = MidnightNeonTheme.radiusLarge,
    this.borderColor,
    this.padding = const EdgeInsets.all(MidnightNeonTheme.spacingMd),
    this.gradientColors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor ?? Colors.white.withOpacity(0.08),
              width: 1.0,
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: gradientColors ??
                  [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.0),
                  ],
              stops: const [0.0, 0.1], // Simulates top-down light hitting edge
            ),
            color: MidnightNeonTheme.surfaceContainerLow.withOpacity(0.8),
          ),
          child: child,
        ),
      ),
    );
  }
}
