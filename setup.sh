#!/usr/bin/env bash
# One-time bootstrap: generates the android/ and ios/ platform folders
# (Gradle wrapper, Xcode project) with your local Flutter SDK, then fetches deps.
set -e
flutter create . --org app.zawq --project-name zawq --platforms android,ios
flutter pub get
echo ""
echo "Done. Run the app with: flutter run"
