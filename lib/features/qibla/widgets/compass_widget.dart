// lib/features/qibla/widgets/compass_widget.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class CompassWidget extends StatelessWidget {
  final double heading; // 0..360 (device heading)
  final double qiblaBearing; // 0..360 (target Kaaba direction)
  final bool isAligned; // whether heading aligns with qiblaBearing

  const CompassWidget({
    super.key,
    required this.heading,
    required this.qiblaBearing,
    required this.isAligned,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Dial Ring (rotates with negative heading)
          Transform.rotate(
            angle: -heading * (math.pi / 180),
            child: CustomPaint(
              size: const Size(280, 280),
              painter: _CompassDialPainter(isAligned: isAligned),
            ),
          ),

          // 2. Center Alignment Glow
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isAligned ? 120 : 100,
            height: isAligned ? 120 : 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isAligned
                  ? AppColors.verified.withAlpha(35)
                  : AppColors.primary.withAlpha(15),
              boxShadow: isAligned
                  ? [
                      BoxShadow(
                        color: AppColors.verified.withAlpha(60),
                        blurRadius: 30,
                        spreadRadius: 8,
                      ),
                    ]
                  : null,
            ),
          ),

          // 3. Kaaba Pointer Needle (points to qibla relative to heading)
          Transform.rotate(
            angle: (qiblaBearing - heading) * (math.pi / 180),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Kaaba Icon at the tip of the needle
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isAligned ? AppColors.verified : AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (isAligned ? AppColors.verified : AppColors.primary)
                            .withAlpha(90),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.crop_square_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
                // Needle Body
                Container(
                  width: 4,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        isAligned ? AppColors.verified : AppColors.primary,
                        Colors.transparent,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 70), // Center offset
              ],
            ),
          ),

          // 4. Center Hub Pin
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: isAligned ? AppColors.verified : AppColors.onSurface,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(40),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CompassDialPainter extends CustomPainter {
  final bool isAligned;

  _CompassDialPainter({required this.isAligned});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Outer Circle Ring
    final ringPaint = Paint()
      ..color = AppColors.outlineVariant.withAlpha(120)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, radius - 8, ringPaint);

    // Degree Ticks
    final tickPaint = Paint()
      ..color = AppColors.outlineVariant
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    final majorTickPaint = Paint()
      ..color = isAligned ? AppColors.verified : AppColors.onSurfaceVariant
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 360; i += 5) {
      final angle = (i - 90) * (math.pi / 180);
      final isMajor = i % 30 == 0;
      final isCardinal = i % 90 == 0;

      final tickLength = isCardinal ? 14.0 : (isMajor ? 9.0 : 5.0);
      final currentPaint = isCardinal || isMajor ? majorTickPaint : tickPaint;

      final outer = Offset(
        center.dx + (radius - 12) * math.cos(angle),
        center.dy + (radius - 12) * math.sin(angle),
      );
      final inner = Offset(
        center.dx + (radius - 12 - tickLength) * math.cos(angle),
        center.dy + (radius - 12 - tickLength) * math.sin(angle),
      );

      canvas.drawLine(inner, outer, currentPaint);
    }

    // Cardinal Labels (N, E, S, W / ش, ق, ج, غ)
    const cardinals = [
      ('N\nش', 0),
      ('E\nش', 90),
      ('S\nج', 180),
      ('W\nغ', 270),
    ];

    for (final c in cardinals) {
      final angle = (c.$2 - 90) * (math.pi / 180);
      final labelOffset = Offset(
        center.dx + (radius - 36) * math.cos(angle),
        center.dy + (radius - 36) * math.sin(angle),
      );

      final isNorth = c.$2 == 0;
      final textSpan = TextSpan(
        text: isNorth ? 'N' : (c.$2 == 90 ? 'E' : (c.$2 == 180 ? 'S' : 'W')),
        style: TextStyle(
          color: isNorth
              ? AppColors.flagged
              : AppColors.onSurface.withAlpha(200),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      );

      final tp = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(
        canvas,
        Offset(labelOffset.dx - tp.width / 2, labelOffset.dy - tp.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CompassDialPainter oldDelegate) {
    return oldDelegate.isAligned != isAligned;
  }
}
