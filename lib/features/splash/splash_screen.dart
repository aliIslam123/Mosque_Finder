// lib/features/splash/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/constants/app_spacing.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Ambient gradient orbs
          Positioned(
            top: -80,
            left: -60,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryFixed.withAlpha(80),
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0), duration: 4.seconds),
          ),
          Positioned(
            bottom: -40,
            right: -60,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondaryContainer.withAlpha(60),
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(begin: const Offset(1.0, 1.0), end: const Offset(0.8, 0.8), duration: 3.5.seconds),
          ),

          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                children: [
                  // Top bar handle
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.sm),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.outlineVariant,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Logo + Identity
                  Column(
                    children: [
                      // Mosque icon container
                      _MosqueLogo()
                          .animate()
                          .scale(
                            begin: const Offset(0.6, 0.6),
                            duration: 700.ms,
                            curve: Curves.elasticOut,
                            delay: 200.ms,
                          )
                          .fadeIn(duration: 400.ms, delay: 200.ms),

                      const SizedBox(height: AppSpacing.lg),

                      // App name
                      Text(
                        'Mosque Finder',
                        style: AppTextStyles.displayLg.copyWith(
                          color: AppColors.onSurface,
                          letterSpacing: -0.5,
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 500.ms, duration: 600.ms)
                          .slideY(begin: 0.3, end: 0, delay: 500.ms, duration: 600.ms, curve: Curves.easeOutCubic),

                      const SizedBox(height: AppSpacing.sm),

                      // Arabic tagline
                      Text(
                        'دليلك لمساجد ومصليات الحي',
                        style: AppTextStyles.bodyLg.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 700.ms, duration: 600.ms)
                          .slideY(begin: 0.2, end: 0, delay: 700.ms, duration: 600.ms, curve: Curves.easeOutCubic),

                      const SizedBox(height: AppSpacing.lg),

                      // Feature pills
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _FeaturePill(
                            icon: Icons.explore_outlined,
                            label: 'أقرب مسجد',
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          _FeaturePill(
                            icon: Icons.schedule_outlined,
                            label: 'أوقات الإقامة',
                          ),
                        ],
                      )
                          .animate()
                          .fadeIn(delay: 900.ms, duration: 600.ms)
                          .slideY(begin: 0.2, end: 0, delay: 900.ms, duration: 600.ms, curve: Curves.easeOutCubic),
                    ],
                  ),

                  const Spacer(),

                  // Bottom CTA
                  Column(
                    children: [
                      // Find Now button
                      _FindNowButton(
                        onTap: () => context.go('/home'),
                      )
                          .animate()
                          .fadeIn(delay: 1100.ms, duration: 600.ms)
                          .slideY(begin: 0.3, end: 0, delay: 1100.ms, duration: 600.ms, curve: Curves.easeOutCubic),

                      const SizedBox(height: AppSpacing.md),

                      // Version
                      Text(
                        'v1.0 • خدمة مجتمعية',
                        style: AppTextStyles.labelSm.copyWith(
                          color: AppColors.outline,
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 1300.ms, duration: 400.ms),

                      const SizedBox(height: AppSpacing.lg),
                    ],
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

class _MosqueLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Ripple halo
        Container(
          width: 128,
          height: 128,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryFixed.withAlpha(80),
          ),
        ),
        // Main icon container
        Container(
          width: 104,
          height: 104,
          decoration: BoxDecoration(
            color: AppColors.surfaceLowest,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withAlpha(30),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: _MosqueSvgIcon(),
          ),
        ),
      ],
    );
  }
}

class _MosqueSvgIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(64, 64),
      painter: _MosquePainter(),
    );
  }
}

class _MosquePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = AppColors.primaryFixed.withAlpha(80)
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    // Dome
    final domePath = Path();
    domePath.moveTo(w * 0.5, h * 0.22);
    domePath.cubicTo(
      w * 0.25, h * 0.22,
      w * 0.1875, h * 0.42,
      w * 0.1875, h * 0.5,
    );
    domePath.lineTo(w * 0.8125, h * 0.5);
    domePath.cubicTo(
      w * 0.8125, h * 0.42,
      w * 0.75, h * 0.22,
      w * 0.5, h * 0.22,
    );
    canvas.drawPath(domePath, fillPaint);
    canvas.drawPath(domePath, paint);

    // Minaret left
    final lMin = Path();
    lMin.moveTo(w * 0.1875, h * 0.5);
    lMin.lineTo(w * 0.125, h * 0.5);
    lMin.lineTo(w * 0.125, h * 0.765);
    lMin.lineTo(w * 0.1875, h * 0.765);
    canvas.drawPath(lMin, paint);
    // Minaret top left
    final lTop = Path();
    lTop.moveTo(w * 0.125, h * 0.39);
    lTop.lineTo(w * 0.125, h * 0.5);
    lTop.lineTo(w * 0.1875, h * 0.5);
    lTop.lineTo(w * 0.1875, h * 0.39);
    lTop.close();
    canvas.drawPath(lTop, fillPaint);
    canvas.drawPath(lTop, paint);

    // Minaret right
    final rMin = Path();
    rMin.moveTo(w * 0.8125, h * 0.5);
    rMin.lineTo(w * 0.875, h * 0.5);
    rMin.lineTo(w * 0.875, h * 0.765);
    rMin.lineTo(w * 0.8125, h * 0.765);
    canvas.drawPath(rMin, paint);
    // Minaret top right
    final rTop = Path();
    rTop.moveTo(w * 0.875, h * 0.39);
    rTop.lineTo(w * 0.875, h * 0.5);
    rTop.lineTo(w * 0.8125, h * 0.5);
    rTop.lineTo(w * 0.8125, h * 0.39);
    rTop.close();
    canvas.drawPath(rTop, fillPaint);
    canvas.drawPath(rTop, paint);

    // Door arch
    final doorPath = Path();
    doorPath.moveTo(w * 0.375, h * 0.765);
    doorPath.lineTo(w * 0.375, h * 0.63);
    doorPath.arcToPoint(Offset(w * 0.625, h * 0.63),
        radius: Radius.circular(w * 0.125), clockwise: false);
    doorPath.lineTo(w * 0.625, h * 0.765);
    canvas.drawPath(doorPath, fillPaint);
    canvas.drawPath(doorPath, paint);

    // Base line
    canvas.drawLine(
      Offset(w * 0.125, h * 0.765),
      Offset(w * 0.875, h * 0.765),
      paint..strokeWidth = 2.2,
    );
    // Ground line
    paint.strokeWidth = 1.8;
    canvas.drawLine(
      Offset(w * 0.125, h * 0.844),
      Offset(w * 0.875, h * 0.844),
      paint,
    );

    // Minaret spire (dot)
    canvas.drawCircle(
      Offset(w * 0.5, h * 0.156),
      w * 0.047,
      Paint()..color = AppColors.primary,
    );
    canvas.drawLine(
      Offset(w * 0.5, h * 0.156 + w * 0.047),
      Offset(w * 0.5, h * 0.22),
      paint..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FeaturePill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeaturePill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: AppSpacing.badgeRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.secondary),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.labelMd.copyWith(color: AppColors.secondary),
          ),
        ],
      ),
    );
  }
}

class _FindNowButton extends StatefulWidget {
  final VoidCallback onTap;
  const _FindNowButton({required this.onTap});

  @override
  State<_FindNowButton> createState() => _FindNowButtonState();
}

class _FindNowButtonState extends State<_FindNowButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.95,
      upperBound: 1.0,
    )..value = 1.0;
    _scale = _ctrl;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.reverse(),
      onTapUp: (_) {
        _ctrl.forward();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.forward(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: double.infinity,
          height: AppSpacing.buttonHeight + 8,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withAlpha(64),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Find Now',
                style: AppTextStyles.headlineSm.copyWith(
                  color: AppColors.onPrimary,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              const Icon(
                Icons.arrow_back,
                color: AppColors.onPrimary,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
