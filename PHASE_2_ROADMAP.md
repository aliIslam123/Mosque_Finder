# 🚀 Phase 2 Development Roadmap (Mosque Finder)

Having completed a solid, production-grade **Phase 1 Frontend**, this roadmap outlines the architecture, integrations, and milestones for **Phase 2**.

---

## 🎯 Phase 2 Objectives

1. **Backend & Cloud Infrastructure:** Transition from in-memory mock data to a cloud database (PostgreSQL with PostGIS / Supabase or Firebase Firestore).
2. **Real Location & Map Engine:** Replace the custom canvas map with the official Google Maps SDK, supporting real GPS telemetry and walking directions.
3. **Hardware Sensors for Qibla:** Connect `sensors_plus` magnetometer and gyroscope APIs with low-pass Butterworth filtering for jitter-free real-world compass calibration.
4. **Push Notifications:** Setup Firebase Cloud Messaging (FCM) for Iqama reminders and community moderation alerts.

---

## 📅 Milestone Breakdown

### Milestone 1: Cloud Backend & Data Models
- **Database Schema:**
  - `mosques` table with PostGIS geometry points for geospatial indexing (`ST_DWithin`).
  - `prayer_schedules` table with daily calculation method configs (Egyptian General Authority of Survey).
  - `community_contributions` table tracking anonymous contributor reputations and moderation queues.
- **API Services:** Deploy high-performance REST / GraphQL API endpoints defined in `API_INTEGRATION.md`.
- **Authentication (Optional / Silent):** Anonymous Firebase Auth or device UUID tokens to prevent spam while maintaining zero friction.

---

### Milestone 2: Google Maps & Real GPS Integration
- Activate Android & iOS Google Maps API keys following `GOOGLE_MAPS_SETUP.md`.
- Implement background GPS location listeners using `geolocator`.
- Real-time route polylines and turn-by-turn navigation deep-links to Google Maps / Apple Maps / Waze.

---

### Milestone 3: Real Device Sensors & Qibla Compass
- Hook `sensors_plus` magnetometer events (`magnetometerEventStream()`).
- Implement true magnetic declination calculations using the World Magnetic Model (WMM).
- Add figure-8 motion compass calibration animation overlay when magnetic accuracy is low.

---

### Milestone 4: Offline Mode & Local Cache
- Implement SQLite / Drift local caching for offline prayer times and cached mosque coordinates.
- Automatic sync when network reconnects.

---

### Milestone 5: Community Verification System & Moderation
- Trusted community moderator role.
- Crowd-sourced photo uploads with automated image moderation (Cloudflare Workers / Google Cloud Vision).
- Multi-user confirmation threshold (e.g. 3 independent neighborhood confirmations automatically verify an unverified mosque).
