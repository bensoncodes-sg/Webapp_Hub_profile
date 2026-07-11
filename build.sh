#!/usr/bin/env bash
# Render runs this in a fresh Ubuntu build container that does NOT have
# Flutter pre-installed, so we fetch the SDK, then build the web bundle.
set -euo pipefail

FLUTTER_VERSION="stable"

if [ ! -d "flutter" ]; then
  echo "Cloning Flutter SDK ($FLUTTER_VERSION)..."
  git clone https://github.com/flutter/flutter.git -b "$FLUTTER_VERSION" --depth 1
fi

export PATH="$PATH:$PWD/flutter/bin"

echo "Flutter version:"
flutter --version

flutter config --enable-web
flutter pub get
flutter build web --release

echo "Build complete -> build/web"
