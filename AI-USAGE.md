# AI Usage

## 1. How I used AI
Used AI to outline the boilerplate for google_generative_ai and image_picker. I drafted the _testGemini() logic myself to chain the image bytes, environment variables, and the API payload together.

## 2. Where the AI got it wrong
The AI confidently gave me deprecated model endpoints (gemini-1.5-flash and gemini-2.5-flash) which crashed the app. I had to read the Dart VM stack trace to find the current active endpoint (gemini-3.6-flash). The AI also completely missed a typo I made in my .env key mapping (GEMINI_API_SKEY), which I had to catch and fix myself.
## 3. Who wrote what