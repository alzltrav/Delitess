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


September 21, 2026

## 1. How I used AI


## 2. Where the AI got it wrong

## 3. Who wrote what