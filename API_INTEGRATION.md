# 🔌 API Integration & Contract Guide (Phase 2 Preparation)

This document specifies the RESTful / GraphQL API endpoints and data schemas designed to replace the Phase 1 mock data sources seamlessly.

---

## 1. Base URL & Common Headers

```http
BASE_URL: https://api.mosquefinder.org/v1
Content-Type: application/json
Accept: application/json
Accept-Language: ar-EG, en-US
X-Device-Id: <UUID-stored-in-SharedPreferences>
```

---

## 2. Endpoints Specification

### A. Mosques Directory

#### `GET /mosques/nearby`
Fetches mosques within a given radius from user coordinates.

**Query Parameters:**
- `lat` (float, required): User latitude (e.g. `30.0444`)
- `lng` (float, required): User longitude (e.g. `31.2357`)
- `radius` (integer, optional, default: 400): Search radius in meters (`200`, `400`, `800`)
- `status` (string, optional): `verified` | `unverified` | `flagged`
- `q` (string, optional): Search keyword query

**Response Body (200 OK):**
```json
{
  "success": true,
  "data": [
    {
      "id": "mosque_01",
      "name_ar": "مسجد النور",
      "name_en": "Al-Nour Mosque",
      "neighborhood": "المعادي",
      "address": "شارع 9، ميدان المحطة، المعادي",
      "latitude": 30.0450,
      "longitude": 31.2360,
      "distance_meters": 120.0,
      "status": "verified",
      "community_confirmations": 42,
      "last_verified_at": "2026-10-28T12:00:00Z",
      "facilities": {
        "women_prayer_area": true,
        "wudu_facilities": true,
        "parking": true,
        "wheelchair_access": true,
        "air_conditioning": true,
        "library": true
      },
      "prayer_times": {
        "fajr": "05:04 ص",
        "sunrise": "06:28 ص",
        "dhuhr": "11:58 ص",
        "asr": "03:02 م",
        "maghrib": "05:27 م",
        "isha": "06:47 م"
      },
      "iqama_times": {
        "fajr": "05:25 ص",
        "dhuhr": "12:15 م",
        "asr": "03:20 م",
        "maghrib": "05:35 م",
        "isha": "07:05 م"
      }
    }
  ]
}
```

---

#### `GET /mosques/{id}`
Returns full details, community logs, and facility metadata for a single mosque.

---

### B. Community Contributions

#### `POST /mosques`
Allows any worshipper to submit a newly discovered mosque or prayer hall without account registration.

**Request Body:**
```json
{
  "name_ar": "مسجد الفتح",
  "address": "شارع الجمهورية، رمسيس",
  "latitude": 30.0570,
  "longitude": 31.2460,
  "contributor_name": "أحمد محمد",
  "facilities": {
    "women_prayer_area": false,
    "wudu_facilities": true
  }
}
```

#### `POST /mosques/{id}/confirm`
Worshippers confirm that a mosque exists and is open for prayers.
**Request Body:**
```json
{
  "contributor_name": "أحمد محمد",
  "feedback": "المسجد مفتوح ومصلى السيدات جاهز"
}
```

#### `POST /mosques/{id}/report`
Submit a report regarding closed mosques, wrong locations, or maintenance issues.
**Request Body:**
```json
{
  "reason": "permanently_closed",
  "notes": "المسجد مغلق لأعمال الترميم"
}
```

---

## 3. How to Switch in Flutter (Phase 2)

Create `lib/data/datasources/remote/api_mosque_datasource.dart`:
```dart
class ApiMosqueDataSource {
  final http.Client client;
  ApiMosqueDataSource(this.client);

  Future<List<MosqueModel>> getNearby({
    required double lat,
    required double lng,
    required double radius,
  }) async {
    final response = await client.get(
      Uri.parse('$baseUrl/mosques/nearby?lat=$lat&lng=$lng&radius=$radius'),
    );
    // Parse JSON into MosqueModel
  }
}
```
In Riverpod, simply update the repository provider from `MockMosqueDataSource` to `ApiMosqueDataSource`. The presentation widgets will require zero code modifications.
