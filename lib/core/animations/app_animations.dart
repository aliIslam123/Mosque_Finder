// lib/core/animations/app_animations.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AppAnimations {
  AppAnimations._();

  // Durations
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 350);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration splash = Duration(milliseconds: 800);

  // Curves
  static const Curve standard = Curves.easeInOut;
  static const Curve decelerate = Curves.easeOutCubic;
  static const Curve accelerate = Curves.easeInCubic;
  static const Curve spring = Curves.elasticOut;
  static const Curve gentle = Curves.easeOutQuart;

  // ── Reusable animation extensions ────────────────────────────────────

  /// Fade in from bottom — used for list items, cards
  static Widget fadeSlideIn(
    Widget child, {
    Duration delay = Duration.zero,
    double offsetY = 24,
  }) {
    return child
        .animate(delay: delay)
        .fadeIn(duration: medium, curve: decelerate)
        .slideY(
          begin: offsetY / 100,
          end: 0,
          duration: medium,
          curve: decelerate,
        );
  }

  /// Scale pop — used for badges, markers
  static Widget scalePop(Widget child, {Duration delay = Duration.zero}) {
    return child
        .animate(delay: delay)
        .scale(begin: const Offset(0.8, 0.8), duration: medium, curve: spring);
  }

  /// Staggered list items
  static Widget staggered(Widget child, int index) {
    return child
        .animate(delay: Duration(milliseconds: 60 * index))
        .fadeIn(duration: medium, curve: decelerate)
        .slideX(begin: 0.05, end: 0, duration: medium, curve: decelerate);
  }
}

/// Pulse animation for GPS indicator
class PulseWidget extends StatefulWidget {
  final Widget child;
  final Color color;
  const PulseWidget({super.key, required this.child, required this.color});

  @override
  State<PulseWidget> createState() => _PulseWidgetState();
}

class _PulseWidgetState extends State<PulseWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _scale = Tween<double>(begin: 1.0, end: 2.2).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    _opacity = Tween<double>(begin: 0.6, end: 0.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) => Opacity(
            opacity: _opacity.value,
            child: Transform.scale(
              scale: _scale.value,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color,
                ),
              ),
            ),
          ),
        ),
        widget.child,
      ],
    );
  }
}
