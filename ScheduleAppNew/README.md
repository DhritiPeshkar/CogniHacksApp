# ScheduleAppNew (CogniHacksApp)

A small SwiftUI iOS/macOS app for scheduling and quiz features. This project contains lightweight models, views, and a helper for OpenAI integration (via an API key stored in `Secrets.xcconfig`). The app is intended as a learning/demo project and a starting point for building scheduling or quiz-based apps.

## Features

- Simple scheduling UI built with SwiftUI (see `ContentView.swift`).
- Item model in `Item.swift` for schedule entries.
- Timer utility in `timer.swift`.
- Quiz functionality in `QuizPart.swift`.
- `OpenAI.swift` helper for calling OpenAI APIs (store API keys securely — see configuration below).

## Requirements

- macOS with Xcode (14+ recommended).
- Swift 5.7+ / SwiftUI.

## Setup

1. Open the Xcode workspace/project located in this folder.
2. Configure the OpenAI API key:
   - Open `Secrets.xcconfig` and add or confirm an entry like:
     ```
     OPENAI_API_KEY = YOUR_API_KEY_HERE
     ```
   - In Xcode, ensure the `.xcconfig` is assigned to the project build configuration (Project > Info > Configurations).
   - Do not commit real keys to source control. Consider using environment variables or a secrets manager for production.
3. Add required Apple privacy usage keys to `Info.plist` if the app needs microphone, camera, or location access for extended features.

## File Overview

- `ContentView.swift` — Main SwiftUI view.
- `Item.swift` — Data model for schedule items.
- `timer.swift` — Timer utility and helpers.
- `QuizPart.swift` — Quiz-related models and views.
- `OpenAI.swift` — Helper for interacting with OpenAI APIs.
- `ScheduleAppNewApp.swift` — App entry point.
- `Assets.xcassets` — App assets and app icon.
- `Secrets.xcconfig` — Local configuration file for secrets (not for public commit).

## Development Notes

- Keep secrets out of version control. Add `Secrets.xcconfig` to `.gitignore` if you haven't already.
- For testing OpenAI calls, stub network responses or use a local mock to avoid extra API usage.
- Consider adding unit tests for model behavior and UI snapshot tests for key views.

## Contact / Attribution

Created by the project owner. Use and modify freely for learning and prototyping.
