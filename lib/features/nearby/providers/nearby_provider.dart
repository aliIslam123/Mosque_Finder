// lib/features/nearby/providers/nearby_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/mosque_model.dart';
import '../../../data/datasources/local/mock_mosque_datasource.dart';
import '../../settings/providers/settings_provider.dart';

enum NearbyView { list, empty, locationPermission }

class NearbyState {
  final List<MosqueModel> allMosques;
  final List<MosqueModel> filteredMosques;
  final MosqueStatus? statusFilter;
  final String searchQuery;
  final NearbyView view;
  final double radiusMeters;

  const NearbyState({
    required this.allMosques,
    required this.filteredMosques,
    this.statusFilter,
    this.searchQuery = '',
    this.view = NearbyView.list,
    this.radiusMeters = 400,
  });

  NearbyState copyWith({
    List<MosqueModel>? allMosques,
    List<MosqueModel>? filteredMosques,
    Object? statusFilter = _sentinel,
    String? searchQuery,
    NearbyView? view,
    double? radiusMeters,
  }) {
    return NearbyState(
      allMosques: allMosques ?? this.allMosques,
      filteredMosques: filteredMosques ?? this.filteredMosques,
      statusFilter: statusFilter == _sentinel
          ? this.statusFilter
          : statusFilter as MosqueStatus?,
      searchQuery: searchQuery ?? this.searchQuery,
      view: view ?? this.view,
      radiusMeters: radiusMeters ?? this.radiusMeters,
    );
  }
}

const _sentinel = Object();

class NearbyNotifier extends Notifier<NearbyState> {
  @override
  NearbyState build() {
    final settings = ref.watch(settingsProvider);
    final all = MockMosqueDataSource.getAll();
    final filtered = _applyFilters(all, null, '', settings.radiusInMeters);
    return NearbyState(
      allMosques: all,
      filteredMosques: filtered,
      radiusMeters: settings.radiusInMeters,
    );
  }

  List<MosqueModel> _applyFilters(
    List<MosqueModel> all,
    MosqueStatus? status,
    String query,
    double radius,
  ) {
    var list = all.where((m) => m.distance <= radius).toList();
    if (status != null) {
      list = list.where((m) => m.status == status).toList();
    }
    if (query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      list = list
          .where((m) =>
              m.nameAr.toLowerCase().contains(q) ||
              m.neighborhood.toLowerCase().contains(q) ||
              m.address.toLowerCase().contains(q))
          .toList();
    }
    list.sort((a, b) => a.distance.compareTo(b.distance));
    return list;
  }

  void setStatusFilter(MosqueStatus? status) {
    state = state.copyWith(
      statusFilter: status,
      filteredMosques: _applyFilters(
        state.allMosques, status, state.searchQuery, state.radiusMeters),
    );
  }

  void setSearch(String query) {
    state = state.copyWith(
      searchQuery: query,
      filteredMosques: _applyFilters(
        state.allMosques, state.statusFilter, query, state.radiusMeters),
    );
  }

  void setRadius(double meters) {
    state = state.copyWith(
      radiusMeters: meters,
      filteredMosques: _applyFilters(
        state.allMosques, state.statusFilter, state.searchQuery, meters),
    );
  }

  void setView(NearbyView view) {
    state = state.copyWith(view: view);
  }

  void confirmMosque(String mosqueId) {
    final updated = state.allMosques.map((m) {
      if (m.id == mosqueId) {
        return m.copyWith(
          status: MosqueStatus.verified,
          communityConfirmations: m.communityConfirmations + 1,
        );
      }
      return m;
    }).toList();
    state = state.copyWith(
      allMosques: updated,
      filteredMosques: _applyFilters(
        updated, state.statusFilter, state.searchQuery, state.radiusMeters),
    );
  }
}

final nearbyProvider = NotifierProvider<NearbyNotifier, NearbyState>(
  NearbyNotifier.new,
);
