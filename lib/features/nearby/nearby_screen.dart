// lib/features/nearby/nearby_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../shared/widgets/app_bar_widget.dart';
import '../../shared/widgets/empty_state_widget.dart';
import '../../shared/widgets/toast_widget.dart';
import '../../data/models/mosque_model.dart';
import '../../data/models/settings_model.dart';
import '../settings/providers/settings_provider.dart';
import 'providers/nearby_provider.dart';
import 'widgets/mosque_list_card.dart';

class NearbyScreen extends ConsumerStatefulWidget {
  const NearbyScreen({super.key});

  @override
  ConsumerState<NearbyScreen> createState() => _NearbyScreenState();
}

class _NearbyScreenState extends ConsumerState<NearbyScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final nearbyState = ref.watch(nearbyProvider);
    final isArabic = settings.language == AppLanguage.arabic;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: MosqueFinderAppBar(
        title: isArabic ? 'المساجد' : 'Nearby',
        actions: [
          AppBarNotificationButton(
            onTap: () => showAppToast(
              context,
              isArabic ? 'لا توجد تنبيهات جديدة' : 'No new notifications',
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter header container
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceLowest,
              border: Border(
                bottom: BorderSide(
                  color: AppColors.outlineVariant.withAlpha(60),
                ),
              ),
            ),
            child: Column(
              children: [
                // 1. Search Bar
                _buildSearchBar(isArabic),
                const SizedBox(height: AppSpacing.sm),

                // 2. Search Radius Bar
                _buildRadiusBar(nearbyState, isArabic),
                const SizedBox(height: AppSpacing.sm),

                // 3. Status Filters Row
                _buildStatusFilters(nearbyState, isArabic),
                const SizedBox(height: AppSpacing.xs),

                // 4. State Preview Pills (Design Reference Feature)
                _buildStatePreviewBar(nearbyState, isArabic),
              ],
            ),
          ),

          // Main Content Area based on View State
          Expanded(
            child: _buildBody(nearbyState, isArabic),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isArabic) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (val) => ref.read(nearbyProvider.notifier).setSearch(val),
        decoration: InputDecoration(
          hintText: isArabic
              ? 'ابحث باسم المسجد أو الشارع...'
              : 'Search by mosque or street...',
          hintStyle: AppTextStyles.bodyMd.copyWith(
            color: AppColors.onSurfaceVariant,
            fontSize: 14,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.onSurfaceVariant,
            size: 20,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    ref.read(nearbyProvider.notifier).setSearch('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildRadiusBar(NearbyState state, bool isArabic) {
    const radiusOptions = [200.0, 400.0, 800.0];

    return Row(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.radar_rounded, size: 16, color: AppColors.primary),
            const SizedBox(width: 4),
            Text(
              isArabic ? 'النطاق:' : 'Radius:',
              style: AppTextStyles.labelMd.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: radiusOptions.map((r) {
              final isSelected = (state.radiusMeters - r).abs() < 1;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: GestureDetector(
                    onTap: () => ref.read(nearbyProvider.notifier).setRadius(r),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.surfaceContainer,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusFull),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        isArabic ? '${r.toInt()} م' : '${r.toInt()}m',
                        style: AppTextStyles.labelSm.copyWith(
                          color: isSelected
                              ? AppColors.onPrimary
                              : AppColors.onSurfaceVariant,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusFilters(NearbyState state, bool isArabic) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          // All Filter
          _buildFilterChip(
            label: isArabic
                ? 'الكل ${state.allMosques.length}'
                : 'All ${state.allMosques.length}',
            isSelected: state.statusFilter == null,
            icon: Icons.tune_rounded,
            onTap: () => ref.read(nearbyProvider.notifier).setStatusFilter(null),
          ),
          const SizedBox(width: 6),

          // Verified Filter
          _buildFilterChip(
            label: isArabic ? 'موثّق مجتمعياً' : 'Verified',
            isSelected: state.statusFilter == MosqueStatus.verified,
            dotColor: AppColors.verified,
            onTap: () => ref
                .read(nearbyProvider.notifier)
                .setStatusFilter(MosqueStatus.verified),
          ),
          const SizedBox(width: 6),

          // Unverified Filter
          _buildFilterChip(
            label: isArabic ? 'غير متحقق منه' : 'Unverified',
            isSelected: state.statusFilter == MosqueStatus.unverified,
            dotColor: AppColors.unverified,
            onTap: () => ref
                .read(nearbyProvider.notifier)
                .setStatusFilter(MosqueStatus.unverified),
          ),
          const SizedBox(width: 6),

          // Flagged Filter
          _buildFilterChip(
            label: isArabic ? 'مشكوك في تواجده' : 'Flagged',
            isSelected: state.statusFilter == MosqueStatus.flagged,
            dotColor: AppColors.flagged,
            onTap: () => ref
                .read(nearbyProvider.notifier)
                .setStatusFilter(MosqueStatus.flagged),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    IconData? icon,
    Color? dotColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.outlineVariant.withAlpha(50),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 13,
                color: isSelected ? AppColors.onPrimary : AppColors.onSurface,
              ),
              const SizedBox(width: 4),
            ] else if (dotColor != null) ...[
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.onPrimary : dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: AppTextStyles.labelSm.copyWith(
                color: isSelected ? AppColors.onPrimary : AppColors.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatePreviewBar(NearbyState state, bool isArabic) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(
            Icons.play_circle_outline_rounded,
            size: 14,
            color: AppColors.onSurfaceVariant.withAlpha(160),
          ),
          const SizedBox(width: 4),
          Text(
            isArabic ? 'معاينة الحالات:' : 'Preview states:',
            style: AppTextStyles.labelSm.copyWith(
              color: AppColors.onSurfaceVariant.withAlpha(160),
              fontSize: 10,
            ),
          ),
          const Spacer(),
          _buildPreviewPill(
            title: isArabic ? 'القائمة' : 'List',
            isActive: state.view == NearbyView.list,
            onTap: () =>
                ref.read(nearbyProvider.notifier).setView(NearbyView.list),
          ),
          const SizedBox(width: 4),
          _buildPreviewPill(
            title: isArabic ? 'فراغ' : 'Empty',
            isActive: state.view == NearbyView.empty,
            onTap: () =>
                ref.read(nearbyProvider.notifier).setView(NearbyView.empty),
          ),
          const SizedBox(width: 4),
          _buildPreviewPill(
            title: isArabic ? 'إذن الموقع' : 'Permission',
            isActive: state.view == NearbyView.locationPermission,
            onTap: () => ref
                .read(nearbyProvider.notifier)
                .setView(NearbyView.locationPermission),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewPill({
    required String title,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primaryMuted
              : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isActive ? AppColors.primary : Colors.transparent,
            width: 0.8,
          ),
        ),
        child: Text(
          title,
          style: AppTextStyles.labelSm.copyWith(
            color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
            fontSize: 10,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(NearbyState state, bool isArabic) {
    switch (state.view) {
      case NearbyView.empty:
        return Center(
          child: EmptyStateWidget(
            icon: Icons.mosque_outlined,
            title: isArabic ? 'لا توجد مساجد' : 'No Mosques Found',
            message: isArabic
                ? 'لم يتم العثور على مساجد في نطاق ${state.radiusMeters.toInt()} م. جرّب توسيع النطاق.'
                : 'No mosques found within ${state.radiusMeters.toInt()}m. Try expanding your search radius.',
            actionLabel: isArabic ? 'توسيع النطاق إلى 800 م' : 'Expand to 800m',
            onAction: () =>
                ref.read(nearbyProvider.notifier).setRadius(800.0),
          ),
        );

      case NearbyView.locationPermission:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primaryMuted,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.location_off_rounded,
                    size: 40,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  isArabic
                      ? 'مطلوب إذن الموقع الجغرافي'
                      : 'Location Permission Needed',
                  style: AppTextStyles.headlineSm,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  isArabic
                      ? 'يحتاج مستكشف المساجد لتحديد موقعك لعرض أقرب المساجد ومواقيت الصلاة الدقيقة.'
                      : 'Mosque Finder needs your location to display the nearest mosques and accurate prayer times.',
                  style: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ref
                          .read(nearbyProvider.notifier)
                          .setView(NearbyView.list);
                      showAppToast(
                        context,
                        isArabic
                            ? 'تم تفعيل الموقع بنجاح'
                            : 'Location enabled successfully',
                        icon: Icons.check_circle_outline,
                      );
                    },
                    icon: const Icon(Icons.my_location_rounded, size: 18),
                    label: Text(
                      isArabic ? 'تفعيل إذن الموقع' : 'Enable Location',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

      case NearbyView.list:
        final mosques = state.filteredMosques;
        if (mosques.isEmpty) {
          return Center(
            child: EmptyStateWidget(
              icon: Icons.search_off_rounded,
              title: isArabic ? 'لا توجد نتائج' : 'No Results Found',
              message: isArabic
                  ? 'لم نجد مساجد مطابقة لبحثك الحالي. حاول تعديل كلمات البحث أو الفلاتر.'
                  : 'We could not find any mosques matching your current search or filters.',
              actionLabel: isArabic ? 'إعادة ضبط الفلاتر' : 'Reset Filters',
              onAction: () {
                _searchController.clear();
                ref.read(nearbyProvider.notifier).setSearch('');
                ref.read(nearbyProvider.notifier).setStatusFilter(null);
                ref.read(nearbyProvider.notifier).setRadius(800.0);
              },
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: mosques.length,
          itemBuilder: (context, index) {
            final mosque = mosques[index];
            return MosqueListCard(mosque: mosque)
                .animate()
                .fadeIn(
                  delay: (index * 60).ms,
                  duration: 300.ms,
                )
                .slideY(
                  begin: 0.1,
                  end: 0,
                  delay: (index * 60).ms,
                  duration: 300.ms,
                  curve: Curves.easeOutCubic,
                );
          },
        );
    }
  }
}
