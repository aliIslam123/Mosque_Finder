// lib/data/datasources/local/mock_community_datasource.dart
import '../../models/community_post_model.dart';

class MockCommunityDataSource {
  static List<CommunityActivity> getActivities() => [
        const CommunityActivity(
          id: 'act_1',
          contributorName: 'أحمد محمد',
          type: CommunityActionType.addMosque,
          mosqueName: 'مسجد الرحمن',
          neighborhood: 'مدينة نصر',
          timeAgo: 'منذ ساعتين',
          pointsEarned: 5,
          statusLabel: 'قيد التحقق',
          isPending: true,
        ),
        const CommunityActivity(
          id: 'act_2',
          contributorName: 'منى علي',
          type: CommunityActionType.confirmMosque,
          mosqueName: 'مسجد النور',
          neighborhood: 'المعادي',
          timeAgo: 'منذ ٥ ساعات',
          pointsEarned: 10,
          statusLabel: '+١٠ نقاط مساهمة',
        ),
        const CommunityActivity(
          id: 'act_3',
          contributorName: 'مجهول',
          type: CommunityActionType.updateInfo,
          mosqueName: 'مصلى التوحيد',
          neighborhood: 'الدقي',
          timeAgo: 'أمس',
          statusLabel: 'تحتاج مراجعة المجتمع (٢/٣ تأكيدات)',
          isPending: true,
        ),
        const CommunityActivity(
          id: 'act_4',
          contributorName: 'خالد إبراهيم',
          type: CommunityActionType.confirmMosque,
          mosqueName: 'مسجد الفرقان',
          neighborhood: 'الدقي',
          timeAgo: 'منذ يومين',
          pointsEarned: 10,
          statusLabel: 'تم التوثيق',
        ),
        const CommunityActivity(
          id: 'act_5',
          contributorName: 'سارة محمود',
          type: CommunityActionType.reportMosque,
          mosqueName: 'مسجد التقوى',
          neighborhood: 'ميدان الحرية',
          timeAgo: 'منذ ٣ أيام',
          statusLabel: 'قيد المراجعة',
          isPending: true,
        ),
        const CommunityActivity(
          id: 'act_6',
          contributorName: 'عمر حسن',
          type: CommunityActionType.addMosque,
          mosqueName: 'مصلى سنتر الحكمة',
          neighborhood: 'المهندسين',
          timeAgo: 'منذ أسبوع',
          pointsEarned: 5,
          statusLabel: 'تمت الإضافة',
        ),
      ];
}
