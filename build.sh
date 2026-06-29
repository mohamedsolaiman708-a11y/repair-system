#!/bin/bash

# Clone Flutter
git clone -b stable --depth 1 https://github.com/flutter/flutter f

# Add Flutter to path
export PATH="$PATH:$(pwd)/f/bin"

# Configure and Build
flutter config --enable-web
flutter pub get
flutter build web --release --web-renderer=html --dart-define=SUPABASE_URL=$SUPABASE_URL --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY
