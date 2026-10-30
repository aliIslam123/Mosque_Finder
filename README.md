# 🕌 Mosque Finder (مستكشف المساجد)

> **دليلك الموثوق لمساجد ومصليات الحي، مواقيت الأذان والإقامة، واتجاه القبلة بدقة.**  
> A premium, production-ready Flutter frontend built with an Apple-inspired user experience, Arabic RTL-first design, comprehensive mock repository architecture, and zero-registration barrier.

---

## 📱 Screenshots & Overview

The application is structured into 5 core tabs:
1. **الخريطة (Map):** Interactive vector canvas map with street grid, parks, 3D building outlines, user pulsating radar, dynamic search radius rings (200m / 400m / 800m), interactive mosque markers with status badges, and bottom detail preview card.
2. **المساجد (Nearby):** Filterable list of nearby mosques with instant search, radius picker, verification status chips, state preview switcher (List / Empty / Permission), and facilities badges.
3. **القبلة (Qibla):** Fluid animated compass dial with Kaaba needle, degrees heading display, interactive simulation slider, auto-align shortcut, and clearly labeled Demo Mode banner.
4. **المجتمع (Community):** Contributor profile with earned points, non-registration badge, interactive action cards (Add Mosque, Confirm Mosque, Report Issue), and real-time community activity feed.
5. **الإعدادات (Settings):** Contributor name customization, notification switches, default search radius segmented control, Arabic / English instant language switcher with automatic RTL/LTR flip, and Dark Mode.

---

## 🚀 Key Highlights & Philosophy

- **Zero Mandatory Registration:** Users can immediately discover mosques and contribute without passwords or account setup barriers.
- **Apple Human Interface Guidelines Inspired:** Clean hierarchy, soft rounded cards, fluid animations (`flutter_animate`), generous whitespace, and restrained color palette.
- **Arabic-First (RTL) & English (LTR):** Complete localization support with dynamic text direction changes on the fly.
- **Clean Architecture & Separation of Concerns:**
  - `data/models/`: Immutable data models (MosqueModel, PrayerTimes, IqamaTimes, Facilities).
  - `data/datasources/`: Mock repositories and SharedPreferences local storage.
  - `features/*/providers/`: Riverpod 2.x StateNotifiers with zero mock data leakage into widgets.
  - `core/theme/` & `core/constants/`: Centralized design system matching the UI/UX specifications.
- **Prepared for Phase 2:** Fully decoupled interfaces ready for REST/GraphQL APIs, Firebase/Supabase, and Google Maps SDK.

---

## 🛠️ Tech Stack & Packages

- **Framework:** Flutter 3.x / Dart 3.x
- **State Management:** `flutter_riverpod: ^2.6.1`
- **Routing:** `go_router: ^14.8.1` (ShellRoute with bottom navigation bar)
- **Local Persistence:** `shared_preferences: ^2.3.4`
- **Animations:** `flutter_animate: ^4.5.2`
- **Typography:** Google Fonts (`google_fonts: ^6.2.1` with IBM Plex Sans Arabic fallback)
- **Sensors & Location:** `sensors_plus`, `geolocator`, `permission_handler` (Abstracted for Phase 2)
- **Sharing & URLs:** `share_plus`, `url_launcher`

---

## 📂 Project Structure

```
mosque_finder/
├── assets/
│   ├── icons/
│   └── images/
├── lib/
│   ├── core/
│   │   ├── animations/     # AppAnimations & Pulse effects
│   │   ├── constants/      # AppColors, AppSpacing, AppTypography
│   │   ├── routing/        # GoRouter navigation & ShellRoute
│   │   ├── theme/          # Light & Dark ThemeData
│   │   └── utils/          # Qibla calculation math (Great Circle Bearing)
│   ├── data/
│   │   ├── datasources/    # Mock Mosque, Community, and SharedPreferences
│   │   └── models/         # MosqueModel, CommunityActivity, SettingsModel
│   ├── features/
│   │   ├── community/      # Community feed, modals, and contribution actions
│   │   ├── home/           # Interactive Map canvas & preview cards
│   │   ├── mosque_detail/  # Detailed view, facilities grid, iqama schedules
│   │   ├── nearby/         # Mosque directory, filters, radius switcher
│   │   ├── qibla/          # Qibla compass & simulation controls
│   │   ├── settings/       # Preferences, language (AR/EN), notifications
│   │   ├── shell/          # 5-tab animated bottom navigation bar
│   │   └── splash/         # Animated logo reveal & entry screen
│   ├── shared/
│   │   └── widgets/        # StatusBadge, MosqueFinderAppBar, EmptyState, Toast
│   └── main.dart           # App entry point with ProviderScope
├── API_INTEGRATION.md      # Phase 2 backend & API contracts
├── ANIMATIONS.md           # Animation system documentation
├── ARCHITECTURE.md         # Architecture blueprint & data flow
├── GOOGLE_MAPS_SETUP.md    # Instructions for replacing Mock Map with Google Maps
├── MOCK_DATA.md            # Directory of 10+ realistic mosques & community activities
└── PHASE_2_ROADMAP.md      # Backend, real sensors, and push notifications roadmap
```

---

## 🏃 Getting Started

1. **Install Flutter:** Ensure Flutter 3.5+ is installed (`flutter --version`).
2. **Fetch Dependencies:**
   ```bash
   flutter pub get
   ```
3. **Run the App:**
   ```bash
   flutter run
   ```

---

## 📜 License
Developed as a non-profit community initiative for worshippers and travelers.
