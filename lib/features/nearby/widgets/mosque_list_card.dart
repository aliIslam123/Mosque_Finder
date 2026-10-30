// lib/features/nearby/widgets/mosque_list_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../../shared/widgets/toast_widget.dart';
import '../../../data/models/mosque_model.dart';
import '../../../data/models/settings_model.dart';
import '../../settings/providers/settings_provider.dart';
import '../../home/widgets/mosque_detail_sheet.dart';

class MosqueListCard extends ConsumerWidget {
  final MosqueModel mosque;

  const MosqueListCard({
    super.key,
    required this.mosque,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final isArabic = settings.language == AppLanguage.arabic;

    // Pick icon and colors based on status
    final (IconData statusIcon, Color iconColor, Color iconBg) = switch (mosque.status) {
      MosqueStatus.verified => (
          Icons.mosque_outlined,
          AppColors.verified,
          AppColors.verifiedBg,
        ),
      MosqueStatus.unverified => (
          Icons.mark_chat_read_outlined,
          AppColors.unverified,
          AppColors.unverifiedBg,
        ),
      MosqueStatus.flagged => (
          Icons.warning_amber_rounded,
          AppColors.flagged,
          AppColors.flaggedBg,
        ),
    };

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: AppSpacing.cardRadius,
        border: Border.all(color: AppColors.outlineVariant.withAlpha(80)),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppSpacing.cardRadius,
          onTap: () => showMosqueDetailSheet(context, mosque),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Mosque Status / Icon Box
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Icon(statusIcon, color: iconColor, size: 28),
                ),
                const SizedBox(width: AppSpacing.md),

                // Main Info Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and Status Badge
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              isArabic ? mosque.nameAr : mosque.nameEn,
                              style: AppTextStyles.headlineSm.copyWith(fontSize: 16),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          StatusBadge(status: mosque.status, small: true),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Distance & Address
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: AppColors.onSurfaceVariant,
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              '${mosque.distanceText} • ${mosque.address}',
                              style: AppTextStyles.bodySm.copyWith(
                                color: AppColors.onSurfaceVariant,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Tags: Next Iqama & Key Facility
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          // Iqama pill
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryMuted,
                              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.access_time_filled_rounded,
                                  size: 12,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isArabic
                                      ? 'إقامة الظهر: ${mosque.nextIqamaTime}'
                                      : 'Dhuhr: ${mosque.nextIqamaTime}',
                                  style: AppTextStyles.labelSm.copyWith(
                                    color: AppColors.primary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Women's prayer area if present
                          if (mosque.facilities.womenPrayerArea)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainer,
                                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.woman,
                                    size: 14,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    isArabic ? 'مصلى سيدات' : "Women's Area",
                                    style: AppTextStyles.labelSm.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else if (mosque.facilities.wuduFacilities)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainer,
                                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.water_drop_outlined,
                                    size: 12,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    isArabic ? 'ميضأة' : 'Wudu',
                                    style: AppTextStyles.labelSm.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: AppSpacing.sm),

                // Direction & Navigation Action Buttons
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Direction Shortcut Button
                    InkWell(
                      onTap: () {
                        showAppToast(
                          context,
                          isArabic
                              ? 'فتح تطبيق الخرائط للاتجاه نحو ${mosque.nameAr}...'
                              : 'Navigating to ${mosque.nameEn}...',
                          icon: Icons.navigation_rounded,
                        );
                      },
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        ),
                        child: const Icon(
                          Icons.directions_outlined,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Detail Chevron
                    InkWell(
                      onTap: () => context.push('/mosque/${mosque.id}'),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          isArabic
                              ? Icons.chevron_left_rounded
                              : Icons.chevron_right_rounded,
                          color: AppColors.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
