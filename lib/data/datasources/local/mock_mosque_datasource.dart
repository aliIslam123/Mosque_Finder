// lib/data/datasources/local/mock_mosque_datasource.dart
import '../../models/mosque_model.dart';

class MockMosqueDataSource {
  static const List<MosqueModel> mosques = [
    // ── 1. مسجد النور — Verified ─────────────────────────────────────────
    MosqueModel(
      id: 'masjid_nour',
      nameAr: 'مسجد النور',
      nameEn: 'Al-Nour Mosque',
      neighborhood: 'المعادي',
      address: 'شارع ٩، المعادي، القاهرة',
      distance: 120,
      latitude: 29.9600,
      longitude: 31.2500,
      status: MosqueStatus.verified,
      communityConfirmations: 8,
      facilities: MosqueFacilities(
        womenPrayerArea: true,
        wuduFacilities: true,
        parking: false,
        wheelchairAccess: true,
        airConditioning: true,
      ),
      prayerTimes: PrayerTimes(
        fajr: '٤:٥٢ ص',
        sunrise: '٦:١٠ ص',
        dhuhr: '١٢:٠٤ م',
        asr: '٣:٢٨ م',
        maghrib: '٦:٠١ م',
        isha: '٧:١٩ م',
      ),
      iqamaTimes: IqamaTimes(
        fajr: '٥:٠٠ ص',
        dhuhr: '١٢:٥٠ م',
        asr: '٣:٤٥ م',
        maghrib: '٦:٠٥ م',
        isha: '٧:٣٠ م',
      ),
      description: 'مسجد كبير ومجهز بالكامل، مكيف، مصلى سيدات في الطابق الثاني. أُنشئ عام ١٩٨٠.',
      phone: '+20 2 2345 6789',
    ),

    // ── 2. مسجد الرحمن — Unverified ──────────────────────────────────────
    MosqueModel(
      id: 'masjid_rahman',
      nameAr: 'مسجد الرحمن',
      nameEn: 'Al-Rahman Mosque',
      neighborhood: 'المعادي',
      address: 'متفرع من شارع النصر، المعادي',
      distance: 260,
      latitude: 29.9590,
      longitude: 31.2530,
      status: MosqueStatus.unverified,
      communityConfirmations: 2,
      facilities: MosqueFacilities(
        womenPrayerArea: false,
        wuduFacilities: true,
        parking: true,
      ),
      prayerTimes: PrayerTimes(
        fajr: '٤:٥٢ ص',
        sunrise: '٦:١٠ ص',
        dhuhr: '١٢:٠٤ م',
        asr: '٣:٢٨ م',
        maghrib: '٦:٠١ م',
        isha: '٧:١٩ م',
      ),
      iqamaTimes: IqamaTimes(
        fajr: '٥:٠٥ ص',
        dhuhr: '١:٠٠ م',
        asr: '٣:٥٠ م',
        maghrib: '٦:٠٧ م',
        isha: '٧:٣٥ م',
      ),
      description: 'أُضيف حديثًا بواسطة رواد المسجد، يحتاج لتأكيد الإمام ومصلى السيدات.',
    ),

    // ── 3. مسجد التقوى — Flagged ──────────────────────────────────────────
    MosqueModel(
      id: 'masjid_taqwa',
      nameAr: 'مسجد التقوى',
      nameEn: 'Al-Taqwa Mosque',
      neighborhood: 'ميدان الحرية',
      address: 'ميدان الحرية، المعادي',
      distance: 350,
      latitude: 29.9570,
      longitude: 31.2480,
      status: MosqueStatus.flagged,
      communityConfirmations: 0,
      facilities: MosqueFacilities(
        womenPrayerArea: false,
        wuduFacilities: false,
      ),
      prayerTimes: PrayerTimes(
        fajr: '٤:٥٢ ص',
        sunrise: '٦:١٠ ص',
        dhuhr: '١٢:٠٤ م',
        asr: '٣:٢٨ م',
        maghrib: '٦:٠١ م',
        isha: '٧:١٩ م',
      ),
      iqamaTimes: IqamaTimes(
        fajr: '—',
        dhuhr: '—',
        asr: '—',
        maghrib: '—',
        isha: '—',
      ),
      description: 'أبلغ المصلون عن إغلاقه للتجديدات أو عدم وجود علامات تدل على مصلى دائم.',
    ),

    // ── 4. مصلى التوحيد — Unverified ─────────────────────────────────────
    MosqueModel(
      id: 'musalla_tawhid',
      nameAr: 'مصلى التوحيد',
      nameEn: 'Al-Tawhid Prayer Room',
      neighborhood: 'الدقي',
      address: 'ممر عمارة الشرق، مصلى صغير، الدقي',
      distance: 390,
      latitude: 29.9610,
      longitude: 31.2555,
      status: MosqueStatus.unverified,
      communityConfirmations: 1,
      facilities: MosqueFacilities(
        womenPrayerArea: false,
        wuduFacilities: true,
        wheelchairAccess: false,
      ),
      prayerTimes: PrayerTimes(
        fajr: '٤:٥٢ ص',
        sunrise: '٦:١٠ ص',
        dhuhr: '١٢:٠٤ م',
        asr: '٣:٢٨ م',
        maghrib: '٦:٠١ م',
        isha: '٧:١٩ م',
      ),
      iqamaTimes: IqamaTimes(
        fajr: '٥:٠٠ ص',
        dhuhr: '١٢:٣٠ م',
        asr: '٣:٣٠ م',
        maghrib: '٦:٠٢ م',
        isha: '٧:٢٠ م',
      ),
      description: 'مصلى ملحق بمركز تجاري صغير، السلالم غير مجهزة بكرسي متحرك.',
    ),

    // ── 5. مسجد الفرقان — Verified ──────────────────────────────────────
    MosqueModel(
      id: 'masjid_furqan',
      nameAr: 'مسجد الفرقان',
      nameEn: 'Al-Furqan Mosque',
      neighborhood: 'الدقي',
      address: 'شارع الشهيد عبد المنعم رياض، الدقي',
      distance: 480,
      latitude: 29.9640,
      longitude: 31.2520,
      status: MosqueStatus.verified,
      communityConfirmations: 12,
      facilities: MosqueFacilities(
        womenPrayerArea: true,
        wuduFacilities: true,
        parking: true,
        wheelchairAccess: true,
        airConditioning: true,
        library: true,
      ),
      prayerTimes: PrayerTimes(
        fajr: '٤:٥٢ ص',
        sunrise: '٦:١٠ ص',
        dhuhr: '١٢:٠٤ م',
        asr: '٣:٢٨ م',
        maghrib: '٦:٠١ م',
        isha: '٧:١٩ م',
      ),
      iqamaTimes: IqamaTimes(
        fajr: '٤:٥٨ ص',
        dhuhr: '١٢:٤٠ م',
        asr: '٣:٤٠ م',
        maghrib: '٦:٠٣ م',
        isha: '٧:٢٥ م',
      ),
      description: 'مسجد كبير ومركزي، يحتضن درس الجمعة الأسبوعي وحلقات التحفيظ.',
      phone: '+20 2 3765 4321',
    ),

    // ── 6. مسجد الإيمان — Verified ──────────────────────────────────────
    MosqueModel(
      id: 'masjid_iman',
      nameAr: 'مسجد الإيمان',
      nameEn: 'Al-Iman Mosque',
      neighborhood: 'مدينة نصر',
      address: 'شارع عباس العقاد، مدينة نصر',
      distance: 560,
      latitude: 30.0700,
      longitude: 31.3400,
      status: MosqueStatus.verified,
      communityConfirmations: 5,
      facilities: MosqueFacilities(
        womenPrayerArea: true,
        wuduFacilities: true,
        airConditioning: true,
      ),
      prayerTimes: PrayerTimes(
        fajr: '٤:٥١ ص',
        sunrise: '٦:٠٩ ص',
        dhuhr: '١٢:٠٣ م',
        asr: '٣:٢٧ م',
        maghrib: '٦:٠٠ م',
        isha: '٧:١٨ م',
      ),
      iqamaTimes: IqamaTimes(
        fajr: '٤:٥٩ ص',
        dhuhr: '١٢:٤٥ م',
        asr: '٣:٤٥ م',
        maghrib: '٦:٠٢ م',
        isha: '٧:٢٨ م',
      ),
      description: 'مسجد حيوي يستقطب مئات المصلين يومياً.',
      phone: '+20 2 2411 0000',
    ),

    // ── 7. مسجد عمر بن الخطاب — Verified ────────────────────────────────
    MosqueModel(
      id: 'masjid_omar',
      nameAr: 'مسجد عمر بن الخطاب',
      nameEn: 'Omar Ibn Al-Khattab Mosque',
      neighborhood: 'المهندسين',
      address: 'شارع جامعة الدول العربية، المهندسين',
      distance: 620,
      latitude: 29.9700,
      longitude: 31.2000,
      status: MosqueStatus.verified,
      communityConfirmations: 20,
      facilities: MosqueFacilities(
        womenPrayerArea: true,
        wuduFacilities: true,
        parking: true,
        wheelchairAccess: true,
        airConditioning: true,
        library: true,
      ),
      prayerTimes: PrayerTimes(
        fajr: '٤:٥٢ ص',
        sunrise: '٦:١٠ ص',
        dhuhr: '١٢:٠٤ م',
        asr: '٣:٢٨ م',
        maghrib: '٦:٠١ م',
        isha: '٧:١٩ م',
      ),
      iqamaTimes: IqamaTimes(
        fajr: '٤:٥٨ ص',
        dhuhr: '١٢:٣٠ م',
        asr: '٣:٣٥ م',
        maghrib: '٦:٠٣ م',
        isha: '٧:٢٢ م',
      ),
      description: 'من أعرق المساجد في المنطقة. يضم مكتبة إسلامية وفصول تحفيظ.',
      phone: '+20 2 3344 5566',
    ),

    // ── 8. مصلى سنتر الحكمة — Unverified ─────────────────────────────────
    MosqueModel(
      id: 'musalla_hikma',
      nameAr: 'مصلى سنتر الحكمة',
      nameEn: 'Al-Hikma Center Prayer Room',
      neighborhood: 'المهندسين',
      address: 'الطابق الأول، مول الحكمة، المهندسين',
      distance: 700,
      latitude: 29.9680,
      longitude: 31.2020,
      status: MosqueStatus.unverified,
      communityConfirmations: 3,
      facilities: MosqueFacilities(
        womenPrayerArea: true,
        wuduFacilities: true,
      ),
      prayerTimes: PrayerTimes(
        fajr: '٤:٥٢ ص',
        sunrise: '٦:١٠ ص',
        dhuhr: '١٢:٠٤ م',
        asr: '٣:٢٨ م',
        maghrib: '٦:٠١ م',
        isha: '٧:١٩ م',
      ),
      iqamaTimes: IqamaTimes(
        fajr: '—',
        dhuhr: '١:١٥ م',
        asr: '٣:٤٠ م',
        maghrib: '٦:٠٣ م',
        isha: '—',
      ),
      description: 'مصلى داخل مركز تجاري، متاح خلال ساعات العمل فقط.',
    ),

    // ── 9. مسجد السلام — Verified ────────────────────────────────────────
    MosqueModel(
      id: 'masjid_salam',
      nameAr: 'مسجد السلام',
      nameEn: 'Al-Salam Mosque',
      neighborhood: 'الزمالك',
      address: 'شارع حسن صبري، الزمالك',
      distance: 780,
      latitude: 30.0620,
      longitude: 31.2180,
      status: MosqueStatus.verified,
      communityConfirmations: 7,
      facilities: MosqueFacilities(
        womenPrayerArea: true,
        wuduFacilities: true,
        airConditioning: true,
      ),
      prayerTimes: PrayerTimes(
        fajr: '٤:٥٢ ص',
        sunrise: '٦:١٠ ص',
        dhuhr: '١٢:٠٤ م',
        asr: '٣:٢٨ م',
        maghrib: '٦:٠١ م',
        isha: '٧:١٩ م',
      ),
      iqamaTimes: IqamaTimes(
        fajr: '٥:٠٢ ص',
        dhuhr: '١٢:٣٥ م',
        asr: '٣:٣٨ م',
        maghrib: '٦:٠٤ م',
        isha: '٧:٢٤ م',
      ),
      description: 'مسجد نظيف وهادئ في قلب الزمالك.',
    ),

    // ── 10. مسجد بلال — Verified ──────────────────────────────────────────
    MosqueModel(
      id: 'masjid_bilal',
      nameAr: 'مسجد بلال',
      nameEn: 'Bilal Mosque',
      neighborhood: 'مدينة نصر',
      address: 'شارع مصطفى النحاس، مدينة نصر',
      distance: 850,
      latitude: 30.0750,
      longitude: 31.3450,
      status: MosqueStatus.verified,
      communityConfirmations: 9,
      facilities: MosqueFacilities(
        womenPrayerArea: false,
        wuduFacilities: true,
        parking: true,
        airConditioning: true,
      ),
      prayerTimes: PrayerTimes(
        fajr: '٤:٥١ ص',
        sunrise: '٦:٠٩ ص',
        dhuhr: '١٢:٠٣ م',
        asr: '٣:٢٧ م',
        maghrib: '٦:٠٠ م',
        isha: '٧:١٨ م',
      ),
      iqamaTimes: IqamaTimes(
        fajr: '٥:٠٠ ص',
        dhuhr: '١٢:٤٥ م',
        asr: '٣:٤٢ م',
        maghrib: '٦:٠٢ م',
        isha: '٧:٢٦ م',
      ),
      description: 'مسجد حيوي مع إمام متميز.',
    ),
  ];

  static List<MosqueModel> getAll() => mosques;

  static List<MosqueModel> getByStatus(MosqueStatus status) =>
      mosques.where((m) => m.status == status).toList();

  static List<MosqueModel> getWithinRadius(double radiusMeters) =>
      mosques.where((m) => m.distance <= radiusMeters).toList();

  static List<MosqueModel> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return mosques;
    return mosques
        .where((m) =>
            m.nameAr.toLowerCase().contains(q) ||
            m.nameEn.toLowerCase().contains(q) ||
            m.neighborhood.toLowerCase().contains(q) ||
            m.address.toLowerCase().contains(q))
        .toList();
  }

  static MosqueModel? getById(String id) {
    try {
      return mosques.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }
}
