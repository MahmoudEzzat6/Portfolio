import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AmbientBackground extends StatefulWidget {
  final Widget child;
  final PortfolioThemeData theme;

  const AmbientBackground({
    super.key,
    required this.child,
    required this.theme,
  });

  @override
  State<AmbientBackground> createState() => _AmbientBackgroundState();
}

class _AmbientBackgroundState extends State<AmbientBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = _controller.value;
        return Stack(
          children: [
            // Dark base
            Positioned.fill(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                color: t.background,
              ),
            ),

            // Top-left glowing orb
            Positioned(
              top: -120 + math.sin(progress * 2 * math.pi) * 40,
              left: -80 + math.cos(progress * 2 * math.pi) * 40,
              child: Container(
                width: 480,
                height: 480,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      t.primary.withValues(alpha: 0.18),
                      t.secondary.withValues(alpha: 0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Middle-right glowing orb
            Positioned(
              top: 500 + math.cos(progress * 2 * math.pi) * 50,
              right: -100 + math.sin(progress * 2 * math.pi) * 40,
              child: Container(
                width: 520,
                height: 520,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      t.accent.withValues(alpha: 0.14),
                      t.primary.withValues(alpha: 0.06),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Lower-left glowing orb
            Positioned(
              bottom: 200 + math.sin(progress * 2 * math.pi) * 40,
              left: -120 + math.cos(progress * 2 * math.pi) * 30,
              child: Container(
                width: 450,
                height: 450,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      t.secondary.withValues(alpha: 0.14),
                      t.accent.withValues(alpha: 0.05),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Subtle grid overlay effect
            Positioned.fill(
              child: CustomPaint(
                painter: _GridPainter(),
              ),
            ),

            // Foreground content
            Positioned.fill(child: widget.child),
          ],
        );
      },
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.015)
      ..strokeWidth = 1.0;

    const step = 60.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
