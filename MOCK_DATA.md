# 📋 Mock Data Directory (Mosque Finder)

This document catalogs the realistic datasets bundled into Phase 1 of **Mosque Finder**.

---

## 1. Mosques Dataset (`MockMosqueDataSource`)

The mock database contains 10+ realistic mosques and prayer halls located across Greater Cairo, Egypt (Maadi, Nasr City, Dokki, Mohandessin, Heliopolis, Downtown).

| ID | Arabic Name | English Name | Status | Distance | Facilities | Key Iqama Time |
|---|---|---|---|---|---|---|
| `mosque_01` | **مسجد النور** | Al-Nour Mosque | Verified (موثق) | 120 m | مصلى سيدات، وضوء، موقف، تكييف، مكتبة | الظهر: 12:15 م |
| `mosque_02` | **مسجد الرحمن** | Al-Rahman Mosque | Unverified (غير متحقق) | 260 m | وضوء، تكييف | الظهر: 12:20 م |
| `mosque_03` | **مسجد التقوى** | Al-Taqwa Mosque | Flagged (مشكوك فيه) | 350 m | وضوء فقط | الظهر: 12:15 م |
| `mosque_04` | **مصلى التوحيد** | Al-Tawheed Musalla | Unverified (غير متحقق) | 390 m | ميضأة صغيرة | الظهر: 12:30 م |
| `mosque_05` | **مسجد الفتح** | Al-Fateh Mosque | Verified (موثق) | 480 m | مصلى سيدات، وضوء، موقف، تكييف | الظهر: 12:15 م |
| `mosque_06` | **مسجد الإيمان** | Al-Iman Mosque | Verified (موثق) | 540 m | مصلى سيدات، وضوء، تكييف | الظهر: 12:20 م |
| `mosque_07` | **مصلى السلام** | Al-Salam Musalla | Unverified (غير متحقق) | 620 m | وضوء | الظهر: 12:15 م |
| `mosque_08` | **مسجد الفاروق** | Al-Farooq Mosque | Verified (موثق) | 710 m | مصلى سيدات، وضوء، موقف، تكييف | الظهر: 12:25 م |
| `mosque_09` | **مسجد الهداية** | Al-Hedaya Mosque | Flagged (مشكوك فيه) | 780 m | قيد الترميم | الظهر: 12:15 م |
| `mosque_10` | **مسجد بلال بن رباح** | Bilal Mosque | Verified (موثق) | 850 m | مصلى سيدات، وضوء، تكييف، مكتبة | الظهر: 12:15 م |

---

## 2. Prayer Schedule Matrix (Based on Cairo Local Times)

- **الفجر (Fajr):** الأذان 05:04 ص • الإقامة 05:25 ص
- **الشروق (Sunrise):** 06:28 ص
- **الظهر (Dhuhr):** الأذان 11:58 ص • الإقامة 12:15 م
- **العصر (Asr):** الأذان 03:02 م • الإقامة 03:20 م
- **المغرب (Maghrib):** الأذان 05:27 م • الإقامة 05:35 م
- **العشاء (Isha):** الأذان 06:47 م • الإقامة 07:05 م

---

## 3. Community Activity Feed Dataset (`MockCommunityDataSource`)

The community feed simulates active crowd-sourced participation across Cairo:

1. **أحمد محمد** أضاف *مسجد الرحمن* • حالة المسجد: قيد التحقق (مدينة نصر، منذ ساعتين)
2. **منى علي** أكدت وجود *مسجد النور* • +10 نقاط مساهمة (المعادي، منذ 5 ساعات)
3. **مساهمة جديدة** لـ *مصلى التوحيد* • تحتاج مراجعة المجتمع 2/3 (الدقي، أمس)
4. **عمر خالد** أبلغ عن خطأ في موقع *مسجد التقوى* • قيد المراجعة (المهندسين، منذ يومين)
5. **كريم حسن** وثّق مصلى السيدات في *مسجد الفتح* • +10 نقاط مساهمة (مصر الجديدة، منذ 3 أيام)
