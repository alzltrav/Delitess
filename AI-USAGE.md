# AI Usage — DELITESS

**AI Assistants Used:** Anthropic Claude (Sept 20 – Sept 23, 2026) & Google Gemini (Sept 27 – Oct 3, 2026)  
**Repository:** [https://github.com/alzltrav/Delitess_app](https://github.com/alzltrav/Delitess_app)

---

## 1. How I used AI

### Entry 1 — September 20, 2026: Gemini API Spike & Image Picker Setup
- **Tool:** Anthropic Claude
- **The Request:** Asked for boilerplate code to integrate `google_generative_ai`, `image_picker`, and `flutter_dotenv` so the app could pick a food photo from the gallery and send it to the Gemini API.
- **What I kept or changed:** I kept the package imports and `Content.multi` payload structure, but I drafted the `_testGemini()` sequence myself to chain the gallery image bytes, `.env` API key check, and console output together. I also changed the model name from the deprecated `gemini-1.5-flash` to `gemini-3.6-flash` and fixed a typo in my `.env` variable (`GEMINI_API_SKEY` to `GEMINI_API_KEY`).
- **Commit link:** [e24a7ff](https://github.com/alzltrav/Delitess_app/commit/e24a7ff) / [7671899](https://github.com/alzltrav/Delitess_app/commit/76718996773e38d796010047508c912de9b02011)

### Entry 2 — September 21, 2026: Design System & Modular Home Screen UI
- **Tool:** Anthropic Claude
- **The Request:** Asked Claude to help translate my Midterm Figma mockups into reusable Flutter widgets (`RecipeCard`, `AskAiComposer`, `AppNavBar`) and set up a central `ThemeData` and spacing file (`AppSpacing`).
- **What I kept or changed:** I kept the stateless widget scaffolding (`Card`, `InkWell`, `TextField`, `BottomNavigationBar`), and customized all HEX color codes (`#FAF6EF`, `#3A4750`, `#8EC7E3`, `#C9E4EE`), border radii, and padding constants to match my Figma design system.
- **Commit link:** [d61ec24](https://github.com/alzltrav/Delitess_app/commit/d61ec24)

### Entry 3 — September 22, 2026: Auto-Scrolling Trending Carousel & Mouse Drag Support
- **Tool:** Anthropic Claude
- **The Request:** Asked how to build a horizontal "Trending Recipes" carousel (`TrendingRecipeCard`) that auto-scrolls on a timer and supports mouse/trackpad dragging in `DevicePreview`.
- **What I kept or changed:** I kept the `Timer.periodic` logic with `ScrollController.animateTo` and `MaterialScrollBehavior().copyWith(dragDevices: ...)`, and I replaced the placeholder URLs with curated Unsplash images for Filipino dishes (*Chicken Adobo*, *Pancit Canton*, *Chicken Inasal*, *Beef Tapa*).
- **Commit link:** [03b677a](https://github.com/alzltrav/Delitess_app/commit/03b677a)

### Entry 4 — September 23, 2026: Search Screen & SliverAppBar Recipe Detail Layout
- **Tool:** Anthropic Claude
- **The Request:** Requested a `SearchScreen` route triggered from the Home search bar and a `RecipeDetailScreen` using a collapsible `CustomScrollView` and `SliverAppBar` for recipe photos, ingredients, and numbered steps.
- **What I kept or changed:** I kept the `SliverAppBar` and `SliverToBoxAdapter` layout structure, wired the `Navigator.push` routes from `HomeScreen`, and prompted Claude to revert `SearchScreen` to a static "Spicy Garlic Noodles" card so it matched my Week 2 Figma mockup requirements before making it dynamic in Week 3.
- **Commit link:** [eeb5a6c](https://github.com/alzltrav/Delitess_app/commit/eeb5a6c) / [b4ccbc9](https://github.com/alzltrav/Delitess_app/commit/b4ccbc9)

### Entry 5 — September 27, 2026: Security Checklist Audit & Windows PowerShell Commands
- **Tool:** Google Gemini
- **The Request:** Asked Gemini to help audit my repository for the M8A5 Security Checklist requirement and to provide a terminal command to check my git history for leaked secrets on Windows.
- **What I kept or changed:** I kept the Markdown table formatting based on the course template, replaced the Linux `grep` command with Windows PowerShell `Select-String`, and verified the evidence manually against my `.gitignore` and `.env.example` files.
- **Commit link:** [b4ccbc9](https://github.com/alzltrav/Delitess_app/commit/b4ccbc9)

### Entry 6 — September 29, 2026: Structured JSON Output & Dynamic Recipe UI Injection
- **Tool:** Google Gemini
- **The Request:** Asked how to force the Gemini API to return a predictable JSON schema for uploaded food photos and dynamically populate `RecipeDetailScreen` with the generated title, cooking time, ingredients list, instructions list, and uploaded `Uint8List` image bytes.
- **What I kept or changed:** I kept the `GenerationConfig(responseMimeType: 'application/json')` setup, `jsonDecode` parsing, and the `...displayIngredients.map()` spread operator logic. I had to change the model string back to `gemini-3.6-flash` after the AI snippet used `gemini-1.5-flash`.
- **Commit link:** [abccb1a](https://github.com/alzltrav/Delitess_app/commit/abccb1a)

### Entry 7 — September 30, 2026: Graceful API Error Handling with SnackBar
- **Tool:** Google Gemini
- **The Request:** Asked for a clean way to notify the user in the UI when Google's Gemini servers return a `503 Server Error (UNAVAILABLE)` instead of only printing the exception to the debug console.
- **What I kept or changed:** I kept the `ScaffoldMessenger.of(context).showSnackBar` implementation inside the `catch (e)` block of `_testGemini()`, ensuring the loading dialog pops first (`if (mounted) Navigator.pop(context);`) before displaying the error banner.
- **Commit link:** [7b24eeb](https://github.com/alzltrav/Delitess_app/commit/7b24eeb)

### Entry 8 — October 3, 2026: Bookmark Persistence, Full Dark Mode Polish & Live AI Search
- **Tool:** Google Gemini
- **The Request:** Asked how to fix the hardcoded `'Filipino'` cuisine label on AI-generated recipes, persist bookmarked recipes into the `Saved` tab using `shared_preferences`, implement a persistent Dark Mode toggle using `ValueNotifier<ThemeMode>` across all custom widgets, remove dead Week 1 tap-counter code, and make `SearchScreen` generate live recipes for any query (such as `"burger"`).
- **What I kept or changed:** I kept `SavedRecipeManager` (with Base64 image encoding) and `ThemeController`, refactored hardcoded `#FAF6EF` and `#3A4750` colors across child widgets to use `Theme.of(context)`, added `imageBytes` thumbnail rendering to `RecipeCard`, and updated `SearchScreen` to unwrap both JSON lists and maps from Gemini with keyword-matched food photos.
- **Commit link:** [18da76a](https://github.com/alzltrav/Delitess_app/commit/18da76a) / [9c50ec5](https://github.com/alzltrav/Delitess_app/commit/9c50ec5)

---

## 2. Where the AI got it wrong

### Case 1: Deprecated Gemini Model Endpoints Causing 404 Crashes (Claude & Gemini)
- **The AI Output:** Both Claude (on Sept 20) and Gemini (on Sept 29) generated `GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey)` (and `gemini-2.5-flash`) when writing the API call.
- **The Problem:** `gemini-1.5-flash` is deprecated/unavailable on the v1beta endpoint, which immediately crashed the API call with a `GenerativeAIException: 404 Not Found` error. Claude also missed a typo I made in my `.env` key mapping (`GEMINI_API_SKEY`).
- **The Fix:** I read the Dart VM stack trace to find the active endpoint (`gemini-3.6-flash`), updated the `GenerativeModel` initialization in `lib/main.dart`, and fixed my `.env` variable name.
- **Commit link:** [e24a7ff](https://github.com/alzltrav/Delitess_app/commit/e24a7ff) and [abccb1a](https://github.com/alzltrav/Delitess_app/commit/abccb1a)

### Case 2: Over-Engineering the Week 2 Static Search Screen Prototype (Claude)
- **The AI Output:** On September 23, Claude initially tried to make my Search results screen dynamically filter data, which conflicted with the static UI requirements of my Week 2 Midterm Figma mockups.
- **The Problem:** The Week 2 milestone required a faithful static match to my Figma design ("Spicy Garlic Noodles" card with a simulated loading state) before hooking up live backend search in Week 3.
- **The Fix:** I prompted Claude to revert the search results view to the exact "Spicy Garlic Noodles" `RecipeCard` layout from my Figma design for the Week 2 deliverable, and later upgraded it to live Gemini JSON search in Week 3.
- **Commit link:** [eeb5a6c](https://github.com/alzltrav/Delitess_app/commit/eeb5a6c) and [b4ccbc9](https://github.com/alzltrav/Delitess_app/commit/b4ccbc9)

### Case 3: Hardcoded `'Filipino'` Cuisine Tag on AI-Generated Recipes (Gemini)
- **The AI Output:** When refactoring `RecipeDetailScreen` for dynamic AI data, Gemini left `const Text('Filipino')` hardcoded in the metadata row next to the cooking time and omitted `"cuisine"` from the Gemini JSON prompt.
- **The Problem:** When I tested the AI photo generator with a pan of Shakshuka, the app accurately generated "Classic Shakshuka" and its Mediterranean ingredients, but labeled the dish as `30 min · Filipino`.
- **The Fix:** I added an optional `cuisine` parameter to `RecipeDetailScreen`, updated the UI text to `widget.cuisine ?? 'Filipino'`, and added `"cuisine"` to the Gemini JSON schema in `lib/main.dart`.
- **Commit link:** [18da76a](https://github.com/alzltrav/Delitess_app/commit/18da76a)

### Case 4: Hardcoded Light-Mode Hex Colors & Search Fallback Bug (Gemini)
- **The AI Output:** In the first Dark Mode pass, Gemini configured `darkTheme` in `MaterialApp` but left `Color(0xFFFAF6EF)` and `Color(0xFF3A4750)` hardcoded in child widgets. In `SearchScreen`, it also assumed `jsonDecode(response.text!)` would always return a `Map` and defaulted to `"Spicy Garlic Noodles"` on error.
- **The Problem:** Toggling Dark Mode left cards and backgrounds stuck in light mode, and searching `"burger"` fell back to displaying `"Spicy Garlic Noodles"` when Gemini returned a JSON list `[{...}]` or hit a 503 error.
- **The Fix:** I shared my full widget files to replace hardcoded colors with `Theme.of(context)`, and updated `_performSearch` in `lib/screens/search_screen.dart` to unwrap both `List` and `Map` JSON outputs, match food photos by keyword, and build a dynamic fallback recipe matching the user's query.
- **Commit link:** [18da76a](https://github.com/alzltrav/Delitess_app/commit/18da76a) and [9c50ec5](https://github.com/alzltrav/Delitess_app/commit/9c50ec5)

---

## 3. Who wrote what

### What I Wrote & Structured Myself (With Files and Commits)
1. **Gemini Image-to-Bytes Pipeline & Environment Key Wiring (`lib/main.dart`, `.env`, `.gitignore`) — Commits [e24a7ff](https://github.com/alzltrav/Delitess_app/commit/e24a7ff) & [7b24eeb](https://github.com/alzltrav/Delitess_app/commit/7b24eeb):**  
   In my own words: I structured the `_testGemini()` execution flow in `lib/main.dart`. When the user taps the camera icon in `AskAiComposer`, my function opens the device gallery via `ImagePicker().pickImage()`, exits safely if the user cancels, converts the selected `XFile` into raw `Uint8List` memory bytes (`readAsBytes()`), retrieves `GEMINI_API_KEY` from `.env` using `flutter_dotenv`, and sends both the text prompt and `DataPart('image/jpeg', bytes)` to Gemini. I also debugged the `.env` key naming bug, diagnosed the 404 and 503 API status codes during live testing, and verified the live "Classic Shakshuka" generation.
2. **Design System Tokens, Curated Recipe Data & Screen Routing (`lib/main.dart`, `lib/theme/app_spacing.dart`, `lib/widgets/recipe_card.dart`, `lib/widgets/trending_recipe_card.dart`) — Commits [d61ec24](https://github.com/alzltrav/Delitess_app/commit/d61ec24), [03b677a](https://github.com/alzltrav/Delitess_app/commit/03b677a), [eeb5a6c](https://github.com/alzltrav/Delitess_app/commit/eeb5a6c), & [9c50ec5](https://github.com/alzltrav/Delitess_app/commit/9c50ec5):**  
   In my own words: I translated my Figma visual identity into the app by defining the spacing constants in `lib/theme/app_spacing.dart`, choosing the warm cream (`#FAF6EF`), slate (`#3A4750`), and sky blue (`#8EC7E3`) color palette, and curating the featured recipes (*Chicken Adobo*, *Pancit Canton*, *Chicken Inasal*, *Beef Tapa*, *Sinigang na Baboy*, and *Japanese Curry*). I also wired the bottom navigation index switching (`_selectedIndex`) between `HomeScreen` and `SavedScreen` and connected `_openRecipe()` so every card navigates cleanly to `RecipeDetailScreen`.
3. **Week 1 SharedPreferences Prototype & Final Code Cleanup (`lib/main.dart`) — Commits [e24a7ff](https://github.com/alzltrav/Delitess_app/commit/e24a7ff) & [9c50ec5](https://github.com/alzltrav/Delitess_app/commit/9c50ec5):**  
   In my own words: In Week 1, I wrote and debugged `_loadTaps()` and `_handleTap()` in `lib/main.dart` to learn how `SharedPreferences.getInstance()` reads and writes persistent data asynchronously while `setState()` updates the UI synchronously. In Week 3 (commit `9c50ec5`), after replacing that prototype with real bookmark and theme persistence, I removed the unused `_taps` variables and functions so the final codebase has zero dead filler code.

### AI-Written Piece Explained Clearly (With Files and Commits)
1. **JSON Serialization & Base64 Image Persistence (`lib/saved_recipe_manager.dart`, `lib/saved_screen.dart`, and `lib/recipe_detail_screen.dart`) — Commits [abccb1a](https://github.com/alzltrav/Delitess_app/commit/abccb1a), [18da76a](https://github.com/alzltrav/Delitess_app/commit/18da76a), & [9c50ec5](https://github.com/alzltrav/Delitess_app/commit/9c50ec5):**  
   - **What the AI wrote:** Google Gemini wrote the `SavedRecipeManager` helper class in `lib/saved_recipe_manager.dart`, the dynamic list spread rendering (`...displayIngredients.map()`) in `lib/recipe_detail_screen.dart`, and the `ValueNotifier<ThemeMode>` controller in `lib/theme/theme_controller.dart` (building on the initial widget scaffolding generated with Anthropic Claude in commits `d61ec24` and `b4ccbc9`).
   - **How it works:** Because `SharedPreferences` can only store primitive types like `List<String>` and cannot store complex Dart objects or raw `Uint8List` image files directly, `SavedRecipeManager.toggleRecipe()` takes a recipe's properties (`title`, `time`, `cuisine`, `imageUrl`, `ingredients`, `instructions`) and converts any local AI gallery photo (`Uint8List`) into a Base64 text string using `base64Encode(imageBytes)`. It then serializes the entire recipe `Map<String, dynamic>` into a single JSON string via `jsonEncode()` and saves the list under the `'saved_recipes_list'` key with `prefs.setStringList()`. When the user opens the **Saved** tab (`lib/saved_screen.dart`), `getSavedRecipes()` reads that `List<String>`, runs `jsonDecode()` on each entry to reconstruct the `Map`, and decodes `imageBase64` back into `Uint8List` via `base64Decode()` so `RecipeCard` and `RecipeDetailScreen` can render the exact gallery photo using `Image.memory()`.


### October 9, 2026 — Asset Repair & Design System Documentation Polish

- **Tool:** Google Gemini
- **Task / Feature:** Fixing broken Beef Tapa asset on Home screen and consolidating `docs/03-design-system.md` tables into Markdown.
- **AI Output / Suggestions:**
  - Provided a direct Unsplash food photography URL (`https://images.unsplash.com/photo-1544025162-d76694265947?...`) for `Beef Tapa` in `lib/main.dart` to replace the broken image link that was triggering the error fallback box.
  - Generated Markdown tables for the reusable `Components` list and `Changes since the last version` changelog in `docs/03-design-system.md`.`