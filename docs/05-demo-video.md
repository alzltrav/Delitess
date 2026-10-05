# Demo video

**File:** Provided privately via a Google Drive link in the 

**Canvas submission comments** (omitted from this public GitHub repository to protect personal on-camera video/audio privacy).  

**Length:** 12 minutes 45 seconds  

**Recorded on:** Personal Computer (Windows 11 / Flutter `DevicePreview` & VS Code)

## What it shows

A timestamped breakdown of the walkthrough so a viewer can skip directly to each section:

- **0:00 - 0:27** — **Introduction:** What DELITESS is and who it is for

- **0:27 - 1:09** — **The Problem:** The visual dish discovery gap and cluttered recipe blogs

- **1:10 - 3:51** — **Live App Demo:** End-to-end user journey across Home, Trending Carousel, Dark Mode toggle, AI photo-to-recipe generation (*Classic Shakshuka*), local bookmarking to Saved, and live AI text search (*"burger"*)

- **3:52 - 6:02** — **Tech Stack & Architecture:** Flutter & Material 3, Google Gemini (`gemini-3.6-flash`) structured JSON output, `shared_preferences` with Base64 image encoding, and `.env` key isolation

- **6:03 - 9:02** — **AI Usage & Authorship:** How I used Anthropic Claude (Sept 20–23) and Google Gemini (Sept 27–Oct 3), and a code-level walkthrough of who wrote what

- **9:02 - 12:04** — **Challenges & How I Solved Them:** 
Debugging 404 deprecated endpoints & 503 timeouts, fixing the hardcoded cuisine tag, refactoring hardcoded hex colors for Dark Mode, and unwrapping JSON lists vs. maps in Search

- **12:05 - 12:45** — **What's Next for DELITESS:** Roadmap for live camera capture, dietary/macro filters, and cloud sync with grocery checklists

## Summary of Key Walkthrough Points

- **Main user journey end-to-end:** Launching the Home screen, toggling persistent Dark Mode, selecting a food photo from the device gallery via `AskAiComposer` (or entering a text query like `"burger"` in `SearchScreen`), viewing the dynamically populated `RecipeDetailScreen` (title, prep time, cuisine, ingredients, and numbered steps), and bookmarking the recipe into the persistent `SavedScreen` tab.

- **Device & media features:** Uses `image_picker` to read local gallery image files into raw `Uint8List` memory bytes (`DataPart('image/jpeg', bytes)`) for multimodal Gemini vision analysis, and renders saved local photos offline via `Image.memory()`.

- **What I am proudest of:** Building the end-to-end multimodal AI photo-to-recipe pipeline combined with Base64 image persistence in `SavedRecipeManager`—allowing users to turn any meal photo into a structured recipe and keep both the recipe text and uploaded photo thumbnail saved locally across app restarts.