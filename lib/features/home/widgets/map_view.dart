// lib/features/home/widgets/map_view.dart
// This is the Phase 1 mock map implementation.
// Phase 2: Replace with google_maps_flutter GoogleMap widget.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../shared/widgets/toast_widget.dart';
import '../../../data/models/mosque_model.dart';
import '../../settings/providers/settings_provider.dart';
import '../../../data/models/settings_model.dart';
import '../providers/home_provider.dart';

/// DEMO MAP — Phase 1 placeholder.
/// Renders an SVG-style vector map with interactive mosque markers.
/// Replace with GoogleMap in Phase 2.
class MapView extends ConsumerStatefulWidget {
  const MapView({super.key});

  @override
  ConsumerState<MapView> createState() => _MapViewState();
}

class _MapViewState extends ConsumerState<MapView>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeProvider);
    final settings = ref.watch(settingsProvider);
    final isArabic = settings.language == AppLanguage.arabic;

    return Stack(
      children: [
        // ── Background map canvas ──────────────────────────────────────
        Positioned.fill(
          child: CustomPaint(
            painter: _MockMapPainter(),
          ),
        ),

        // ── Exploration radius circle ──────────────────────────────────
        Center(
          child: _ExplorationCircle(
            radiusMeters: homeState.radiusMeters,
          ),
        ),

        // ── User location indicator ────────────────────────────────────
        Center(
          child: _UserLocationPin(controller: _pulseCtrl),
        ),

        // ── Mosque markers ─────────────────────────────────────────────
        ...homeState.nearbyMosques.asMap().entries.map((entry) {
          final i = entry.key;
          final mosque = entry.value;
          return _MosqueMarkerPositioned(
            mosque: mosque,
            index: i,
            isSelected: homeState.selectedMosque?.id == mosque.id,
            onTap: () => ref.read(homeProvider.notifier).selectMosque(mosque),
          );
        }),

        // ── Floating controls ─────────────────────────────────────────
        Positioned(
          top: AppSpacing.appBarHeight + AppSpacing.md + 10,
          left: AppSpacing.md,
          child: Column(
            children: [
              _MapFab(
                icon: Icons.my_location,
                color: AppColors.primary,
                onTap: () => showAppToast(
                  context,
                  isArabic ? 'تمت إعادة تمركز الخريطة حول موقعك' : 'Recentered to your location',
                  icon: Icons.my_location,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              _MapFab(
                icon: Icons.layers_outlined,
                onTap: () => showAppToast(
                  context,
                  isArabic ? 'تغيير طبقة الخريطة' : 'Change map layer',
                ),
              ),
            ],
          ),
        ),

        // ── Add mosque button ──────────────────────────────────────────
        Positioned(
          top: AppSpacing.appBarHeight + AppSpacing.md + 10,
          right: AppSpacing.md,
          child: _AddMosqueButton(
            label: isArabic ? 'إضافة مسجد' : 'Add Mosque',
            onTap: () => showAppToast(
              context,
              isArabic ? 'انقر على الخريطة لتحديد موقع المسجد الجديد' : 'Tap map to add a mosque',
              icon: Icons.add_location_alt_outlined,
            ),
          ),
        ),

        // ── Top control bar (radius + qibla) ──────────────────────────
        Positioned(
          top: AppSpacing.appBarHeight + AppSpacing.md + 10 + 44 + AppSpacing.sm + 44 + AppSpacing.md,
          left: AppSpacing.md,
          right: AppSpacing.md,
          child: _MapTopBar(isArabic: isArabic),
        ),

        // ── Demo label ────────────────────────────────────────────────
        Positioned(
          top: AppSpacing.appBarHeight + AppSpacing.sm,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.tertiaryFixed.withAlpha(200),
                borderRadius: AppSpacing.badgeRadius,
              ),
              child: Text(
                isArabic ? '🗺️ خريطة تجريبية — المرحلة الأولى' : '🗺️ Demo Map — Phase 1',
                style: AppTextStyles.labelSm.copyWith(
                  color: AppColors.onTertiaryFixedVariant,
                ),
              ),
            ).animate().fadeIn(delay: 1.seconds),
          ),
        ),
      ],
    );
  }
}

// ── Mock Map Painter ──────────────────────────────────────────────────────────
class _MockMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      Paint()..color = const Color(0xFFEAF3EC),
    );

    final roadPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Parks
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.1, h * 0.12)
        ..quadraticBezierTo(w * 0.22, h * 0.09, w * 0.27, h * 0.16)
        ..quadraticBezierTo(w * 0.2, h * 0.25, w * 0.1, h * 0.12),
      Paint()..color = const Color(0xFFDDF3E4),
    );

    canvas.drawRect(
      Rect.fromLTWH(w * 0.55, h * 0.12, w * 0.17, h * 0.07),
      Paint()
        ..color = const Color(0xFFD8EEDF)
        ..style = PaintingStyle.fill,
    );

    // Main roads
    roadPaint.strokeWidth = 14;
    canvas.drawLine(Offset(w * 0.15, 0), Offset(w * 0.35, h), roadPaint);
    canvas.drawLine(Offset(w * 0.57, 0), Offset(w * 0.65, h), roadPaint);
    roadPaint.strokeWidth = 12;
    canvas.drawLine(Offset(w * 0.9, h * 0.06), Offset(w * 0.8, h), roadPaint);
    canvas.drawLine(Offset(w * 0.27, h * 0.26), Offset(w * 0.8, h * 0.47), roadPaint);

    // Secondary roads
    roadPaint.strokeWidth = 9;
    canvas.drawLine(Offset(0, h * 0.18), Offset(w, h * 0.2), roadPaint);
    canvas.drawLine(Offset(0, h * 0.38), Offset(w, h * 0.35), roadPaint);
    canvas.drawLine(Offset(0, h * 0.57), Offset(w, h * 0.6), roadPaint);
    canvas.drawLine(Offset(0, h * 0.78), Offset(w, h * 0.75), roadPaint);

    // Street labels
    final textStyle = TextStyle(
      color: const Color(0xFF6F7A71),
      fontSize: 9,
      fontWeight: FontWeight.w600,
      fontFamily: 'IBMPlexSansArabic',
    );
    _drawText(canvas, 'شارع ٩ - المعادي', w * 0.18, h * 0.5, textStyle, angle: 1.37);
    _drawText(canvas, 'شارع النصر', w * 0.65, h * 0.62, textStyle);
    _drawText(canvas, 'ميدان فيكتوريا', w * 0.48, h * 0.36, textStyle);
    _drawText(canvas, 'كورنيش النيل', w * 0.03, h * 0.56, textStyle);

    // Buildings
    _drawBlock(canvas, w * 0.2, h * 0.22, w * 0.1, h * 0.1);
    _drawBlock(canvas, w * 0.38, h * 0.22, w * 0.15, h * 0.13);
    _drawBlock(canvas, w * 0.37, h * 0.4, w * 0.21, h * 0.15);
    _drawBlock(canvas, w * 0.61, h * 0.22, w * 0.16, h * 0.09);
    _drawBlock(canvas, w * 0.62, h * 0.56, w * 0.17, h * 0.12);
  }

  void _drawText(Canvas canvas, String text, double x, double y,
      TextStyle style, {double angle = 0}) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.rtl,
    )..layout();
    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(angle);
    tp.paint(canvas, Offset.zero);
    canvas.restore();
  }

  void _drawBlock(Canvas canvas, double x, double y, double w, double h) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, w, h),
        const Radius.circular(6),
      ),
      Paint()..color = const Color(0xFFE1EFE4),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── User Location Pin ─────────────────────────────────────────────────────────
class _UserLocationPin extends StatelessWidget {
  final AnimationController controller;
  const _UserLocationPin({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: controller,
            builder: (_, __) => Opacity(
              opacity: (1 - controller.value) * 0.7,
              child: Transform.scale(
                scale: 1 + controller.value * 1.2,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withAlpha(80),
            ),
          ),
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
              border: Border.all(color: AppColors.surfaceLowest, width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withAlpha(80),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Exploration Circle ────────────────────────────────────────────────────────
class _ExplorationCircle extends StatelessWidget {
  final double radiusMeters;
  const _ExplorationCircle({required this.radiusMeters});

  double get _visualSize {
    if (radiusMeters <= 200) return 160;
    if (radiusMeters <= 400) return 240;
    return 320;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      width: _visualSize,
      height: _visualSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.secondary.withAlpha(20),
        border: Border.all(
          color: AppColors.primary,
          width: 1.5,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.surfaceLowest.withAlpha(230),
              borderRadius: AppSpacing.badgeRadius,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(12),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Text(
              'نطاق الاستكشاف: ${radiusMeters.round()} م',
              style: AppTextStyles.labelSm.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Mosque Marker ─────────────────────────────────────────────────────────────
class _MosqueMarkerPositioned extends StatelessWidget {
  final MosqueModel mosque;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;

  const _MosqueMarkerPositioned({
    required this.mosque,
    required this.index,
    required this.isSelected,
    required this.onTap,
  });

  Offset _getOffset(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Position markers around center for demo
    final positions = [
      Offset(size.width * 0.32, size.height * 0.42),
      Offset(size.width * 0.68, size.height * 0.30),
      Offset(size.width * 0.22, size.height * 0.60),
      Offset(size.width * 0.70, size.height * 0.55),
      Offset(size.width * 0.50, size.height * 0.25),
      Offset(size.width * 0.15, size.height * 0.35),
      Offset(size.width * 0.80, size.height * 0.42),
      Offset(size.width * 0.42, size.height * 0.65),
      Offset(size.width * 0.60, size.height * 0.70),
      Offset(size.width * 0.30, size.height * 0.72),
    ];
    return positions[index % positions.length];
  }

  Color get _markerColor {
    switch (mosque.status) {
      case MosqueStatus.verified:
        return AppColors.verifiedGreen;
      case MosqueStatus.unverified:
        return AppColors.unverifiedAmber;
      case MosqueStatus.flagged:
        return AppColors.flaggedRed;
    }
  }

  @override
  Widget build(BuildContext context) {
    final offset = _getOffset(context);

    return Positioned(
      left: offset.dx - 18,
      top: offset.dy - 44,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            // Label
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.surfaceLowest,
                borderRadius: AppSpacing.badgeRadius,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 6,
                  ),
                ],
                border: Border.all(
                  color: isSelected ? _markerColor : AppColors.surfaceHigh,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    mosque.status == MosqueStatus.verified
                        ? Icons.verified_outlined
                        : mosque.status == MosqueStatus.unverified
                            ? Icons.help_outline
                            : Icons.report_outlined,
                    size: 10,
                    color: _markerColor,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    mosque.nameAr,
                    style: AppTextStyles.labelSm.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),
            // Marker pin
            AnimatedScale(
              scale: isSelected ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: _PinShape(color: _markerColor),
            ),
          ],
        ),
      ).animate(delay: Duration(milliseconds: 100 * index))
        .fadeIn(duration: 300.ms)
        .slideY(begin: -0.3, end: 0, duration: 300.ms, curve: Curves.easeOut),
    );
  }
}

class _PinShape extends StatelessWidget {
  final Color color;
  const _PinShape({required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(32, 40),
      painter: _PinPainter(color: color),
    );
  }
}

class _PinPainter extends CustomPainter {
  final Color color;
  const _PinPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()..color = color;
    final whitePaint = Paint()..color = Colors.white;

    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.arcToPoint(
      Offset(size.width, size.height * 0.41),
      radius: Radius.circular(size.width / 2),
    );
    path.arcToPoint(
      Offset(size.width / 2, size.height),
      radius: Radius.circular(size.height * 0.6),
      clockwise: false,
    );
    path.arcToPoint(
      Offset(0, size.height * 0.41),
      radius: Radius.circular(size.height * 0.6),
      clockwise: false,
    );
    path.arcToPoint(
      Offset(size.width / 2, 0),
      radius: Radius.circular(size.width / 2),
    );

    canvas.drawPath(path, fillPaint);
    canvas.drawCircle(
      Offset(size.width / 2, size.height * 0.41),
      size.width * 0.38,
      whitePaint,
    );
    canvas.drawPath(
      Path()
        ..addOval(Rect.fromCircle(
          center: Offset(size.width / 2, size.height * 0.41),
          radius: size.width * 0.22,
        )),
      Paint()
        ..style = PaintingStyle.stroke
        ..color = color
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(covariant _PinPainter old) => old.color != color;
}

// ── Map FAB ───────────────────────────────────────────────────────────────────
class _MapFab extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _MapFab({
    required this.icon,
    this.color = AppColors.onSurfaceVariant,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.surfaceLowest,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}

// ── Add Mosque Button ─────────────────────────────────────────────────────────
class _AddMosqueButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _AddMosqueButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: AppSpacing.badgeRadius,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withAlpha(60),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add_location_alt_outlined,
                size: 16, color: AppColors.onPrimary),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTextStyles.labelMd.copyWith(color: AppColors.onPrimary),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Map Top Bar (Radius + Qibla) ──────────────────────────────────────────────
class _MapTopBar extends ConsumerWidget {
  final bool isArabic;
  const _MapTopBar({required this.isArabic});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest.withAlpha(240),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        children: [
          // Radius pills
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _RadiusPill(
                  label: '٢٠٠ م',
                  meters: 200,
                  selected: homeState.radiusMeters == 200,
                  onTap: () => ref.read(homeProvider.notifier).setRadius(200),
                ),
                const SizedBox(width: 4),
                _RadiusPill(
                  label: '٤٠٠ م',
                  meters: 400,
                  selected: homeState.radiusMeters == 400,
                  onTap: () => ref.read(homeProvider.notifier).setRadius(400),
                ),
                const SizedBox(width: 4),
                _RadiusPill(
                  label: '٨٠٠ م',
                  meters: 800,
                  selected: homeState.radiusMeters == 800,
                  onTap: () => ref.read(homeProvider.notifier).setRadius(800),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Qibla shortcut
          GestureDetector(
            onTap: () {
              showAppToast(
                context,
                isArabic
                    ? 'اتجاه القبلة: ١٣٦° جنوب شرق (مكة المكرمة)'
                    : 'Qibla direction: 136° SE (Mecca)',
                icon: Icons.explore,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: AppSpacing.badgeRadius,
              ),
              child: Row(
                children: [
                  Text(isArabic ? 'القبلة' : 'Qibla',
                      style: AppTextStyles.labelSm),
                  const SizedBox(width: 4),
                  const Text('🧭', style: TextStyle(fontSize: 13)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RadiusPill extends StatelessWidget {
  final String label;
  final double meters;
  final bool selected;
  final VoidCallback onTap;

  const _RadiusPill({
    required this.label,
    required this.meters,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: AppSpacing.badgeRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.labelSm.copyWith(
            color: selected ? AppColors.onPrimary : AppColors.onSurfaceVariant,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
