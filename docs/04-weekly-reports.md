# Weekly reports

---

## Week 3 (Sept 28 to Oct 4, 2026)

**Done this week**
- Refactored `RecipeDetailScreen` to accept dynamic parameters (`title`, `time`, `cuisine`, `imageBytes`, `ingredients`, `instructions`) and connected `_testGemini()` in `lib/main.dart` using `GenerationConfig(responseMimeType: 'application/json')` (`abccb1a`).
- Added graceful `SnackBar` error handling when the Gemini API returns 503 high-demand server timeouts (`7b24eeb`).
- Built `SavedRecipeManager` (`lib/saved_recipe_manager.dart`) using `shared_preferences` and Base64 image encoding so bookmarked recipes and uploaded gallery photos persist across restarts (`18da76a`, `9c50ec5`).
- Built `ThemeController` (`lib/theme/theme_controller.dart`) using `ValueNotifier<ThemeMode>` and refactored all screens and custom widgets to support persistent Dark Mode (`18da76a`, `9c50ec5`).
- Upgraded `SearchScreen` to generate live AI recipes for any text query (such as `"burger"`) with keyword-matched food photography and JSON list/map unwrapping (`9c50ec5`).
- Finalized `AI-USAGE.md`, security audit docs, presentation slides, and walkthrough video.

**In progress**
- None — all application features and documentation are 100% complete.

**Blocked or stuck on**
- Hit a 404 error when an AI snippet reverted the model name to `gemini-1.5-flash` (fixed back to `gemini-3.6-flash`), followed by a temporary 503 Server Error from Google's API during peak hours.
- Toggling Dark Mode initially left cards bright cream due to hardcoded hex colors in child widgets, and searching `"burger"` initially fell back to `"Spicy Garlic Noodles"` when Gemini returned a JSON list instead of a map. Both were debugged and resolved in commit `9c50ec5`.

**Decisions made, and why**
- Chose to encode uploaded `Uint8List` gallery photos as Base64 strings inside `SharedPreferences` rather than requiring an external cloud storage bucket, keeping the app fast, private, and 100% functional offline.
- Used `ValueNotifier<ThemeMode>` for Dark Mode state management instead of adding heavy third-party state packages.

**Hours spent, roughly:** 10 hours

**Next week I will:**
- Present and submit the completed DELITESS final project.

---

## Week 2 (Sept 21 to Sept 27, 2026)

**Done this week**
- Translated Midterm Figma mockups into a cohesive Flutter `ThemeData` and spacing system (`lib/theme/app_spacing.dart`) (`d61ec24`).
- Built modular custom widgets: `RecipeCard`, `TrendingRecipeCard`, `AskAiComposer`, and `AppNavBar` (`d61ec24`, `03b677a`).
- Implemented the auto-scrolling horizontal `Trending Recipes` carousel with `Timer.periodic` and mouse/trackpad drag support (`03b677a`).
- Built `SearchScreen`, `SavedScreen`, and `RecipeDetailScreen` (using `CustomScrollView` and `SliverAppBar`) and wired route navigation (`eeb5a6c`, `b4ccbc9`).
- Audited repository history for leaked secrets using Windows PowerShell (`Select-String`) for the security checklist (`b4ccbc9`).

**In progress**
- Connecting the live Gemini JSON response to dynamically populate `RecipeDetailScreen`.

**Blocked or stuck on**
- Horizontal scrolling in `DevicePreview` on Windows didn't respond to mouse dragging until I configured `MaterialScrollBehavior().copyWith(dragDevices: ...)`.

**Decisions made, and why**
- Kept the Week 2 `SearchScreen` aligned with the static Figma mockup milestone first so the UI layout was verified before wiring dynamic JSON parsing in Week 3.

**Hours spent, roughly:** 9 hours

**Next week I will:**
- Wire Gemini structured JSON outputs directly into `RecipeDetailScreen` and `SearchScreen`, and persist bookmarked recipes with `shared_preferences`.

---

## Week 1 (Sept 14 to Sept 20, 2026)

**Done this week**
- Set up the Flutter project repository, configured `.gitignore` and `.env` with `flutter_dotenv`, and added `shared_preferences`, `image_picker`, and `google_generative_ai` (`e24a7ff`).
- Built and verified the `shared_preferences` persistent counter prototype (`_loadTaps` and `_handleTap`) (`e24a7ff`).
- Completed the multimodal Gemini API spike (`_testGemini()`), picking a food image from the gallery, converting it to `Uint8List` bytes, and generating a recipe in the debug console (`e24a7ff`, `a894162`).

**In progress**
- Designing and scaffolding the main UI screens from the Figma mockups.

**Blocked or stuck on**
- Encountered `404 Not Found` crashes from deprecated Gemini model endpoints (`gemini-1.5-flash` and `gemini-2.5-flash`) and a typo in my `.env` key (`GEMINI_API_SKEY`). Fixed both by inspecting the Dart VM stack trace and switching to `gemini-3.6-flash`.

**Decisions made, and why**
- Chose `gemini-3.6-flash` for multimodal food image recognition because of its fast response time for combined image + text prompts.

**Hours spent, roughly:** 7 hours

**Next week I will:**
- Build the 4 core screens (Home, Search, Recipe Detail, Saved) and custom design system components.

---