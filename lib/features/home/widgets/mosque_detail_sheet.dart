// lib/features/home/widgets/mosque_detail_sheet.dart
// Bottom sheet showing selected mosque details (used from HomeScreen & MapView)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../../shared/widgets/toast_widget.dart';
import '../../../data/models/mosque_model.dart';
import '../../../data/models/settings_model.dart';
import '../../settings/providers/settings_provider.dart';

/// Shows a draggable bottom sheet with mosque details
Future<void> showMosqueDetailSheet(
  BuildContext context,
  MosqueModel mosque,
) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => MosqueDetailSheet(mosque: mosque),
  );
}

class MosqueDetailSheet extends ConsumerWidget {
  final MosqueModel mosque;
  const MosqueDetailSheet({super.key, required this.mosque});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final isArabic = settings.language == AppLanguage.arabic;

    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.35,
      maxChildSize: 0.90,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surfaceLowest,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusXl),
            ),
          ),
          child: Column(
            children: [
              // Drag handle
              const _DragHandle(),
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    0,
                    AppSpacing.lg,
                    AppSpacing.xl,
                  ),
                  children: [
                    // Header
                    _SheetHeader(mosque: mosque, isArabic: isArabic),
                    const SizedBox(height: AppSpacing.lg),
                    // Facilities
                    _FacilitiesSection(mosque: mosque, isArabic: isArabic),
                    const SizedBox(height: AppSpacing.lg),
                    // Prayer times
                    _PrayerTimesSection(mosque: mosque, isArabic: isArabic),
                    const SizedBox(height: AppSpacing.lg),
                    // Iqama times
                    _IqamaTimesSection(mosque: mosque, isArabic: isArabic),
                    const SizedBox(height: AppSpacing.xl),
                    // Actions
                    _SheetActions(mosque: mosque, isArabic: isArabic),
                  ],
                ),
              ),
            ],
          ),
        ).animate().slideY(
              begin: 0.2,
              end: 0,
              duration: 350.ms,
              curve: Curves.easeOutCubic,
            );
      },
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Center(
        child: Container(
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.outline.withAlpha(80),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  final MosqueModel mosque;
  final bool isArabic;
  const _SheetHeader({required this.mosque, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StatusBadge(status: mosque.status, small: true),
              const SizedBox(height: AppSpacing.xs),
              Text(
                isArabic ? mosque.nameAr : mosque.nameEn,
                style: AppTextStyles.headlineMd,
              ),
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  Icon(Icons.location_on_outlined,
                      size: 14, color: AppColors.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      mosque.address,
                      style: AppTextStyles.bodySm
                          .copyWith(color: AppColors.onSurfaceVariant),
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.near_me, size: 14, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(
                    '${isArabic ? "على بعد" : "Distance:"} ${mosque.distanceText}',
                    style: AppTextStyles.labelSm
                        .copyWith(color: AppColors.primary),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Community confirmations badge
        if (mosque.communityConfirmations > 0)
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
            decoration: BoxDecoration(
              color: AppColors.verifiedBg,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Column(
              children: [
                Icon(Icons.people, size: 14, color: AppColors.verified),
                Text(
                  '${mosque.communityConfirmations}',
                  style: AppTextStyles.labelSm
                      .copyWith(color: AppColors.verified),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _FacilitiesSection extends StatelessWidget {
  final MosqueModel mosque;
  final bool isArabic;
  const _FacilitiesSection({required this.mosque, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    final f = mosque.facilities;
    final facilities = [
      (Icons.woman, isArabic ? 'مصلى سيدات' : "Women's Area", f.womenPrayerArea),
      (Icons.water_drop_outlined, isArabic ? 'وضوء' : 'Wudu', f.wuduFacilities),
      (Icons.local_parking, isArabic ? 'موقف' : 'Parking', f.parking),
      (Icons.accessible, isArabic ? 'ذوو احتياجات' : 'Accessible', f.wheelchairAccess),
      (Icons.ac_unit, isArabic ? 'تكييف' : 'AC', f.airConditioning),
      (Icons.library_books_outlined, isArabic ? 'مكتبة' : 'Library', f.library),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? 'المرافق' : 'Facilities',
          style: AppTextStyles.labelLg.copyWith(color: AppColors.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: facilities.map((fac) {
            final available = fac.$3;
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: available
                    ? AppColors.verifiedBg
                    : AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    fac.$1,
                    size: 14,
                    color: available
                        ? AppColors.verified
                        : AppColors.onSurfaceVariant.withAlpha(100),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    fac.$2,
                    style: AppTextStyles.labelSm.copyWith(
                      color: available
                          ? AppColors.verified
                          : AppColors.onSurfaceVariant.withAlpha(100),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _PrayerTimesSection extends StatelessWidget {
  final MosqueModel mosque;
  final bool isArabic;
  const _PrayerTimesSection({required this.mosque, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    final pt = mosque.prayerTimes;
    final prayers = [
      (isArabic ? 'الفجر' : 'Fajr', pt.fajr),
      (isArabic ? 'الشروق' : 'Sunrise', pt.sunrise),
      (isArabic ? 'الظهر' : 'Dhuhr', pt.dhuhr),
      (isArabic ? 'العصر' : 'Asr', pt.asr),
      (isArabic ? 'المغرب' : 'Maghrib', pt.maghrib),
      (isArabic ? 'العشاء' : 'Isha', pt.isha),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? 'أوقات الصلاة' : 'Prayer Times',
          style: AppTextStyles.labelLg.copyWith(color: AppColors.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Row(
            children: prayers.map((p) {
              final isLast = p == prayers.last;
              return Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  decoration: BoxDecoration(
                    border: isLast
                        ? null
                        : Border(
                            right: isArabic
                                ? BorderSide.none
                                : BorderSide(
                                    color: AppColors.outline.withAlpha(50)),
                            left: isArabic
                                ? BorderSide(
                                    color: AppColors.outline.withAlpha(50))
                                : BorderSide.none,
                          ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        p.$1,
                        style: AppTextStyles.labelSm.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        p.$2,
                        style: AppTextStyles.labelSm.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _IqamaTimesSection extends StatelessWidget {
  final MosqueModel mosque;
  final bool isArabic;
  const _IqamaTimesSection({required this.mosque, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    final iq = mosque.iqamaTimes;
    final prayers = [
      (isArabic ? 'الفجر' : 'Fajr', iq.fajr),
      (isArabic ? 'الظهر' : 'Dhuhr', iq.dhuhr),
      (isArabic ? 'العصر' : 'Asr', iq.asr),
      (isArabic ? 'المغرب' : 'Maghrib', iq.maghrib),
      (isArabic ? 'العشاء' : 'Isha', iq.isha),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              isArabic ? 'أوقات الإقامة' : 'Iqama Times',
              style: AppTextStyles.labelLg.copyWith(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(width: AppSpacing.xs),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primaryMuted,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                isArabic ? 'مجتمعية' : 'Community',
                style: AppTextStyles.labelSm.copyWith(
                  color: AppColors.primary,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          decoration: BoxDecoration(
            color: AppColors.primaryMuted,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Row(
            children: prayers.map((p) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: Column(
                    children: [
                      Text(
                        p.$1,
                        style: AppTextStyles.labelSm.copyWith(
                          color: AppColors.primary.withAlpha(160),
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        p.$2,
                        style: AppTextStyles.labelSm.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _SheetActions extends StatelessWidget {
  final MosqueModel mosque;
  final bool isArabic;
  const _SheetActions({required this.mosque, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Primary: Directions
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              showAppToast(
                context,
                isArabic ? 'فتح التنقل...' : 'Opening navigation...',
                icon: Icons.navigation,
              );
            },
            icon: const Icon(Icons.navigation_outlined, size: 18),
            label: Text(isArabic ? 'الاتجاهات' : 'Directions'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        // Secondary row
        Row(
          children: [
            Expanded(
              child: _SecondaryAction(
                icon: Icons.info_outline,
                label: isArabic ? 'التفاصيل' : 'Details',
                onTap: () {
                  Navigator.of(context).pop();
                  context.push('/mosque/${mosque.id}');
                },
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _SecondaryAction(
                icon: Icons.flag_outlined,
                label: isArabic ? 'إبلاغ' : 'Report',
                onTap: () {
                  Navigator.of(context).pop();
                  showAppToast(
                    context,
                    isArabic ? 'شكراً على إبلاغك' : 'Thank you for reporting',
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SecondaryAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _SecondaryAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: AppColors.onSurface),
            const SizedBox(width: 4),
            Text(label, style: AppTextStyles.labelMd),
          ],
        ),
      ),
    );
  }
}
