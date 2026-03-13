#!/bin/sh

# Xcode Cloud post-clone script for Flutter
# This runs after repo is cloned but before build

set -e

echo "📦 Installing Flutter..."

# Install Flutter
git clone https://github.com/flutter/flutter.git --depth 1 -b stable $HOME/flutter
export PATH="$PATH:$HOME/flutter/bin"

# Pre-download Flutter dependencies
flutter precache --ios

# Run Flutter pub get
cd $CI_WORKSPACE
flutter pub get

echo "✅ Flutter installed and dependencies fetched"
