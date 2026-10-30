// lib/features/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../shared/widgets/app_bar_widget.dart';
import '../../shared/widgets/status_badge.dart';
import '../../shared/widgets/toast_widget.dart';
import '../settings/providers/settings_provider.dart';
import '../../data/models/settings_model.dart';
import 'providers/home_provider.dart';
import 'widgets/map_view.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final isArabic = settings.language == AppLanguage.arabic;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Map fills entire screen
          const Positioned.fill(child: MapView()),

          // App bar on top of map
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: MosqueFinderAppBar(
              title: isArabic ? 'الخريطة' : 'Map',
              actions: [
                AppBarNotificationButton(
                  onTap: () => showAppToast(context, isArabic ? 'لا توجد إشعارات جديدة' : 'No new notifications'),
                ),
              ],
            ),
          ),

          // Bottom mosque preview card
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _BottomMosqueCard(),
          ),
        ],
      ),
    );
  }
}

// ── Bottom Mosque Preview Card ────────────────────────────────────────────────
class _BottomMosqueCard extends ConsumerWidget {
  const _BottomMosqueCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);
    final mosque = homeState.selectedMosque;
    final settings = ref.watch(settingsProvider);
    final isArabic = settings.language == AppLanguage.arabic;

    if (mosque == null) return const SizedBox.shrink();

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, 0, AppSpacing.md, AppSpacing.sm),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceLowest,
            borderRadius: AppSpacing.cardRadius,
            boxShadow: [
              BoxShadow(
                color: AppColors.onSurface.withAlpha(20),
                blurRadius: 24,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StatusBadge(status: mosque.status, small: true),
                        const SizedBox(height: 4),
                        Text(
                          mosque.nameAr,
                          style: AppTextStyles.headlineSm,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.near_me, size: 14, color: AppColors.primary),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'على بُعد ${mosque.distanceText} • ${mosque.address}',
                                style: AppTextStyles.bodySm.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Prayer time mini card
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm, vertical: AppSpacing.xs + 2),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                    child: Column(
                      children: [
                        Text(
                          mosque.nextPrayerName,
                          style: AppTextStyles.labelSm.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          mosque.nextIqamaTime,
                          style: AppTextStyles.labelMd.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      label: isArabic ? 'الاتجاهات' : 'Directions',
                      icon: Icons.navigation_outlined,
                      isPrimary: true,
                      onTap: () => showAppToast(
                        context,
                        isArabic
                            ? 'جاري فتح مسار الملاحة لأقرب بوابة للمسجد...'
                            : 'Opening navigation...',
                        icon: Icons.navigation,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _ActionButton(
                    label: isArabic ? 'تفاصيل المسجد' : 'Details',
                    icon: Icons.info_outline,
                    isPrimary: false,
                    onTap: () => context.push('/mosque/${mosque.id}'),
                  ),
                ],
              ),
            ],
          ),
        ).animate().slideY(
              begin: 0.3,
              end: 0,
              duration: 400.ms,
              curve: Curves.easeOutCubic,
            ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 44,
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.primary : AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: AppTextStyles.labelLg.copyWith(
                color: isPrimary ? AppColors.onPrimary : AppColors.onSurface,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              icon,
              size: 16,
              color: isPrimary ? AppColors.onPrimary : AppColors.onSurface,
            ),
          ],
        ),
      ),
    );
  }
}
