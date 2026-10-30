// lib/data/models/community_post_model.dart

enum CommunityActionType { addMosque, confirmMosque, reportMosque, updateInfo, updateFacility }

class CommunityActivity {
  final String id;
  final String contributorName;
  final CommunityActionType type;
  final String mosqueName;
  final String neighborhood;
  final String timeAgo;
  final int? pointsEarned;
  final String? statusLabel;
  final bool isPending;

  const CommunityActivity({
    required this.id,
    required this.contributorName,
    required this.type,
    required this.mosqueName,
    required this.neighborhood,
    required this.timeAgo,
    this.pointsEarned,
    this.statusLabel,
    this.isPending = false,
  });
}
