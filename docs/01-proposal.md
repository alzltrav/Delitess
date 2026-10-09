# Proposal

## The problem, in one sentence

A home cook who already has ingredients on hand, or who saw a dish online, has to scroll through an entire video or social post before reaching the actual recipe, and DELITESS gets them straight to the ingredients and steps instead[cite: 40].

## Who it is for

- Home cooks, including myself, who want to cook with what they already have or with a dish they saw online, without searching all over social media for a matching recipe[cite: 40].
- People that scroll through TikTok, Instagram, or YouTube videos, or long blog posts, past ads and personal stories, to reach the ingredient list and steps[cite: 40].

## Core features

### MVP Features (~17.5 hours total)

| # | Feature | Status | Flutter pieces it needs | Honest estimate |
| :---: | :--- | :---: | :--- | :--- |
| 1 | **Search by dish/ingredient (Home + Search Results)** | keep | `TextField`, `http` / API package call, `ListView.builder`, `Card` | 6 hrs (network call is genuinely new, list rendering is practiced from m5a3–m5a5)[cite: 40] |
| 2 | **Recipe Detail screen** | keep | `Scaffold`, `AppBar`, `Container` + `BoxDecoration`, `Column`/`Row`, `Image.network` | 4 hrs (layout matches m4a4, but m4a4 used hardcoded data and had more AI help; wiring in real API data adds time) |
| 3 | **Save toggle** | keep | `IconButton`, `setState` | 2 hrs (matches the Attack button pattern in m5a5)[cite: 41] |
| 4 | **Saved Recipes list + empty state** | keep | `ListView.builder`, conditional empty-state widget | 2.5 hrs (matches DexList/DexHome, already built twice)[cite: 41] |
| 5 | **Ask AI composer** | keep, scoped down | `TextField`, `IconButton`, routes into Search Results | 3 hrs (variant of the add-monster TextField dialog in m5a5, plus routing logic buffer)[cite: 41] |

### Stretch Goals
1. **AI photo identification (`image_picker` + Gemini API via `google_generative_ai`):** Allows picking a food photo from the gallery and sending it alongside a prompt to identify the dish and return structured recipe details[cite: 41, 42].
2. **AI link parsing:** Paste a social link, extract the dish name from the caption/title[cite: 41].
3. **Cook Mode:** Guided, step-by-step cooking view[cite: 41].

## Out of scope, and why

- **Multi-user accounts, social sharing, and cloud sync:** Two different people do not need to see the same data[cite: 41]. DELITESS is single-user with no login and no sharing feature, so saved recipes belong only on the device that saved them[cite: 41]. A cloud database (Firebase/Supabase) adds unnecessary account and API key management overhead[cite: 42].
- **Relational database (`sqflite` / `drift`):** At 10 to 20 saved recipes in a realistic week of home-cook use (staying well under 100 even for heavy users), a relational database adds schema and migration overhead for nothing the app actually needs.
- **Live in-app camera viewfinder (`camera` package):** The app only needs to pick an existing image or invoke the system picker via `image_picker`, not run a live viewfinder, avoiding mobile-only platform setup[cite: 42].
- **Social link parsing and Cook Mode:** Kept out of scope to focus on stabilizing local storage, text search, and multimodal API calls within the available build timeframe[cite: 41].

## Data the app remembers, and where it is saved

- **Choice:** `shared_preferences`, storing one JSON-encoded list under a single key (`saved_recipes` / `saved_recipes_list`)[cite: 41, 43].
- **Tradeoff accepted:** `shared_preferences` rewrites the whole list on every save and cannot be queried, which is acceptable for 10 to 100 records[cite: 42].
- **Saved data shape:**
  - `SavedRecipe`: `id` or slug, `title`, `thumbnailUrl` / `imageBase64`, `source` (TheMealDB / AI-identified label), `ingredients` (`List<String>`), `steps` (`List<String>`), and `savedAt` timestamp[cite: 42, 43].
  - Theme state: Boolean (`is_dark_mode`) toggling Light and Dark mode.

## Risks

- **Risk 1: AI misidentification and unproven multimodal API mechanics (`google_generative_ai`):** Sending an image alongside a prompt was not covered in course exercises. Mitigated by running an early one-hour spike sending a test image to Gemini, enforcing JSON output formatting, and wrapping calls in try/catch blocks with mounted checks and user-facing notifications for API timeouts[cite: 42, 44].
- **Risk 2: Untested persistence across restarts:** Prior course exercises did not persist state past an app restart[cite: 44]. Mitigated by completing an isolated `shared_preferences` spike before building the Saved Recipes screen[cite: 42, 44].
- **Risk 3: API key exposure in public repositories:** A Gemini API key is a Tier 1 secret that must never be committed or shipped in client-side web builds. Handled by keeping `.env` git-ignored locally, providing `.env.example`, and using offline fallback data when no key is injected[cite: 42, 43].

## Changes since the last version

| Section | Prelim Said | Revised Proposal Said | Final Project Implementation |
| :--- | :--- | :--- | :--- |
| **Core features** | AI photo/link identification treated as core, same weight as search and save[cite: 44]. | AI photo/link identification moved to stretch; composer bar stays core but starts text-only[cite: 44]. | De-risked the Gemini API spike early and delivered both core text search and multimodal photo-to-recipe generation in the final UI. |
| **Data / persistence** | Not addressed[cite: 44]. | `shared_preferences` named, with a defended tradeoff and a concrete `SavedRecipe` shape[cite: 42, 44]. | Implemented `SavedRecipeManager` with `shared_preferences`, adding Base64 encoding for gallery photos and persisting dark mode preferences[cite: 42, 70]. |
| **Risks** | One risk named (AI accuracy)[cite: 45]. | Two risks: AI risk widened to include unproven API/image mechanics, plus a new persistence risk[cite: 44, 45]. | Both risks resolved via early standalone spikes, structured JSON generation, and error handling for 503 timeouts[cite: 42, 44]. |