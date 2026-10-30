# 🎬 Animation & Micro-Interaction System (Mosque Finder)

Mosque Finder incorporates Apple-inspired physics and micro-interactions designed to make the experience fluid, tactile, and natural.

---

## 1. Animation Philosophy

- **Subtle & Purposeful:** Animations serve as spatial orientation and cognitive continuity, not mere decorative clutter.
- **Natural Curves:** Primary easing is `Curves.easeOutCubic` and `Curves.easeOutBack` for organic deceleration.
- **Predictable Durations:**
  - Micro-interactions (taps, toggles): `150ms – 250ms`
  - Modal entries & Bottom sheets: `300ms – 400ms`
  - Staggered list reveals: `40ms – 60ms` stagger delay per element

---

## 2. Animation Catalog by Screen

### A. Splash Screen (`splash_screen.dart`)
1. **Geometric Mosque Vector Reveal:**
   - Soft scale from `0.85` to `1.0` combined with opacity fade-in (600ms).
   - Radial ambient pulse behind the emblem simulating spiritual dawn (`#F0FDF2`).
2. **Text & Feature Pills Stagger:**
   - Staggered vertical slide (`slideY` begin: 0.2, end: 0) with 100ms offset.
3. **Primary CTA "Find Now":**
   - Rises smoothly into view with subtle bouncing button physics.

---

### B. Interactive Map (`map_view.dart`)
1. **Radar Pulse (`PulseWidget`):**
   - Continuously expands an outer ring from 1.0 to 1.8x scale with fading alpha around user location pin.
2. **Dynamic Radius Expansion:**
   - When radius changes between 200m, 400m, and 800m, the dashed radius circle smoothly interpolates.
3. **Marker Selection:**
   - Active mosque pin pops upward by 6px with an active green halo.
4. **Bottom Mosque Preview Card:**
   - Slides up from bottom with `Curves.easeOutCubic` when tapping a map marker.

---

### C. Mosque List & Directory (`nearby_screen.dart`)
1. **Staggered Card Entrance:**
   ```dart
   MosqueListCard(...)
     .animate()
     .fadeIn(delay: (index * 60).ms, duration: 300.ms)
     .slideY(begin: 0.1, end: 0, delay: (index * 60).ms, duration: 300.ms, curve: Curves.easeOutCubic);
   ```
2. **Filter Chip Transitions:**
   - Smooth `AnimatedContainer` resizing when toggling between All, Verified, and Radius options.

---

### D. Qibla Compass (`compass_widget.dart` & `qibla_screen.dart`)
1. **Fluid Dial Rotation:**
   - Dial ring rotates clockwise/counter-clockwise with device heading changes.
2. **Kaaba Pointer Needle:**
   - Points continuously towards calculated azimuth angle (136°).
3. **Target Alignment Transition:**
   - When aligned within ±3 degrees of Kaaba:
     - Needle and center circle transition from Brand Green to Verified Emerald (`#218653`).
     - Ambient green alignment halo illuminates.
     - Tactile medium haptic feedback (`HapticFeedback.mediumImpact()`) vibrates the device.

---

### E. Persistent Shell Navigation (`main_shell.dart`)
1. **Active Tab Indicator:**
   - Smooth horizontal slide and size expansion of the active indicator dot under tab icons.
2. **Icon Scale Bounce:**
   - Tapping a tab triggers an instant 1.15x scale pulse.
