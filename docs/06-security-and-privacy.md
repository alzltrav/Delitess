# Security and privacy

This repository is public. Fill this in honestly and date it; it is checked as
part of grading.

**Last checked:** 2026-10-05

## What this app stores

| Data | Where it lives | Who can see it |
| --- | --- | --- |
| Bookmarked recipes (`saved_recipes_list`, including recipe text and Base64-encoded food photo thumbnails) | On the device (`shared_preferences`) | Only that user |
| Theme preference (`is_dark_mode`) | On the device (`shared_preferences`) | Only that user |

## Secrets

- **Values my app needs at run time:** `GEMINI_API_KEY`
- **Where they live locally:** `.env`, which is git-ignored (with `.env.example` committed as a safe template)
- **Where the deploy workflow gets them:** Repository secrets (`Settings > Secrets and variables > Actions`), or omitted in static preview builds where `SearchScreen` safely falls back to local recipe generation
- **Anything my deployed web build carries that a visitor could read, and why that is acceptable:** Nothing — the `.env` file is excluded from version control, and no private API keys, tokens, or personal credentials are hardcoded in `lib/`.

## What protects the data on the service side

- Nothing leaves the device for storage — this app is fully local, uses `shared_preferences` for all saved recipes and theme settings, and does not have a backend database, Firestore, or Supabase attached.

## Checklist

- [x] `.env` (or `env.json`) is in `.gitignore`, and `.env.example` is committed
- [x] `git log -p | grep -i "api_key\|secret\|password\|token"` finds nothing real
- [x] No service account file, keystore or `service_role` key anywhere in the repo
- [x] Security rules or RLS policies written and tested, not left open *(N/A — fully local app with no cloud database)*
- [x] No real personal data in sample data, screenshots or the video *(demo video is provided privately via Canvas submission comments)*
- [x] No course or university credentials anywhere
- [x] Anyone whose data appears in a test was asked first *(only royalty-free Unsplash food photos and generic recipe text are used)*

---

## Detailed Security Audit (25-Point Checklist)

### Secrets and credentials

| # | Check | Yes / No / N/A | Evidence |
| --- | --- | --- | --- |
| 1 | No API key, token or password is hardcoded in `lib/`, including in comments and commented-out code | Yes | I reviewed my entire `lib/` folder; the Gemini API key is loaded dynamically using `dotenv.env['GEMINI_API_KEY']`. |
| 2 | Anything private is in a gitignored config or passed with `--dart-define`, with an example file committed | Yes | My `.env` file is gitignored, and the `.env.example` template provided by the professor is used to show where the key goes. |
| 3 | No keystore, `key.properties` or signing credential is in the repository | Yes | I checked the root and `android/` directories; no keystores or signing config files are present. |
| 4 | Git history is clean: I searched `git log -p` for password, secret, api key and token | Yes | I ran the `git log -p | grep -i -E "password|secret|api[_-]?key|token"` (and Windows PowerShell `Select-String`) command in my terminal and it returned no matches. |
| 5 | Any credential that was ever committed has been rotated | N/A | No credentials were ever committed to the repository history. |

### GitHub Actions

*Note: This project uses only the default static course template workflow (no custom secret-handling workflows).*

| # | Check | Yes / No / N/A | Evidence |
| --- | --- | --- | --- |
| 6 | No secret value is written literally in any workflow YAML file | Yes / N/A | Verified no secret values are written in `.github/workflows/`. |
| 7 | Secrets are stored in repository Actions secrets and read with `${{ secrets.NAME }}` | N/A | No custom secrets are echoed or hardcoded in workflows. |
| 8 | No workflow step echoes, dumps or debug-prints a secret, and I opened a recent run's log to confirm | Yes / N/A | Confirmed no workflow step prints or exposes any secret. |
| 9 | If I build a signed APK: the keystore is a base64 secret decoded to a file at build time, never printed | N/A | No signed APK workflow is used in this repository. |
| 10 | Uploaded build artifacts contain no key file, keystore or generated config | Yes / N/A | `.env` is gitignored and never uploaded as a build artifact. |
| 11 | Third-party actions are pinned to a commit SHA, not a moveable tag | N/A | Only the standard course template workflow is present. |
| 12 | Secret scanning and push protection are enabled on the repository | Yes | Enabled via public GitHub repository security settings. |

### Backend and security rules

*This app is fully local, uses `SharedPreferences`, and does not have a backend database, Firebase, or Supabase attached.*

| # | Check | Yes / No / N/A | Evidence |
| --- | --- | --- | --- |
| 13 | Firestore and Storage rules are not left open to anyone; they require an authenticated user | N/A | This app is fully local with no backend. |
| 14 | Rules restrict a user to their own documents where that makes sense | N/A | This app is fully local with no backend. |
| 15 | If Supabase: Row Level Security is on for every table | N/A | This app is fully local with no backend. |
| 16 | Firebase and Google API keys are restricted in the Google Cloud console to the APIs and app they are for | N/A | This app is fully local with no backend (the only key is for Gemini generative AI stored locally in `.env`). |
| 17 | I opened the app signed out and confirmed I could not read or write data I should not | N/A | This app is fully local with no backend authentication system. |
| 18 | Seed and sample data is invented, not real people's data | Yes | All names, ingredients, and times are generic mockup text, and all photos are pulled from Unsplash. |

### Input and app surface

| # | Check | Yes / No / N/A | Evidence |
| --- | --- | --- | --- |
| 19 | Input is validated before it is written, not only styled as valid in the UI | Yes | The search bar validates that the query `.trim().isNotEmpty` before executing a search or route push. |
| 20 | Nothing secret is recoverable from the built app, since a shipped binary can be unpacked | Yes | The app separates the Gemini API key into the local `.env` configuration rather than hardcoding it into the Dart source code. |

### Repository and privacy

| # | Check | Yes / No / N/A | Evidence |
| --- | --- | --- | --- |
| 21 | No student number, personal email, phone number or home address in the repository or in commit messages | Yes | My personal and academic information is kept strictly in my private workspace repository, not in the public app code. |
| 22 | No classmate's personal data in the repository | Yes | All data in the app is generic food and recipe mockup data. |
| 23 | Dependencies come from pub.dev, and `build/` and `.dart_tool/` are gitignored | Yes | I verified my `.gitignore` file includes the standard Flutter exclusions for `build/` and `.dart_tool/`. |
| 24 | Images, fonts and other assets are mine, licensed, or credited | Yes | All imagery uses direct, hotlink-friendly URLs to royalty-free Unsplash photography. |
| 25 | Repository visibility is deliberate, and I checked it after my last push | Yes | I confirmed in my GitHub repository settings that the app repository is public as required. |

## Anything I found and fixed

The checklist caught nothing critical since I built the app with environment variables from the start. However, it prompted me to double-check my `.gitignore` file and verify that the `.env.example` file provided in the starter code successfully demonstrated where the Gemini API key should go without exposing my real key. I also ran the `grep` / `Select-String` command to ensure my git history was completely clear of accidental key commits.