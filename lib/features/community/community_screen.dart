// lib/features/community/community_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../shared/widgets/app_bar_widget.dart';
import '../../shared/widgets/toast_widget.dart';
import '../../data/models/community_post_model.dart';
import '../../data/models/settings_model.dart';
import '../settings/providers/settings_provider.dart';
import 'providers/community_provider.dart';

class CommunityScreen extends ConsumerWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final communityState = ref.watch(communityProvider);
    final isArabic = settings.language == AppLanguage.arabic;
    final isRegistered = settings.isProfileRegistered;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: MosqueFinderAppBar(
        title: isArabic ? 'المجتمع' : 'Community',
        actions: [
          AppBarNotificationButton(
            onTap: () => showAppToast(
              context,
              isArabic ? 'لا توجد تنبيهات جديدة' : 'No new notifications',
            ),
          ),
        ],
      ),
      body: !isRegistered
          ? _RegistrationGateView(isArabic: isArabic)
          : ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                // 1. Contributor Profile Card
                _buildProfileCard(context, ref, settings, isArabic),
                const SizedBox(height: AppSpacing.lg),

                // 2. Section Header: Actions & Contributions
                _buildActionsHeader(isArabic),
                const SizedBox(height: AppSpacing.sm),

                // 3. Three Action Cards
                _buildActionCard(
                  context: context,
                  title: isArabic ? 'إضافة مسجد أو مصلى جديد' : 'Add New Mosque or Musalla',
                  subtitle: isArabic
                      ? 'شارك موقع مصلى أو مسجد غير موجود على الخريطة'
                      : 'Share location of a mosque not yet on the map',
                  pointsBadge: isArabic ? '+5 نقاط مساهمة' : '+5 Contribution Points',
                  icon: Icons.add_location_alt_outlined,
                  iconColor: AppColors.primary,
                  iconBg: AppColors.primaryMuted,
                  onTap: () => _showAddMosqueSheet(context, ref, isArabic),
                ),
                const SizedBox(height: AppSpacing.sm),

                _buildActionCard(
                  context: context,
                  title: isArabic ? 'تأكيد وجود مسجد قريب' : 'Confirm Nearby Mosque',
                  subtitle: isArabic
                      ? 'ساعد في التحقق من صحة المساجد المضافة حديثاً'
                      : 'Help verify newly added mosques and facilities',
                  pointsBadge: isArabic ? '+10 نقاط لكل توثيق' : '+10 Points Per Verification',
                  icon: Icons.verified_outlined,
                  iconColor: AppColors.verified,
                  iconBg: AppColors.verifiedBg,
                  onTap: () => _showConfirmMosqueSheet(context, ref, isArabic),
                ),
                const SizedBox(height: AppSpacing.sm),

                _buildActionCard(
                  context: context,
                  title: isArabic ? 'الإبلاغ عن مسجد أو بيانات غير دقيقة' : 'Report Inaccurate Data',
                  subtitle: isArabic
                      ? 'أبلغ عن مسجد مغلق، مكرر أو موقع غير صحيح'
                      : 'Report closed, duplicate or inaccurate mosque info',
                  pointsBadge: isArabic ? 'مراجعة سريعة من المشرفين' : 'Quick Moderator Review',
                  icon: Icons.warning_amber_rounded,
                  iconColor: AppColors.flagged,
                  iconBg: AppColors.flaggedBg,
                  onTap: () => _showReportSheet(context, ref, isArabic),
                ),
                const SizedBox(height: AppSpacing.xl),

                // 4. Section Header: Community Activity Feed
                _buildFeedHeader(isArabic),
                const SizedBox(height: AppSpacing.sm),

                // 5. Activity Feed Items
                ...communityState.activities.map((activity) {
                  return _buildFeedItem(activity, isArabic);
                }),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
    );
  }

  Widget _buildProfileCard(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
    bool isArabic,
  ) {
    final initialLetter = settings.contributorName.isNotEmpty
        ? settings.contributorName[0]
        : (isArabic ? 'م' : 'M');

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: AppSpacing.cardRadius,
        border: Border.all(color: AppColors.outlineVariant.withAlpha(80)),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withAlpha(8),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar with letter & checkmark
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryDark,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      initialLetter,
                      style: AppTextStyles.headlineSm.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      size: 16,
                      color: AppColors.verified,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: AppSpacing.md),

              // Name & Points
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          settings.contributorName,
                          style: AppTextStyles.headlineSm.copyWith(fontSize: 16),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.verified, size: 14, color: AppColors.verified),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.stars_rounded, size: 16, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          isArabic
                              ? '${settings.contributionPoints} نقطة مساهمة'
                              : '${settings.contributionPoints} Contribution Points',
                          style: AppTextStyles.labelSm.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Edit Name / Info Button
              GestureDetector(
                onTap: () => _showEditProfileSheet(context, ref, settings, isArabic),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryMuted,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.edit_outlined, size: 14, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        isArabic ? 'تعديل' : 'Edit',
                        style: AppTextStyles.labelSm.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const Divider(height: 16, thickness: 0.6),

          // User details summary row
          Row(
            children: [
              Icon(Icons.contact_phone_outlined, size: 14, color: AppColors.onSurfaceVariant),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${settings.phone} • ${settings.email}',
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionsHeader(bool isArabic) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          isArabic ? 'الإجراءات والمساهمات' : 'Actions & Contributions',
          style: AppTextStyles.headlineSm.copyWith(fontSize: 16),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.primaryMuted,
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.volunteer_activism_outlined, size: 12, color: AppColors.primary),
              const SizedBox(width: 4),
              Text(
                isArabic ? 'خدمة رواد المساجد' : 'Community Service',
                style: AppTextStyles.labelSm.copyWith(
                  color: AppColors.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String pointsBadge,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: AppSpacing.cardRadius,
        border: Border.all(color: AppColors.outlineVariant.withAlpha(80)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppSpacing.cardRadius,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                // Icon Box
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: AppSpacing.md),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.labelLg.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: AppTextStyles.bodySm.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.stars_rounded, size: 12, color: iconColor),
                          const SizedBox(width: 3),
                          Text(
                            pointsBadge,
                            style: AppTextStyles.labelSm.copyWith(
                              color: iconColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Arrow
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: AppColors.onSurfaceVariant.withAlpha(140),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeedHeader(bool isArabic) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          isArabic ? 'أحدث المساهمات المجتمعية' : 'Recent Community Activity',
          style: AppTextStyles.headlineSm.copyWith(fontSize: 16),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primaryMuted,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                isArabic ? 'بيانات حية' : 'Live',
                style: AppTextStyles.labelSm.copyWith(
                  color: AppColors.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              isArabic ? 'مصر • القاهرة والجيزة' : 'Egypt • Cairo',
              style: AppTextStyles.labelSm.copyWith(
                color: AppColors.onSurfaceVariant,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeedItem(CommunityActivity item, bool isArabic) {
    final (IconData icon, Color color, Color bg) = switch (item.type) {
      CommunityActionType.addMosque => (
          Icons.add_business_rounded,
          AppColors.primary,
          AppColors.primaryMuted,
        ),
      CommunityActionType.confirmMosque => (
          Icons.check_circle_rounded,
          AppColors.verified,
          AppColors.verifiedBg,
        ),
      CommunityActionType.reportMosque => (
          Icons.flag_rounded,
          AppColors.flagged,
          AppColors.flaggedBg,
        ),
      CommunityActionType.updateFacility => (
          Icons.tune_rounded,
          AppColors.primary,
          AppColors.primaryMuted,
        ),
      CommunityActionType.updateInfo => (
          Icons.edit_note_rounded,
          AppColors.primary,
          AppColors.primaryMuted,
        ),
    };

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: AppSpacing.cardRadius,
        border: Border.all(color: AppColors.outlineVariant.withAlpha(70)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: AppSpacing.md),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: AppTextStyles.labelMd.copyWith(
                      color: AppColors.onSurface,
                    ),
                    children: [
                      TextSpan(
                        text: '${item.contributorName} ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: item.type == CommunityActionType.addMosque
                            ? (isArabic ? 'أضاف ' : 'added ')
                            : item.type == CommunityActionType.confirmMosque
                                ? (isArabic ? 'أكد وجود ' : 'confirmed ')
                                : (isArabic ? 'أبلغ عن ' : 'reported '),
                      ),
                      TextSpan(
                        text: item.mosqueName,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${item.neighborhood} • ${item.timeAgo}',
                      style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                    if (item.statusLabel != null) ...[
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: item.isPending
                              ? AppColors.unverifiedBg
                              : AppColors.verifiedBg,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.statusLabel!,
                          style: AppTextStyles.labelSm.copyWith(
                            color: item.isPending
                                ? AppColors.unverified
                                : AppColors.verified,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddMosqueSheet(BuildContext context, WidgetRef ref, bool isArabic) {
    final settings = ref.read(settingsProvider);
    if (!settings.isProfileRegistered) {
      showAppToast(
        context,
        isArabic ? 'يرجى تسجيل بياناتك أولاً لإضافة المساجد' : 'Please register your details first',
        icon: Icons.lock_outline,
      );
      return;
    }

    final nameCtrl = TextEditingController();
    final addressCtrl = TextEditingController();
    bool hasWomenArea = false;
    bool hasWudu = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.lg,
                top: AppSpacing.lg,
                left: AppSpacing.lg,
                right: AppSpacing.lg,
              ),
              decoration: const BoxDecoration(
                color: AppColors.surfaceLowest,
                borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl)),
              ),
              child: SingleChildScrollView(
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
                      isArabic ? 'إضافة مسجد أو مصلى جديد' : 'Add New Mosque',
                      style: AppTextStyles.headlineSm,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isArabic
                          ? 'أدخل بيانات المسجد بدقة لتحصل على +5 نقاط مساهمة'
                          : 'Enter mosque details accurately to earn +5 points',
                      style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    TextField(
                      controller: nameCtrl,
                      decoration: InputDecoration(
                        labelText: isArabic ? 'اسم المسجد أو المصلى' : 'Mosque Name',
                        hintText: isArabic ? 'مثال: مسجد الرحمن' : 'e.g. Al-Rahman Mosque',
                        filled: true,
                        fillColor: AppColors.surfaceContainer,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    TextField(
                      controller: addressCtrl,
                      decoration: InputDecoration(
                        labelText: isArabic ? 'العنوان أو الحي' : 'Address / Neighborhood',
                        hintText: isArabic ? 'مثال: شارع النصر، المعادي' : 'e.g. Al-Nasr St, Maadi',
                        filled: true,
                        fillColor: AppColors.surfaceContainer,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    CheckboxListTile(
                      value: hasWomenArea,
                      activeColor: AppColors.primary,
                      title: Text(isArabic ? 'يوجد مصلى للسيدات' : "Women's prayer area available"),
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) => setSheetState(() => hasWomenArea = val ?? false),
                    ),
                    CheckboxListTile(
                      value: hasWudu,
                      activeColor: AppColors.primary,
                      title: Text(isArabic ? 'تتوفر أماكن وضوء مهيأة' : 'Wudu facilities available'),
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) => setSheetState(() => hasWudu = val ?? true),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (nameCtrl.text.trim().isEmpty) {
                            showAppToast(
                              context,
                              isArabic ? 'يرجى كتابة اسم المسجد' : 'Please enter mosque name',
                            );
                            return;
                          }
                          Navigator.pop(ctx);
                          ref.read(communityProvider.notifier).submitAddMosque(
                                nameCtrl.text.trim(),
                                addressCtrl.text.trim(),
                              );
                          showAppToast(
                            context,
                            isArabic
                                ? 'جزاك الله خيراً! تم إرسال المسجد بنجاح (+5 نقاط)'
                                : 'Mosque submitted successfully! (+5 points)',
                            icon: Icons.stars_rounded,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                          ),
                        ),
                        child: Text(
                          isArabic ? 'إرسال للمراجعة المجتمعية (+5 نقاط)' : 'Submit Mosque (+5 pts)',
                          style: AppTextStyles.labelLg.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showConfirmMosqueSheet(BuildContext context, WidgetRef ref, bool isArabic) {
    final settings = ref.read(settingsProvider);
    if (!settings.isProfileRegistered) {
      showAppToast(
        context,
        isArabic ? 'يرجى تسجيل بياناتك أولاً لتأكيد المساجد' : 'Please register your details first',
        icon: Icons.lock_outline,
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
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
              Text(
                isArabic ? 'تأكيد وجود مسجد في الحي' : 'Confirm Mosque in Neighborhood',
                style: AppTextStyles.headlineSm,
              ),
              const SizedBox(height: 4),
              Text(
                isArabic
                    ? 'اختر مسجداً لتأكيد صحة موقعه ومرافقه واحصل على +10 نقاط'
                    : 'Select a mosque to confirm its presence and earn +10 points',
                style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.md),

              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.mosque, color: AppColors.unverified, size: 28),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isArabic ? 'مسجد الرحمن' : 'Al-Rahman Mosque',
                            style: AppTextStyles.labelLg.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            isArabic ? 'متفرع من شارع النصر، المعادي (260 م)' : 'Off Al-Nasr St, Maadi (260m)',
                            style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        ),
                      ),
                      child: Text(isArabic ? 'لست متأكداً' : 'Not sure'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ref.read(communityProvider.notifier).submitConfirmation('مسجد الرحمن');
                        showAppToast(
                          context,
                          isArabic
                              ? 'تم تأكيد المسجد بنجاح! حصلت على +10 نقاط مساهمة'
                              : 'Mosque confirmed! Earned +10 points',
                          icon: Icons.stars_rounded,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.verified,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        ),
                      ),
                      child: Text(
                        isArabic ? 'نعم، المسجد قائم (+10)' : 'Confirm (+10)',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showReportSheet(BuildContext context, WidgetRef ref, bool isArabic) {
    final settings = ref.read(settingsProvider);
    if (!settings.isProfileRegistered) {
      showAppToast(
        context,
        isArabic ? 'يرجى تسجيل بياناتك أولاً لتقديم البلاغات' : 'Please register your details first',
        icon: Icons.lock_outline,
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
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
                    isArabic ? 'الإبلاغ عن مسجد أو خطأ' : 'Report Mosque Issue',
                    style: AppTextStyles.headlineSm,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                isArabic
                    ? 'سيقوم فريق المشرفين بمراجعة البلاغ خلال 24 ساعة'
                    : 'Moderators will review within 24 hours',
                style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.md),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.radio_button_checked, color: AppColors.primary),
                title: Text(isArabic ? 'مسجد التقوى (مشكوك في تواجده)' : 'Al-Taqwa Mosque (Doubted)'),
                subtitle: Text(isArabic ? '350 م • ميدان الحرية' : '350m • Freedom Square'),
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ref.read(communityProvider.notifier).submitReport('مسجد التقوى');
                    showAppToast(
                      context,
                      isArabic ? 'تم استلام بلاغك، شكراً لمساهمتك' : 'Report received, thank you',
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
                  child: Text(isArabic ? 'تأكيد إرسال البلاغ' : 'Confirm Report'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditProfileSheet(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
    bool isArabic,
  ) {
    final nameCtrl = TextEditingController(text: settings.contributorName);
    final phoneCtrl = TextEditingController(text: settings.phone);
    final emailCtrl = TextEditingController(text: settings.email);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.lg,
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
                isArabic ? 'تعديل بيانات المساهم' : 'Edit Contributor Info',
                style: AppTextStyles.headlineSm,
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: isArabic ? 'الاسم الكامل' : 'Full Name',
                  filled: true,
                  fillColor: AppColors.surfaceContainer,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: isArabic ? 'رقم الهاتف' : 'Phone Number',
                  filled: true,
                  fillColor: AppColors.surfaceContainer,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: isArabic ? 'البريد الإلكتروني' : 'Email Address',
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
                    final newName = nameCtrl.text.trim();
                    final newPhone = phoneCtrl.text.trim();
                    final newEmail = emailCtrl.text.trim();

                    if (newName.isEmpty || newPhone.isEmpty || newEmail.isEmpty) {
                      showAppToast(
                        context,
                        isArabic ? 'يرجى ملء جميع الحقول المطلوبة' : 'Please fill all fields',
                      );
                      return;
                    }

                    ref.read(settingsProvider.notifier).updateProfile(
                          name: newName,
                          phone: newPhone,
                          email: newEmail,
                        );

                    Navigator.pop(ctx);
                    showAppToast(
                      context,
                      isArabic ? 'تم تحديث البيانات بنجاح' : 'Info updated successfully',
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
                  child: Text(isArabic ? 'حفظ البيانات' : 'Save Info'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Registration & Onboarding Gate View ──────────────────────────────────
class _RegistrationGateView extends ConsumerStatefulWidget {
  final bool isArabic;
  const _RegistrationGateView({required this.isArabic});

  @override
  ConsumerState<_RegistrationGateView> createState() => _RegistrationGateViewState();
}

class _RegistrationGateViewState extends ConsumerState<_RegistrationGateView> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submitRegistration() {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();

    ref.read(settingsProvider.notifier).updateProfile(
          name: name,
          phone: phone,
          email: email,
        );

    showAppToast(
      context,
      widget.isArabic
          ? 'مرحباً بك! تم تسجيلك بنجاح وحصلت على +45 نقطة ترحيبية'
          : 'Welcome! Registration complete (+45 welcome points)',
      icon: Icons.stars_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = widget.isArabic;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.sm),

            // Lock / Shield Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryMuted,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary.withAlpha(60), width: 2),
              ),
              child: const Icon(
                Icons.how_to_reg_rounded,
                size: 42,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Title
            Text(
              isArabic ? 'الانضمام لمجتمع روّاد المساجد' : 'Join Mosque Community',
              style: AppTextStyles.headlineSm.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),

            // Description
            Text(
              isArabic
                  ? 'مجتمع مساجد الحي مخصص للمصلين المعتمدين. يُشترط إدخال الاسم ورقم الهاتف والبريد الإلكتروني للوصول إلى الخلاصة الحية، إضافة مساجد جديدة، وتأكيد المواقيت.'
                  : 'The community is reserved for verified members. Please enter your name, phone, and email to view contributions and participate.',
              style: AppTextStyles.bodyMd.copyWith(
                color: AppColors.onSurfaceVariant,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Input Fields Card
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surfaceLowest,
                borderRadius: AppSpacing.cardRadius,
                border: Border.all(color: AppColors.outlineVariant.withAlpha(80)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.onSurface.withAlpha(8),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Name Field
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: isArabic ? 'الاسم الكامل *' : 'Full Name *',
                      prefixIcon: const Icon(Icons.person_outline, color: AppColors.primary),
                      hintText: isArabic ? 'مثال: أحمد محمد' : 'e.g. Ahmed Mohamed',
                      filled: true,
                      fillColor: AppColors.surfaceContainer,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().length < 3) {
                        return isArabic
                            ? 'يرجى كتابة اسم صحيح (3 أحرف على الأقل)'
                            : 'Please enter a valid name (3+ chars)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Phone Field
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: isArabic ? 'رقم الهاتف *' : 'Phone Number *',
                      prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.primary),
                      hintText: '01xxxxxxxxx',
                      filled: true,
                      fillColor: AppColors.surfaceContainer,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().length < 8) {
                        return isArabic
                            ? 'يرجى إدخال رقم هاتف صالح'
                            : 'Please enter a valid phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: isArabic ? 'البريد الإلكتروني *' : 'Email Address *',
                      prefixIcon: const Icon(Icons.email_outlined, color: AppColors.primary),
                      hintText: 'user@example.com',
                      filled: true,
                      fillColor: AppColors.surfaceContainer,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (val) {
                      if (val == null || !val.contains('@') || !val.contains('.')) {
                        return isArabic
                            ? 'يرجى إدخال بريد إلكتروني صحيح'
                            : 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Benefits Checklist Card
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.verifiedBg,
                borderRadius: AppSpacing.cardRadius,
                border: Border.all(color: AppColors.verified.withAlpha(60)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.stars_rounded, color: AppColors.verified, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        isArabic ? 'مميزات الانضمام للمجتمع:' : 'Community Benefits:',
                        style: AppTextStyles.labelMd.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.verified,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildBenefitRow(isArabic ? 'الحصول فوراً على +45 نقطة مساهمة ترحيبية' : '+45 Welcome Contribution Points'),
                  _buildBenefitRow(isArabic ? 'صلاحية إضافة مساجد ومصليات جديدة على الخريطة' : 'Ability to add new mosques and musallas'),
                  _buildBenefitRow(isArabic ? 'توثيق وتأكيد مواقيت الأذان والإقامة ومصلى السيدات' : 'Confirm prayer times & women facilities'),
                  _buildBenefitRow(isArabic ? 'كسب أوسمة تقديرية ورتب مجتمعية للمساهمين' : 'Earn community recognition badges'),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _submitRegistration,
                icon: const Icon(Icons.check_circle_outline_rounded, size: 20),
                label: Text(
                  isArabic ? 'تأكيد البيانات والانضمام للمجتمع (+45 نقطة)' : 'Register & Join (+45 pts)',
                  style: AppTextStyles.labelLg.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 14, color: AppColors.verified),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySm.copyWith(
                color: AppColors.onSurface,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
