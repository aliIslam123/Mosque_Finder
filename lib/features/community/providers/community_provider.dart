// lib/features/community/providers/community_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/community_post_model.dart';
import '../../../data/datasources/local/mock_community_datasource.dart';
import '../../settings/providers/settings_provider.dart';

class CommunityState {
  final List<CommunityActivity> activities;
  final bool isLoading;

  const CommunityState({
    required this.activities,
    this.isLoading = false,
  });

  CommunityState copyWith({
    List<CommunityActivity>? activities,
    bool? isLoading,
  }) {
    return CommunityState(
      activities: activities ?? this.activities,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class CommunityNotifier extends Notifier<CommunityState> {
  @override
  CommunityState build() {
    return CommunityState(activities: MockCommunityDataSource.getActivities());
  }

  void addActivity(CommunityActivity activity) {
    state = state.copyWith(
      activities: [activity, ...state.activities],
    );
  }

  Future<void> submitAddMosque(String mosqueName, String address) async {
    final settings = ref.read(settingsProvider);
    final activity = CommunityActivity(
      id: 'act_${DateTime.now().millisecondsSinceEpoch}',
      contributorName: settings.contributorName,
      type: CommunityActionType.addMosque,
      mosqueName: mosqueName,
      neighborhood: address.isNotEmpty ? address : 'موقع جديد',
      timeAgo: 'الآن',
      pointsEarned: 5,
      statusLabel: 'قيد التحقق',
      isPending: true,
    );
    addActivity(activity);
    await ref.read(settingsProvider.notifier).addPoints(5);
  }

  Future<void> submitConfirmation(String mosqueName) async {
    final settings = ref.read(settingsProvider);
    final activity = CommunityActivity(
      id: 'act_${DateTime.now().millisecondsSinceEpoch}',
      contributorName: settings.contributorName,
      type: CommunityActionType.confirmMosque,
      mosqueName: mosqueName,
      neighborhood: 'المجتمع المحلي',
      timeAgo: 'الآن',
      pointsEarned: 10,
      statusLabel: 'تم التوثيق',
    );
    addActivity(activity);
    await ref.read(settingsProvider.notifier).addPoints(10);
  }

  Future<void> submitReport(String mosqueName) async {
    final settings = ref.read(settingsProvider);
    final activity = CommunityActivity(
      id: 'act_${DateTime.now().millisecondsSinceEpoch}',
      contributorName: settings.contributorName,
      type: CommunityActionType.reportMosque,
      mosqueName: mosqueName,
      neighborhood: 'المجتمع المحلي',
      timeAgo: 'الآن',
      statusLabel: 'قيد المراجعة',
      isPending: true,
    );
    addActivity(activity);
  }
}

final communityProvider = NotifierProvider<CommunityNotifier, CommunityState>(
  CommunityNotifier.new,
);
