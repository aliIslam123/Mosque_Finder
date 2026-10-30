// lib/features/qibla/qibla_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/qibla_utils.dart';
import '../../shared/widgets/app_bar_widget.dart';
import '../../shared/widgets/toast_widget.dart';
import '../../data/models/settings_model.dart';
import '../settings/providers/settings_provider.dart';
import 'widgets/compass_widget.dart';

class QiblaScreen extends ConsumerStatefulWidget {
  const QiblaScreen({super.key});

  @override
  ConsumerState<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends ConsumerState<QiblaScreen> {
  // Mock current location: Cairo, Egypt
  static const double _cairoLat = 30.0444;
  static const double _cairoLng = 31.2357;

  late final double _qiblaBearing;
  double _currentHeading = 110.0; // Simulated heading

  @override
  void initState() {
    super.initState();
    _qiblaBearing = QiblaUtils.calculateQibla(
      _cairoLat,
      _cairoLng,
    );
  }

  bool get _isAligned => (_currentHeading - _qiblaBearing).abs() <= 3.0;

  void _triggerHapticIfAligned() {
    if (_isAligned) {
      HapticFeedback.mediumImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final isArabic = settings.language == AppLanguage.arabic;

    final diff = (_qiblaBearing - _currentHeading).round();
    final directionAdvice = diff == 0
        ? (isArabic ? 'أنت تواجه القبلة مباشرة' : 'Directly facing Qibla')
        : diff > 0
            ? (isArabic ? 'أدر الهاتف يميناً بمقدار $diff°' : 'Turn right by $diff°')
            : (isArabic
                ? 'أدر الهاتف يساراً بمقدار ${diff.abs()}°'
                : 'Turn left by ${diff.abs()}°');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: MosqueFinderAppBar(
        title: isArabic ? 'اتجاه القبلة' : 'Qibla Direction',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.onSurface),
            tooltip: isArabic ? 'إعادة ضبط المحاكاة' : 'Reset Simulation',
            onPressed: () {
              setState(() => _currentHeading = 110.0);
              showAppToast(
                context,
                isArabic ? 'تمت إعادة ضبط اتجاه البوصلة' : 'Compass heading reset',
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              // 1. Mandatory Phase 1 Demo Banner
              _buildDemoBanner(isArabic),
              const SizedBox(height: AppSpacing.md),

              // 2. Heading Degree & Alignment Badge
              _buildStatusHeader(isArabic, directionAdvice),
              const SizedBox(height: AppSpacing.xl),

              // 3. Central Compass
              Center(
                child: CompassWidget(
                  heading: _currentHeading,
                  qiblaBearing: _qiblaBearing,
                  isAligned: _isAligned,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // 4. Interactive Simulation Slider
              _buildSimulationSlider(isArabic),
              const SizedBox(height: AppSpacing.md),

              // 5. Quick Auto-Align Button
              _buildAutoAlignButton(isArabic),
              const SizedBox(height: AppSpacing.lg),

              // 6. Coordinates & Details Card
              _buildCoordinatesCard(isArabic),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDemoBanner(bool isArabic) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.unverifiedBg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.unverified.withAlpha(90)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.unverified,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? 'وضع المعاينة التفاعلي (Demo Mode)' : 'Interactive Demo Mode',
                  style: AppTextStyles.labelMd.copyWith(
                    color: AppColors.unverified,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  isArabic
                      ? 'الحساب دقيق من إحداثيات القاهرة. استخدم شريط التمرير بالأسفل لمحاكاة تدوير الهاتف واختبار التوجيه.'
                      : 'Accurate calculation for Cairo. Use slider below to simulate rotating your device.',
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusHeader(bool isArabic, String directionAdvice) {
    return Column(
      children: [
        // Heading Display
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '${_currentHeading.round()}°',
              style: AppTextStyles.displayLg.copyWith(
                fontWeight: FontWeight.bold,
                color: _isAligned ? AppColors.verified : AppColors.onSurface,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              isArabic ? 'الاتجاه الحالي' : 'Current Heading',
              style: AppTextStyles.labelMd.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),

        // Alignment Pill
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: _isAligned ? AppColors.verifiedBg : AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            border: Border.all(
              color: _isAligned ? AppColors.verified : Colors.transparent,
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _isAligned ? Icons.check_circle_rounded : Icons.explore_rounded,
                size: 16,
                color: _isAligned ? AppColors.verified : AppColors.primary,
              ),
              const SizedBox(width: 6),
              Text(
                directionAdvice,
                style: AppTextStyles.labelMd.copyWith(
                  color: _isAligned ? AppColors.verified : AppColors.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSimulationSlider(bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: AppSpacing.cardRadius,
        border: Border.all(color: AppColors.outlineVariant.withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isArabic ? 'محاكاة تدوير الهاتف يدوياً:' : 'Manual Rotation Simulation:',
                style: AppTextStyles.labelMd.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                '${_currentHeading.round()}° / 360°',
                style: AppTextStyles.labelSm.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Slider(
            value: _currentHeading,
            min: 0,
            max: 360,
            divisions: 360,
            activeColor: _isAligned ? AppColors.verified : AppColors.primary,
            inactiveColor: AppColors.surfaceContainer,
            onChanged: (val) {
              setState(() => _currentHeading = val);
              _triggerHapticIfAligned();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAutoAlignButton(bool isArabic) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: () {
          setState(() => _currentHeading = _qiblaBearing);
          HapticFeedback.heavyImpact();
          showAppToast(
            context,
            isArabic
                ? 'تمت المحاذاة مع القبلة بدقة 136°'
                : 'Aligned with Qibla at 136°',
            icon: Icons.check_circle_rounded,
          );
        },
        icon: const Icon(Icons.gps_fixed_rounded, size: 18),
        label: Text(
          isArabic ? 'محاذاة تلقائية مع القبلة (136°)' : 'Auto-align to Qibla (136°)',
          style: AppTextStyles.labelMd.copyWith(fontWeight: FontWeight.bold),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
        ),
      ),
    );
  }

  Widget _buildCoordinatesCard(bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: AppSpacing.cardRadius,
        border: Border.all(color: AppColors.outlineVariant.withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.my_location_rounded, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                isArabic ? 'بيانات الموقع والحساب الجغرافي' : 'Location & Geographic Calculation',
                style: AppTextStyles.headlineSm.copyWith(fontSize: 15),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildInfoRow(
            label: isArabic ? 'الموقع الحالي' : 'Current Location',
            value: isArabic ? 'القاهرة، مصر (30.04° N, 31.23° E)' : 'Cairo, Egypt (30.04° N, 31.23° E)',
          ),
          const Divider(height: 16),
          _buildInfoRow(
            label: isArabic ? 'الكعبة المشرفة' : 'Holy Kaaba',
            value: isArabic ? 'مكة المكرمة (21.42° N, 39.82° E)' : 'Makkah (21.42° N, 39.82° E)',
          ),
          const Divider(height: 16),
          _buildInfoRow(
            label: isArabic ? 'زاوية الانحراف المحسوبة' : 'Calculated Azimuth',
            value: '${_qiblaBearing.round()}° جنوب شرق (SE)',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
        ),
        Text(
          value,
          style: AppTextStyles.labelSm.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ),
      ],
    );
  }
}
