# AI Usage

September 20, 2026
## 1. How I used AI

Commit link: [https://github.com/alzltrav/Delitess_app/commit/76718996773e38d796010047508c912de9b02011#diff-e61eb31d013d12616f5532636a88cfa63631dda8f7829e5424e68542214d1608]

Used AI to outline the boilerplate for google_generative_ai and image_picker. I drafted the _testGemini() logic myself to chain the image bytes, environment variables, and the API payload together.

## 2. Where the AI got it wrong

commit link: [https://github.com/alzltrav/Delitess_app/commit/76718996773e38d796010047508c912de9b02011#diff-e61eb31d013d12616f5532636a88cfa63631dda8f7829e5424e68542214d1608]

The AI confidently gave me deprecated model endpoints (gemini-1.5-flash and gemini-2.5-flash) which crashed the app. I had to read the Dart VM stack trace to find the current active endpoint (gemini-3.6-flash). The AI also completely missed a typo I made in my .env key mapping (GEMINI_API_SKEY), which I had to catch and fix myself.

## 3. Who wrote what

Local Storage (_loadTaps and _handleTap): I wrote the logic to save the tap counter. The AI explained how Future and await work, but I was the one who structured the functions to ensure the UI updates synchronously with setState while saving to disk asynchronously. I also debugged the swapped read/write logic.

Gemini API Spike (_testGemini): I drafted the function to handle the AI response. The AI gave me the package names and payload format, but I wrote the sequence to pick an image from the gallery, convert it to bytes, check the .env file for the API key, and pass everything to the Gemini model.


September 21-23, 2026

### 1. How I used AI
I used AI to help translate my Midterm Figma mockups into Flutter code. The AI generated the boilerplate for the `ThemeData`, custom modular widgets (`RecipeCard`, `AskAiComposer`), and the `CustomScrollView` for the Recipe Details screen. 

### 2. Where the AI got it wrong
The AI initially tried to make my Search results page fully dynamic, which violated the static requirements of my Midterm mockups. I had to prompt it to revert to a hardcoded "Spicy Garlic Noodles" card to match my Figma design exactly. 

### 3. Who wrote what
**UI Layouts:** The AI provided the structural code (`ListView`, `SliverAppBar`, `Scaffold`), but I provided the exact HEX codes, padding values, and Unsplash image URLs to ensure it matched my specific design system.
**Navigation:** The AI provided the `Navigator.push` syntax, but I mapped out the routing logic to ensure the `AppNavBar` properly swapped between the Home and Saved states using `setState`.

September 27, 2026

### 1. How I used AI
I used AI to help audit my repository for the M8A5 Security Checklist requirement and to translate a Mac/Linux bash command (`grep`) into a Windows PowerShell equivalent (`Select-String`).

### 2. Where the AI got it wrong
The AI initially told me to run a Mac/Linux command (`grep`) in my Windows terminal to check my git history, which threw a CommandNotFoundException. It corrected it to `Select-String` once I provided the error log.

### 3. Who wrote what
**Security Checklist:** The AI generated the Markdown table formatting based on the professor's template, and I verified the evidence manually by running the terminal commands and checking my `.gitignore` and `.env.example` files.

September 29, 2026

### 1. How I used AI
I used AI to restructure the `RecipeDetailScreen` to accept dynamic data and to rewrite the `_testGemini()` function. The AI helped configure the Gemini API to return a strict JSON schema and mapped that JSON directly into the UI parameters.

### 2. Where the AI got it wrong
The AI gave me the deprecated `gemini-1.5-flash` model endpoint again, which immediately caused a 404 error. I had to point out the mistake so it could correct the code to `gemini-3.6-flash`. 

### 3. Who wrote what
**Dynamic UI Integration:** The AI wrote the JSON parsing logic and the `...map()` spread operators for the lists.
**Debugging:** I ran the execution and diagnosed the resulting 503 Server Error (High Demand) from Google's API, deciding to pause testing until the servers stabilized.