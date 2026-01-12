import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_colors.dart';

/// A beautiful gradient background with animated stars effect
class GradientBackground extends StatefulWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  State<GradientBackground> createState() => _GradientBackgroundState();
}

class _GradientBackgroundState extends State<GradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_StarData> _stars;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    // Generate star data once
    final random = math.Random(42);
    _stars = List.generate(20, (index) {
      return _StarData(
        left: random.nextDouble(),
        top: random.nextDouble(),
        size: 2 + random.nextDouble() * 4,
        opacity: random.nextDouble(),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: Stack(
        children: [
          // Animated stars overlay
          ..._stars.map((star) {
            return Positioned(
              left: star.left * size.width,
              top: star.top * size.height,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final opacity =
                      0.3 + (0.7 * _controller.value * star.opacity);
                  return Opacity(
                    opacity: opacity.clamp(0.0, 1.0),
                    child: Icon(
                      Icons.star,
                      size: star.size,
                      color: AppColors.white60,
                    ),
                  );
                },
              ),
            );
          }),
          // Main content
          widget.child,
        ],
      ),
    );
  }
}

/// Data class for star positions
class _StarData {
  final double left;
  final double top;
  final double size;
  final double opacity;

  const _StarData({
    required this.left,
    required this.top,
    required this.size,
    required this.opacity,
  });
}
