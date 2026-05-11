# SuppsAI — HOTIRGHINI Version

SuppsAI is a SwiftUI iOS app concept for supplement discovery, label scanning, and stack planning. The HOTIRGHINI version uses a high-contrast dark interface, orange energy accents, seeded mock data, and a modular MVVM codebase so the app opens immediately in Xcode previews without any backend.

## Setup

1. Open `SuppsAI.xcodeproj` in Xcode 15.4 or newer.
2. Select the `SuppsAI` scheme.
3. Choose an iPhone simulator running iOS 17 or newer.
4. Build and run.

## API key placeholders

The current app ships with mock services for instant preview. Replace these placeholders before connecting production services:

- `OPENAI_API_KEY` in `SuppsAI/Info.plist`: `YOUR_OPENAI_API_KEY_HERE`
- `SUPPSAI_API_BASE_URL` in `SuppsAI/Info.plist`: `https://api.example.com`

Keep real API keys out of source control. For production, prefer a server-side proxy or encrypted configuration managed by your deployment pipeline.

## Architecture overview

The project follows MVVM and modular feature folders:

```text
SuppsAI/
├── App/                         # App entry, dependency container, root tabs
├── Core/
│   ├── DesignSystem/            # HOTIRGHINI colors, cards, badges
│   ├── Models/                  # Supplement, profile, scan result models
│   └── Services/                # Repository and AI service protocols/mocks
├── Features/
│   ├── Dashboard/               # Today view and featured supplements
│   ├── ScanLabel/               # Mock label scanner and AI explanation
│   ├── SupplementDetail/        # Supplement guide and safety details
│   ├── StackPlanner/            # Morning/evening stack schedule
│   ├── Profile/                 # User goal, diet, sensitivity, disclaimer
│   └── Onboarding/              # Goal-selection entry flow preview
└── Resources/                   # Info.plist and asset catalogs
```

### MVVM boundaries

- Views render state and user interactions only.
- View models own screen state and formatting logic.
- Services are protocol-driven, making the mock repository easy to replace with API-backed implementations.
- Seed data lives in `MockSupplementRepository` so previews and simulator runs work instantly.

## SwiftUI previews

Every major view includes a `#Preview` block:

- `RootTabView`
- `DashboardView`
- `SupplementDetailView`
- `ScanLabelView`
- `StackPlannerView`
- `ProfileView`
- `OnboardingView`

## App Store listing draft

**Name:** SuppsAI HOTIRGHINI

**Subtitle:** Smarter supplement stacks

**Description:**
SuppsAI helps you understand supplements before they enter your routine. Scan a label, compare ingredients, review evidence levels, and build a safer daily stack around your goals. The HOTIRGHINI version pairs a bold training-inspired interface with practical guidance for timing, dosage habits, and interaction checks. Use seeded recommendations to explore foundational nutrients, performance support, focus tools, sleep routines, and cleaner alternatives to high-stim blends.

SuppsAI is designed for education and planning, not medical diagnosis or treatment. Always review supplements with a qualified clinician when taking medication, managing a condition, pregnant, or planning surgery.

**Keywords:** supplements, AI, nutrition, creatine, vitamins, label scanner, wellness, stack planner, fitness, sleep, focus, health

**Screenshot mockups:**

1. `docs/app-store/screenshots/01-today.svg` — HOTIRGHINI dashboard and evidence picks.
2. `docs/app-store/screenshots/02-scan.svg` — Label scan risk score and warnings.
3. `docs/app-store/screenshots/03-detail.svg` — Supplement guide with dosage and safety notes.
4. `docs/app-store/screenshots/04-stack.svg` — Morning/evening stack planner.
5. `docs/app-store/screenshots/05-profile.svg` — Goal-aware user profile and safety disclaimer.
