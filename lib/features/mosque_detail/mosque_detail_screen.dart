// lib/features/mosque_detail/mosque_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../shared/widgets/status_badge.dart';
import '../../shared/widgets/toast_widget.dart';
import '../../data/datasources/local/mock_mosque_datasource.dart';
import '../../data/models/mosque_model.dart';
import '../../data/models/settings_model.dart';
import '../settings/providers/settings_provider.dart';
import '../nearby/providers/nearby_provider.dart';
import '../community/providers/community_provider.dart';

class MosqueDetailScreen extends ConsumerStatefulWidget {
  final String mosqueId;

  const MosqueDetailScreen({
    super.key,
    required this.mosqueId,
  });

  @override
  ConsumerState<MosqueDetailScreen> createState() => _MosqueDetailScreenState();
}

class _MosqueDetailScreenState extends ConsumerState<MosqueDetailScreen> {
  late MosqueModel _mosque;
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _loadMosque();
  }

  void _loadMosque() {
    final found = MockMosqueDataSource.getById(widget.mosqueId);
    if (found != null) {
      _mosque = found;
    } else {
      _mosque = MockMosqueDataSource.getAll().first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final isArabic = settings.language == AppLanguage.arabic;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Elegant Sliver App Bar with Header
          _buildSliverAppBar(context, isArabic),

          // Mosque Content Body
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title, Status, and Location Card
                  _buildHeaderCard(isArabic),
                  const SizedBox(height: AppSpacing.md),

                  // Primary Action Buttons (Navigate, Share, Confirm)
                  _buildActionButtons(isArabic),
                  const SizedBox(height: AppSpacing.lg),

                  // Facilities Section
                  _buildFacilitiesCard(isArabic),
                  const SizedBox(height: AppSpacing.lg),

                  // Prayer Times Card
                  _buildPrayerTimesCard(isArabic),
                  const SizedBox(height: AppSpacing.lg),

                  // Iqama Times Card
                  _buildIqamaTimesCard(isArabic),
                  const SizedBox(height: AppSpacing.lg),

                  // Community Verification Card
                  _buildCommunityCard(isArabic),
                  const SizedBox(height: AppSpacing.lg),

                  // Report or Suggest Update Section
                  _buildReportCard(isArabic),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, bool isArabic) {
    return SliverAppBar(
      expandedHeight: 180,
      pinned: true,
      elevation: 0,
      backgroundColor: AppColors.primary,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(220),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isArabic ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_new_rounded,
            color: AppColors.onSurface,
            size: 16,
          ),
        ),
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/nearby');
          }
        },
      ),
      actions: [
        // Bookmark button
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(220),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
              color: _isBookmarked ? AppColors.primary : AppColors.onSurface,
              size: 20,
            ),
          ),
          onPressed: () {
            setState(() => _isBookmarked = !_isBookmarked);
            showAppToast(
              context,
              _isBookmarked
                  ? (isArabic ? 'تمت إضافة المسجد للمفضلة' : 'Saved to favorites')
                  : (isArabic ? 'تمت الإزالة من المفضلة' : 'Removed from favorites'),
              icon: _isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
            );
          },
        ),
        // Share button
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(220),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.share_outlined,
              color: AppColors.onSurface,
              size: 18,
            ),
          ),
          onPressed: () {
            Share.share(
              '${_mosque.nameAr}\n${_mosque.address}\nمستكشف المساجد - دليلك لمساجد الحي',
            );
          },
        ),
        const SizedBox(width: AppSpacing.xs),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Gradient Background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    AppColors.primaryDark,
                    AppColors.primary,
                  ],
                ),
              ),
            ),
            // Decorative Mosque Silhouette Pattern
            Positioned(
              right: -30,
              bottom: -20,
              child: Opacity(
                opacity: 0.15,
                child: Icon(
                  Icons.mosque_rounded,
                  size: 220,
                  color: Colors.white,
                ),
              ),
            ),
            // Header Content
            Positioned(
              bottom: AppSpacing.lg,
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  StatusBadge(status: _mosque.status, small: true),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    isArabic ? _mosque.nameAr : _mosque.nameEn,
                    style: AppTextStyles.headlineLg.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: AppSpacing.cardRadius,
        border: Border.all(color: AppColors.outlineVariant.withAlpha(80)),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Address Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryMuted,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _mosque.neighborhood,
                      style: AppTextStyles.labelLg.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _mosque.address,
                      style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 24, thickness: 0.8),

          // Distance and Next Prayer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildHeaderStat(
                label: isArabic ? 'المسافة' : 'Distance',
                value: _mosque.distanceText,
                icon: Icons.near_me_rounded,
              ),
              Container(
                height: 30,
                width: 1,
                color: AppColors.outlineVariant.withAlpha(80),
              ),
              _buildHeaderStat(
                label: isArabic ? 'الصلاة القادمة' : 'Next Prayer',
                value: '${_mosque.nextPrayerName} (${_mosque.nextIqamaTime})',
                icon: Icons.access_time_filled_rounded,
              ),
              Container(
                height: 30,
                width: 1,
                color: AppColors.outlineVariant.withAlpha(80),
              ),
              _buildHeaderStat(
                label: isArabic ? 'تأكيدات' : 'Confirmed',
                value: '${_mosque.communityConfirmations}',
                icon: Icons.verified_user_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStat({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: AppColors.primary),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTextStyles.labelSm.copyWith(
                color: AppColors.onSurfaceVariant,
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: AppTextStyles.labelMd.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(bool isArabic) {
    return Column(
      children: [
        // Primary Directions Button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () {
              showAppToast(
                context,
                isArabic
                    ? 'جارٍ تشغيل تطبيق الملاحة للوصول إلى ${_mosque.nameAr}...'
                    : 'Opening navigation app for ${_mosque.nameEn}...',
                icon: Icons.navigation_rounded,
              );
            },
            icon: const Icon(Icons.navigation_rounded, size: 20),
            label: Text(
              isArabic ? 'الاتجاهات عبر الخرائط' : 'Directions with Maps',
              style: AppTextStyles.labelLg.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        // Secondary Row: Community Confirm & Suggest Edit
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _confirmMosque(isArabic),
                icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
                label: Text(
                  isArabic ? 'تأكيد صحة المسجد' : 'Confirm Mosque',
                  style: AppTextStyles.labelMd.copyWith(fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.verified,
                  side: const BorderSide(color: AppColors.verified, width: 1.2),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _showSuggestEditSheet(isArabic),
                icon: const Icon(Icons.edit_note_rounded, size: 20),
                label: Text(
                  isArabic ? 'اقتراح تعديل' : 'Suggest Edit',
                  style: AppTextStyles.labelMd.copyWith(fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.onSurface,
                  side: BorderSide(color: AppColors.outlineVariant.withAlpha(150)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFacilitiesCard(bool isArabic) {
    final f = _mosque.facilities;
    final facilitiesList = [
      (Icons.woman_rounded, isArabic ? 'مصلى سيدات' : "Women's Prayer Area", f.womenPrayerArea),
      (Icons.water_drop_rounded, isArabic ? 'أماكن وضوء مهيأة' : 'Wudu Facilities', f.wuduFacilities),
      (Icons.local_parking_rounded, isArabic ? 'مواقف سيارات' : 'Car Parking', f.parking),
      (Icons.accessible_rounded, isArabic ? 'تسهيلات ذوي الاحتياجات' : 'Wheelchair Access', f.wheelchairAccess),
      (Icons.ac_unit_rounded, isArabic ? 'تكييف هواء' : 'Air Conditioning', f.airConditioning),
      (Icons.library_books_rounded, isArabic ? 'مكتبة إسلامية' : 'Islamic Library', f.library),
    ];

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
              const Icon(Icons.check_box_outlined, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                isArabic ? 'المرافق والخدمات المتوفرة' : 'Available Facilities',
                style: AppTextStyles.headlineSm.copyWith(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              mainAxisExtent: 44,
            ),
            itemCount: facilitiesList.length,
            itemBuilder: (context, index) {
              final item = facilitiesList[index];
              final available = item.$3;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: available ? AppColors.verifiedBg : AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  border: Border.all(
                    color: available ? AppColors.verified.withAlpha(60) : Colors.transparent,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      item.$1,
                      size: 18,
                      color: available ? AppColors.verified : AppColors.onSurfaceVariant.withAlpha(120),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.$2,
                        style: AppTextStyles.labelSm.copyWith(
                          color: available ? AppColors.verified : AppColors.onSurfaceVariant.withAlpha(140),
                          fontWeight: available ? FontWeight.bold : FontWeight.normal,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (available)
                      const Icon(Icons.check_circle_rounded, size: 14, color: AppColors.verified),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerTimesCard(bool isArabic) {
    final pt = _mosque.prayerTimes;
    final prayers = [
      (isArabic ? 'الفجر' : 'Fajr', pt.fajr, Icons.nightlight_round),
      (isArabic ? 'الشروق' : 'Sunrise', pt.sunrise, Icons.wb_sunny_outlined),
      (isArabic ? 'الظهر' : 'Dhuhr', pt.dhuhr, Icons.wb_sunny_rounded),
      (isArabic ? 'العصر' : 'Asr', pt.asr, Icons.wb_twighlight),
      (isArabic ? 'المغرب' : 'Maghrib', pt.maghrib, Icons.nights_stay_outlined),
      (isArabic ? 'العشاء' : 'Isha', pt.isha, Icons.nights_stay_rounded),
    ];

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
              const Icon(Icons.schedule_rounded, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                isArabic ? 'مواقيت الأذان اليومية' : 'Daily Prayer Times',
                style: AppTextStyles.headlineSm.copyWith(fontSize: 16),
              ),
              const Spacer(),
              Text(
                isArabic ? 'حسب التوقيت المحلي' : 'Local Time',
                style: AppTextStyles.labelSm.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: prayers.map((p) {
              final isDhuhr = p.$1 == (isArabic ? 'الظهر' : 'Dhuhr');
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isDhuhr ? AppColors.primaryMuted : AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    border: isDhuhr
                        ? Border.all(color: AppColors.primary.withAlpha(120), width: 1.2)
                        : null,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        p.$3,
                        size: 14,
                        color: isDhuhr ? AppColors.primary : AppColors.onSurfaceVariant,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        p.$1,
                        style: AppTextStyles.labelSm.copyWith(
                          color: isDhuhr ? AppColors.primary : AppColors.onSurfaceVariant,
                          fontWeight: isDhuhr ? FontWeight.bold : FontWeight.normal,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        p.$2,
                        style: AppTextStyles.labelSm.copyWith(
                          color: isDhuhr ? AppColors.primary : AppColors.onSurface,
                          fontWeight: FontWeight.bold,
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
        ],
      ),
    );
  }

  Widget _buildIqamaTimesCard(bool isArabic) {
    final iq = _mosque.iqamaTimes;
    final iqamaList = [
      (isArabic ? 'الفجر' : 'Fajr', iq.fajr),
      (isArabic ? 'الظهر' : 'Dhuhr', iq.dhuhr),
      (isArabic ? 'العصر' : 'Asr', iq.asr),
      (isArabic ? 'المغرب' : 'Maghrib', iq.maghrib),
      (isArabic ? 'العشاء' : 'Isha', iq.isha),
    ];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withAlpha(50),
        borderRadius: AppSpacing.cardRadius,
        border: Border.all(color: AppColors.primary.withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.timer_outlined, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                isArabic ? 'مواقيت الإقامة الفعلية' : 'Actual Iqama Times',
                style: AppTextStyles.headlineSm.copyWith(
                  fontSize: 16,
                  color: AppColors.primary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
                child: Text(
                  isArabic ? 'موثقة مجتمعياً' : 'Community Verified',
                  style: AppTextStyles.labelSm.copyWith(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: iqamaList.map((item) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withAlpha(15),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        item.$1,
                        style: AppTextStyles.labelSm.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.$2,
                        style: AppTextStyles.labelSm.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityCard(bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: AppSpacing.cardRadius,
        border: Border.all(color: AppColors.outlineVariant.withAlpha(80)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.verifiedBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.people_alt_rounded, color: AppColors.verified, size: 24),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? 'موثوقية بيانات المسجد' : 'Mosque Reliability',
                  style: AppTextStyles.labelLg.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  isArabic
                      ? 'تم تأكيد مواقيت ومرافق هذا المسجد من ${_mosque.communityConfirmations} مصلين في الحي.'
                      : 'Confirmed by ${_mosque.communityConfirmations} neighborhood worshippers.',
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(bool isArabic) {
    return Center(
      child: TextButton.icon(
        onPressed: () => _showReportSheet(isArabic),
        icon: const Icon(Icons.flag_outlined, size: 16, color: AppColors.flagged),
        label: Text(
          isArabic ? 'الإبلاغ عن بيانات خاطئة أو غير دقيقة' : 'Report incorrect info',
          style: AppTextStyles.labelMd.copyWith(
            color: AppColors.flagged,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  void _confirmMosque(bool isArabic) {
    final settings = ref.read(settingsProvider);
    if (!settings.isProfileRegistered) {
      showAppToast(
        context,
        isArabic
            ? 'يرجى تسجيل بياناتك في صفحة المجتمع أولاً لتتمكن من تأكيد المساجد'
            : 'Please register in the Community tab first to confirm mosques',
        icon: Icons.lock_outline,
      );
      context.push('/profile');
      return;
    }
    ref.read(nearbyProvider.notifier).confirmMosque(_mosque.id);
    ref.read(communityProvider.notifier).submitConfirmation(_mosque.nameAr);
    setState(() {
      _mosque = _mosque.copyWith(
        status: MosqueStatus.verified,
        communityConfirmations: _mosque.communityConfirmations + 1,
      );
    });
    showAppToast(
      context,
      isArabic
          ? 'جزاك الله خيراً! تم تسجيل تأكيدك وحصلت على +10 نقاط مساهمة'
          : 'Thank you! Confirmation recorded (+10 points)',
      icon: Icons.check_circle_rounded,
    );
  }

  void _showSuggestEditSheet(bool isArabic) {
    final settings = ref.read(settingsProvider);
    if (!settings.isProfileRegistered) {
      showAppToast(
        context,
        isArabic
            ? 'يرجى تسجيل بياناتك أولاً لاقتراح تعديلات'
            : 'Please register in the Community tab first to suggest edits',
        icon: Icons.lock_outline,
      );
      context.push('/profile');
      return;
    }
    final noteController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.xl,
            top: AppSpacing.lg,
            left: AppSpacing.lg,
            right: AppSpacing.lg,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surfaceLowest,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.outline.withAlpha(80),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                isArabic ? 'اقتراح تعديل بيانات المسجد' : 'Suggest an Edit',
                style: AppTextStyles.headlineSm,
              ),
              const SizedBox(height: 4),
              Text(
                isArabic
                    ? 'أدخل التعديلات المقترحة (مثل تعديل مواقيت الإقامة أو إضافة مرافق)'
                    : 'Enter the proposed updates (e.g. iqama times, facilities)',
                style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: noteController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: isArabic ? 'اكتب ملاحظاتك هنا بالتفصيل...' : 'Write notes here...',
                  filled: true,
                  fillColor: AppColors.surfaceContainer,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    showAppToast(
                      context,
                      isArabic
                          ? 'شكراً لك! تم إرسال مقترحك لمراجعة المجتمع'
                          : 'Thank you! Edit suggestion submitted for review',
                      icon: Icons.check_circle_outline,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                  ),
                  child: Text(isArabic ? 'إرسال المقترح' : 'Submit Suggestion'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showReportSheet(bool isArabic) {
    final settings = ref.read(settingsProvider);
    if (!settings.isProfileRegistered) {
      showAppToast(
        context,
        isArabic
            ? 'يرجى تسجيل بياناتك أولاً لتقديم البلاغات'
            : 'Please register in the Community tab first to report',
        icon: Icons.lock_outline,
      );
      context.push('/profile');
      return;
    }
    int selectedReason = 0;
    final reasons = [
      isArabic ? 'المسجد مغلق نهائياً أو غير موجود' : 'Mosque is closed permanently or does not exist',
      isArabic ? 'مواقيت الإقامة غير صحيحة' : 'Iqama times are inaccurate',
      isArabic ? 'الموقع الجغرافي على الخريطة غير دقيق' : 'Map location is inaccurate',
      isArabic ? 'المرافق المذكورة غير متوفرة' : 'Listed facilities are unavailable',
      isArabic ? 'سبب آخر' : 'Other reason',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: const BoxDecoration(
                color: AppColors.surfaceLowest,
                borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.outline.withAlpha(80),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: AppColors.flagged),
                      const SizedBox(width: 8),
                      Text(
                        isArabic ? 'إبلاغ عن المسجد' : 'Report Mosque',
                        style: AppTextStyles.headlineSm,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ...List.generate(reasons.length, (i) {
                    final isSelected = selectedReason == i;
                    return InkWell(
                      onTap: () => setSheetState(() => selectedReason = i),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Icon(
                              isSelected
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.outlineVariant,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(reasons[i], style: AppTextStyles.bodyMd),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ref.read(communityProvider.notifier).submitReport(_mosque.nameAr);
                        showAppToast(
                          context,
                          isArabic
                              ? 'تم استلام بلاغك وسيقوم المشرفون بمراجعته'
                              : 'Report received and will be reviewed',
                          icon: Icons.check_circle_outline,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.flagged,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        ),
                      ),
                      child: Text(isArabic ? 'تأكيد البلاغ' : 'Confirm Report'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
