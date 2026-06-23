import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/neon_button.dart';

class ShaderScreen extends StatefulWidget {
  const ShaderScreen({Key? key}) : super(key: key);

  @override
  State<ShaderScreen> createState() => _ShaderScreenState();
}

class _ShaderScreenState extends State<ShaderScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(decoration: MidnightNeonTheme.radialBackground),
          // Animated custom painter wave grid
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: _NeonShaderPainter(_controller.value),
                );
              },
            ),
          ),
          // Overlay UI details
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(MidnightNeonTheme.containerMargin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "NEON SHADER EFFECTS",
                    style: MidnightNeonTheme.headlineLg.copyWith(
                      color: MidnightNeonTheme.primaryContainer,
                      shadows: [
                        Shadow(color: Colors.transparent, blurRadius: 0),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Background fragment shader rendering using CPU CustomPainter vectors.",
                    style: MidnightNeonTheme.bodyMd,
                  ),
                  const Spacer(),
                  NeonButton.primary(
                    text: "RETURN TO HUD",
                    icon: Icons.done,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NeonShaderPainter extends CustomPainter {
  final double animationVal;

  _NeonShaderPainter(this.animationVal);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final double step = 20.0;
    final double time = animationVal * 2 * math.pi;

    for (double y = 0; y < size.height; y += step) {
      final Path path = Path();
      path.moveTo(0, y);

      for (double x = 0; x < size.width; x += 10.0) {
        // Compute wave amplitude using sine waves
        final double wave = math.sin((x / size.width) * 4 * math.pi + time) * 15.0;
        final double wave2 = math.cos((y / size.height) * 2 * math.pi - time) * 10.0;
        path.lineTo(x, y + wave + wave2);
      }

      // Smooth gradient color from cyan to purple based on vertical height
      final double progress = y / size.height;
      paint.color = Color.lerp(
        Colors.transparent,
        MidnightNeonTheme.accentPurple.withOpacity(0.08),
        progress,
      )!;

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _NeonShaderPainter oldDelegate) {
    return oldDelegate.animationVal != animationVal;
  }
}
