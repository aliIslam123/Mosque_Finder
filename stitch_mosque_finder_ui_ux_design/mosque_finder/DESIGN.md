---
name: Mosque Finder
colors:
  surface: '#f0fdf2'
  surface-dim: '#d0ddd4'
  surface-bright: '#f0fdf2'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#eaf7ed'
  surface-container: '#e4f1e7'
  surface-container-high: '#deebe1'
  surface-container-highest: '#d9e6dc'
  on-surface: '#131e18'
  on-surface-variant: '#3f4941'
  inverse-surface: '#28332c'
  inverse-on-surface: '#e7f4ea'
  outline: '#6f7a71'
  outline-variant: '#bec9bf'
  surface-tint: '#066d40'
  primary: '#005a34'
  on-primary: '#ffffff'
  primary-container: '#167447'
  on-primary-container: '#9ff7be'
  inverse-primary: '#82d8a2'
  secondary: '#006d3f'
  on-secondary: '#ffffff'
  secondary-container: '#97f7b9'
  on-secondary-container: '#007443'
  tertiary: '#694700'
  on-tertiary: '#ffffff'
  tertiary-container: '#885e00'
  on-tertiary-container: '#ffe0b2'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#9ef5bd'
  primary-fixed-dim: '#82d8a2'
  on-primary-fixed: '#002110'
  on-primary-fixed-variant: '#00522f'
  secondary-fixed: '#97f7b9'
  secondary-fixed-dim: '#7bda9f'
  on-secondary-fixed: '#00210f'
  on-secondary-fixed-variant: '#00522e'
  tertiary-fixed: '#ffdeac'
  tertiary-fixed-dim: '#feba3a'
  on-tertiary-fixed: '#281900'
  on-tertiary-fixed-variant: '#604100'
  background: '#f0fdf2'
  on-background: '#131e18'
  surface-variant: '#d9e6dc'
typography:
  display-lg:
    fontFamily: IBM Plex Sans
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 44px
  headline-lg:
    fontFamily: IBM Plex Sans
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 34px
  headline-md:
    fontFamily: IBM Plex Sans
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 30px
  headline-sm:
    fontFamily: IBM Plex Sans
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 26px
  body-lg:
    fontFamily: IBM Plex Sans
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 26px
  body-md:
    fontFamily: IBM Plex Sans
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 22px
  body-sm:
    fontFamily: IBM Plex Sans
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 18px
  label-lg:
    fontFamily: IBM Plex Sans
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
  label-md:
    fontFamily: IBM Plex Sans
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
  label-sm:
    fontFamily: IBM Plex Sans
    fontSize: 10px
    fontWeight: '500'
    lineHeight: 14px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  margin: 1rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
---

## Brand & Style

The design system establishes a quiet, purposeful, and profoundly functional identity tailored for everyday Muslim worshipers and travelers across Egypt and the MENA region. The core aesthetic merges Modern Islamic restraint with crisp architectural minimalism. The emotional response sought is absolute clarity, peace, and practical utility—eliminating cognitive clutter during high-intent moments (such as navigating to Friday congregational prayers or verifying clean ablution facilities).

Visual decisions prioritize:
- **Right-to-Left (RTL) First Architecture**: Flow, information pacing, structural hierarchy, and directional visual anchors reflect native Arabic reading behavior.
- **Modern Utilitarianism**: Zero gratuitous ornamentation. Spiritual respect is honored through clarity, generous spacing, legible typography, and structured layout systems rather than pastiche arches or complex filigree.
- **Pragmatic Field Verification**: Built for outdoor legibility in intense Egyptian sunlight, demanding high optical contrast, resilient micro-borders, and immediate status-badge differentiation.

## Colors

The palette is anchored in traditional, deep botanical green paired with clean daylight neutrals and crisp semantic indicators.

### Key Functional Tones
- **Primary Green (`#167447`)**: Used for core brand identity, primary interactive targets, navigation active indicators, and critical prayer indicators.
- **Background (`#F8FAF8`)**: An ultra-soft, cool-tinted bone wash that eliminates eye strain while preserving daylight vibrancy.
- **Surface (`#FFFFFF`)**: Pure crisp white reserved for lifted cards, bottom sheets, input fields, and modal containers.
- **Main Text (`#17221C`)**: High-contrast, near-black charcoal with deep green undertones to ensure pristine legibility under intense outdoor lighting.
- **Secondary / Supporting Text (`#6B756E`)**: Low-strain muted sage-slate for distance indicators, timestamps, address paths, and meta-data.
- **Border & Divider (`#E6EAE7`)**: Subtle structural boundaries applied at 1px thickness to establish distinct content separation without visual friction.

### Status Indicators & Tiers
- **Verified Green**: Foreground `#218653` over Container `#EAF6EF` (used for verified prayer rooms, official Azhar listings, and active clean facilities).
- **Unverified Amber**: Foreground `#D99A16` over Container `#FEF7E6` (used for community-submitted locations, crowd-sourced prayer timing updates, or temporary closures).
- **Flagged / Warning Red**: Foreground `#D64545` over Container `#FDF0F0` (used for verified closures, prayer room accessibility issues, or disputed prayer times).

## Typography

Typography relies on `IBM Plex Sans` (configured with the Arabic script extension). This geometric humanist letterform preserves technical balance, crisp stroke terminals, and open counters—rendering complex Arabic ligatures and diacritics legibly on high-density mobile screens.

### Rules & Hierarchy
- **Arabic Text Rendering**: Line heights are expanded by 10–15% compared to typical Latin defaults to gracefully accommodate Arabic ascenders, descenders, and accent marks (tashkeel) without clipping.
- **Numerals**: Eastern Arabic numerals (١، ٢، ٣) are used for religious timings, prayer schedules, and formal metadata, while standard Indo-Arabic figures (1, 2, 3) are supported for distance meters and system inputs.
- **Weight Application**: Use `700` exclusively for large screen headlines; reserve `600` for structural hierarchy (card titles, tab titles, interactive labels) and `400` for conversational, body, and informational copy.

## Layout & Spacing

The layout is built for fluid touch experiences on mobile interfaces, operating on a strict 4px/8px incremental rhythm.

### Spatial Logic
- **Margins & Safe Zones**: A standard outer horizontal canvas margin of `16px` (`margin: 1rem`) is applied on mobile viewports, expanding to `24px` on tablet views. Bottom screens feature an intrinsic `88px` padding buffer to ensure interactions sit clear of the persistent bottom navigation bar.
- **RTL Fluidity**: All margin, padding, flex, and grid rules are applied logically using start and end assignments (`margin-inline-start`, `padding-inline-end`). Back buttons point to the right, progress indicators advance from right to left, and horizontal swipe carousels paginate from right to left.
- **Breakpoints**:
  - Compact (Mobile): 320px–480px. Single column stacked layouts, full-width bottom sheets.
  - Medium (Large Phablets & Foldables): 481px–768px. Multi-pane modal presentations with centered sheet dialogs.

## Elevation & Depth

Visual hierarchy uses a refined hybrid approach: clean tonal containment supported by ultra-diffused, ambient drop shadows and 1px borders (`#E6EAE7`). This avoids heavy skeuomorphic clutter while keeping floating map elements clearly separated from geographic layers.

### Elevation Hierarchy
- **Level 0 (Base Canvas)**: Background `#F8FAF8`, completely flat.
- **Level 1 (Structural Cards & List Items)**: Surface `#FFFFFF`, bounded by `1px solid #E6EAE7`, accompanied by shadow `0 1px 3px rgba(23, 34, 28, 0.04)`.
- **Level 2 (Floating Action Buttons & Map Controls)**: Surface `#FFFFFF`, border `1px solid #E6EAE7`, shadow `0 4px 12px rgba(23, 34, 28, 0.08)`.
- **Level 3 (Sticky Bottom Navigation)**: Fixed surface `#FFFFFF` with an upward divider `1px solid #E6EAE7` and shadow `0 -2px 10px rgba(23, 34, 28, 0.03)`.
- **Level 4 (Modals & Sliding Bottom Sheets)**: Surface `#FFFFFF` with a top-oriented soft ambient shadow `0 -8px 24px rgba(23, 34, 28, 0.12)`, anchored above an opaque backdrop overlay of `rgba(23, 34, 28, 0.40)`.

## Shapes

The geometric signature uses restrained, purposeful radii:
- **Interactive Inputs & Buttons**: 8px (`rounded-md`) to 12px for compact, sturdy ergonomics.
- **Cards & Visual Containers**: 12px to 16px (`rounded-lg` / `rounded-xl`), creating soft structural compartments without looking overly playful.
- **Bottom Sheets**: 24px corner radius applied strictly to the top-start and top-end borders.
- **Pills & Badges**: Fully rounded (`9999px`) for state chips, verified tags, and micro metadata.

## Components

### Buttons
- **Primary Action**: Solid `#167447` background, `#FFFFFF` text, `12px` corner radius. Minimum touch target height of `48px`. Focused states feature a `2px` inset outline.
- **Secondary / Outlined**: `#FFFFFF` background, `1px solid #E6EAE7`, `#17221C` text. Provides clear fallback affordance for alternate actions.
- **Text / Ghost**: Transparent fill, `#167447` bold typography, `8px` internal padding, ideal for header action items.

### Cards
- Constructed on `#FFFFFF` surfaces with `1px solid #E6EAE7` borders and `16px` internal padding. Mosque summary cards feature an RTL horizontal layout: thumbnail preview positioned at the end or inline-start, mosque title, distance indicator, and prayer timing tag positioned cleanly within the reading line.

### Status Badges
- Strict badge pairing:
  - **موثق (Verified)**: `#218653` text on `#EAF6EF` container with verified checkmark outline icon.
  - **غير موثق (Unverified)**: `#D99A16` text on `#FEF7E6` container with clock/warning outline icon.
  - **غير متاح / تم الإبلاغ (Flagged)**: `#D64545` text on `#FDF0F0` container with information outline icon.
- Applied at `8px` horizontal and `4px` vertical padding with `label-sm` typography and `9999px` corner radius.

### Input Fields & Search
- Surface `#FFFFFF`, height `48px`, border `1px solid #E6EAE7`, `12px` border radius. Search bar features an integrated outline search icon aligned to the inline-start (right) and a clear button at the inline-end (left).

### Fixed Bottom Navigation Bar
- A persistent 4-tab bar fixed to the bottom viewport with an intrinsic container height of `64px` plus safe-area padding:
  1. **الخريطة (Map)**
  2. **المساجد (Mosques)**
  3. **المجتمع (Community)**
  4. **الإعدادات (Settings)**
- Inactive items: `#6B756E` outline icon (24px) + `11px` label.
- Active items: `#167447` filled/accented icon + `11px` weight `600` typography accompanied by an active micro-dot indicator.

### Bottom Sheet (Mosque Detail Drawer)
- Sliding surface with `24px` top corner radius. Includes a subtle grab-handle (`4px x 36px`, color `#E6EAE7`) centered at the top. Houses comprehensive metadata: prayer times (الفجر، الشروق، الظهر، العصر، المغرب، العشاء), ablution and women's prayer area availability, accessibility ramps, and crowd-sourced condition updates.