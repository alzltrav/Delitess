**Live demo:** https://alzltrav.github.io/Delitess/

**Demo video:** Submitted privately via Google Drive in the Canvas submission comments (see [`docs/05-demo-video.md`](docs/05-demo-video.md) for full timestamps and summary).

**Course:** Applications Development and Emerging Technologies (6ADET), Holy Angel University

**Author:** Travis Alzola

This repository lives in the author's own GitHub account and is public on
purpose. There is no `student.json` here and there should not be one: see
[`docs/06-security-and-privacy.md`](docs/06-security-and-privacy.md) for what a public repo means for secrets and
personal data.

---

# DELITESS

![Builds with Flutter and AI](https://img.shields.io/badge/Builds%20with-Flutter%20%26%20AI-02569B?style=for-the-badge&logo=flutter&logoColor=white)

> **AI Disclosure:** Built with assistance from **Anthropic Claude** (initial prototyping and UI scaffolding through Sept 23) and **Google Gemini** (dynamic JSON integration, local persistence, and dark mode polish). For a complete log of prompts, debugging cases, commit links, and code authorship, see [AI-USAGE.md](./AI-USAGE.md).

## 1. Overview

**DELITESS** is an AI-powered recipe discovery and bookmarking application built with Flutter and the Google Gemini API (`gemini-3.6-flash`). It allows users to browse curated dishes, snap or upload photos of food from their gallery, or search any craving by text to generate instant, step-by-step recipes. It is designed for home cooks who want quick, ad-free meal inspiration from ingredients or dishes they see.

## 2. Setup and installation

- **Environment:** Built with Flutter (`sdk: ^3.8.0`).
- **Clone:**
  ```bash
  git clone [https://github.com/alzltrav/Delitess.git](https://github.com/alzltrav/Delitess.git)
  cd Delitess
  ```
- **Dependencies:**
  ```bash
  flutter pub get
  ```
- **Configuration:** Copy `.env.example` to a new `.env` file in the root directory and add your Gemini API key:
  ```env
  GEMINI_API_KEY=YOUR_API_KEY_HERE
  ```
  *(Never commit the real `.env` file!)*

## 3. How to run it

Run the app on Chrome using:
```bash
flutter run -d chrome
```
When the app boots, it launches inside a `DevicePreview` mobile frame on the **DELITESS Home Screen**, where you can toggle Light/Dark Mode, browse the auto-scrolling Trending Recipes carousel, search any dish by text, upload a food photo via the camera icon, or view your Saved recipes.

## 4. Features and usage

### Core Application Features (Final Build)
- **Curated Home & Auto-Scrolling Trending Carousel:** Browse featured Filipino and Asian dishes (*Chicken Adobo*, *Pancit Canton*, *Chicken Inasal*, *Beef Tapa*, *Sinigang na Baboy*, *Japanese Curry*) with smooth horizontal auto-scrolling (`Timer.periodic`) and mouse/touch drag support.
- **Multimodal AI Photo-to-Recipe Generation:** Tap the camera icon inside the search bar (`AskAiComposer`) to select a food image from your gallery. The app converts the photo into `Uint8List` bytes, sends it to `gemini-3.6-flash` with `responseMimeType: 'application/json'`, and dynamically opens `RecipeDetailScreen` with the dish title, cooking time, cuisine tag, bulleted ingredients, and numbered instructions.
- **Live AI Text Search:** Type any craving or ingredient (e.g., `"burger"`) into the search bar to dynamically generate a custom recipe on `SearchScreen` paired with keyword-matched food photography and a resilient offline fallback.
- **Persistent Recipe Bookmarks (`SavedRecipeManager`):** Tap the bookmark icon on any curated or AI-generated recipe to save or remove it locally using `shared_preferences`. Uploaded gallery photos are Base64-encoded so their thumbnails persist offline in the **Saved** tab.
- **Persistent Light & Dark Mode (`ThemeController`):** Tap the theme toggle icon in the top-right app bar to switch between Warm Cream (`#FAF6EF`) Light Mode and Deep Slate (`#181C1F`) Dark Mode, saved locally via `shared_preferences`.
- **Collapsible Detail Header & Error Handling:** Recipe detail screens use `CustomScrollView` and `SliverAppBar` for smooth image transitions, and API 503 server overload errors are caught gracefully with a user-facing `SnackBar`.

### Development Progression
- **Week 1 (Foundation & API Spike):** Built the initial `shared_preferences` persistence prototype and verified multimodal image recognition with `google_generative_ai` (`gemini-3.6-flash`), `image_picker`, and `flutter_dotenv`.
- **Week 2 (Midterm Design System & UI):** Implemented the 4 core screens (`HomeScreen`, `SearchScreen`, `RecipeDetailScreen`, `SavedScreen`), custom theme/spacing tokens, and modular widgets from the Figma mockups.
- **Week 3 (Full AI JSON Integration & Polish):** Wired structured Gemini JSON responses directly into `RecipeDetailScreen` and `SearchScreen`, built `SavedRecipeManager` and `ThemeController`, and cleaned up all prototype code.

## 5. Project structure

```text
Delitess/
├── .github/
│   └── workflows/
│       └── deploy.yml                # GitHub Actions workflow for GitHub Pages web deployment
├── docs/
│   ├── assets/                       # App screenshots and design system visuals
│   │   ├── detail.png
│   │   ├── home.png
│   │   ├── saved.png
│   │   └── search.png
│   ├── 01-proposal.md                # Final project proposal, scope, and storage decisions
│   ├── 02-mockup.md                  # Mockup embeds, wireframes, and screen flow diagram
│   ├── 03-design-system.md           # Color palette, typography, spacing tokens, and widgets
│   ├── 04-weekly-reports.md          # Weekly development logs (Weeks 1–3)
│   ├── 05-demo-video.md              # Walkthrough video metadata and timestamp index
│   ├── 06-security-and-privacy.md    # Completed & dated 25-point security audit checklist
│   └── README.md                     # Documentation folder index
├── lib/
│   ├── screens/
│   │   └── search_screen.dart        # Live Gemini AI text & photo search screen
│   ├── theme/
│   │   ├── app_spacing.dart          # Design system spacing tokens (xs: 8, sm: 16, md: 24, lg: 32)
│   │   └── theme_controller.dart     # ValueNotifier<ThemeMode> + SharedPreferences persistence
│   ├── widgets/
│   │   ├── app_nav_bar.dart          # Theme-aware BottomNavigationBar (Home & Saved tabs)
│   │   ├── ask_ai_composer.dart      # Pill search bar with gallery camera trigger
│   │   ├── recipe_card.dart          # List card supporting network URLs & Uint8List bytes
│   │   └── trending_recipe_card.dart # Horizontal carousel card with image fallback
│   ├── main.dart                     # App entry point, ThemeData, HomeScreen, & _testGemini()
│   ├── recipe_detail_screen.dart     # SliverAppBar detail view with dynamic ingredients & steps
│   ├── saved_recipe_manager.dart     # SharedPreferences JSON + Base64 image persistence helper
│   └── saved_screen.dart             # Saved recipes tab rendering local & network thumbnails
├── test/
│   └── widget_test.dart              # Flutter widget test suite
├── web/
│   ├── index.html                    # Web entry document
│   └── manifest.json                 # Web app manifest
├── .env.example                      # Safe placeholder template for GEMINI_API_KEY
├── .gitignore                        # Excludes .env, build/, and .dart_tool/ from Git
├── AI-USAGE.md                       # Complete AI disclosure log with commit links & authorship
├── LICENSE                           # MIT License
├── README.md                         # Project overview and setup guide
├── analysis_options.yaml             # Dart/Flutter linter configuration
└── pubspec.yaml                      # Project dependencies and asset declarations
```

## 6. Screenshots

| Home | Search | Recipe Details | Saved |
| :---: | :---: | :---: | :---: |
| ![Home](docs/assets/home.png) | ![Search](docs/assets/search.png) | ![Recipe Detail](docs/assets/detail.png) | ![Saved](docs/assets/saved.png) |

## 7. Known issues and next steps

- **Current state:** All core features—multimodal AI photo generation, live AI text search, persistent local bookmarking with Base64 thumbnails, and persistent Dark Mode—are 100% complete and functional.
- **Next steps:**
  1. Add direct live camera capture (`ImageSource.camera`) alongside gallery uploads.
  2. Introduce dietary and macro filters (calories, allergens, vegan, halal) in the Gemini prompt builder.
  3. Add cloud sync and an interactive grocery shopping checklist.

## 8. AI Usage

This project was built with AI assistance for the **"Builds with Flutter and AI"** badge. Please see [AI-USAGE.md](./AI-USAGE.md) for transparent logs of all AI interactions, prompts, debugging cases, commit links, and independent code contributions.

MIT License, see [LICENSE](./LICENSE).