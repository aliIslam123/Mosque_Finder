// lib/data/models/mosque_model.dart

enum MosqueStatus { verified, unverified, flagged }

class MosqueFacilities {
  final bool womenPrayerArea;
  final bool wuduFacilities;
  final bool parking;
  final bool wheelchairAccess;
  final bool airConditioning;
  final bool library;

  const MosqueFacilities({
    this.womenPrayerArea = false,
    this.wuduFacilities = true,
    this.parking = false,
    this.wheelchairAccess = false,
    this.airConditioning = false,
    this.library = false,
  });
}

class IqamaTimes {
  final String fajr;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;

  const IqamaTimes({
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });
}

class PrayerTimes {
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;

  const PrayerTimes({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });
}

class MosqueModel {
  final String id;
  final String nameAr;
  final String nameEn;
  final String neighborhood;
  final String address;
  final double distance; // in meters
  final double latitude;
  final double longitude;
  final MosqueStatus status;
  final MosqueFacilities facilities;
  final PrayerTimes prayerTimes;
  final IqamaTimes iqamaTimes;
  final String? description;
  final String? phone;
  final int communityConfirmations;
  final DateTime? lastVerified;

  const MosqueModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.neighborhood,
    required this.address,
    required this.distance,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.facilities,
    required this.prayerTimes,
    required this.iqamaTimes,
    this.description,
    this.phone,
    this.communityConfirmations = 0,
    this.lastVerified,
  });

  String get nextPrayerName {
    // Simple: return Dhuhr as next prayer (in real app: compare with DateTime.now())
    return 'الظهر';
  }

  String get nextIqamaTime => iqamaTimes.dhuhr;

  bool get isVerified => status == MosqueStatus.verified;
  bool get isFlagged => status == MosqueStatus.flagged;

  String get distanceText {
    if (distance < 1000) {
      return '${distance.round()} م';
    }
    return '${(distance / 1000).toStringAsFixed(1)} كم';
  }

  MosqueModel copyWith({
    MosqueStatus? status,
    int? communityConfirmations,
  }) {
    return MosqueModel(
      id: id,
      nameAr: nameAr,
      nameEn: nameEn,
      neighborhood: neighborhood,
      address: address,
      distance: distance,
      latitude: latitude,
      longitude: longitude,
      status: status ?? this.status,
      facilities: facilities,
      prayerTimes: prayerTimes,
      iqamaTimes: iqamaTimes,
      description: description,
      phone: phone,
      communityConfirmations:
          communityConfirmations ?? this.communityConfirmations,
      lastVerified: lastVerified,
    );
  }
}
