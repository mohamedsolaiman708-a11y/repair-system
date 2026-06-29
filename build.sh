#!/bin/bash
# Exit on error
set -e

# Clone Flutter if it doesn't exist
if [ ! -d "f" ]; then
  git clone -b stable --depth 1 https://github.com/flutter/flutter f
fi

# PREPEND to PATH to ensure we use this version first
export PATH="$(pwd)/f/bin:$PATH"

# Build project
flutter config --enable-web
flutter pub get
flutter build web --release --web-renderer html --dart-define=SUPABASE_URL="$SUPABASE_URL" --dart-define=SUPABASE_ANON_KEY="$SUPABASE_ANON_KEY"
