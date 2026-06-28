#!/bin/bash
# 1. Install Flutter
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable --depth 1
fi
export PATH="$PATH:`pwd`/flutter/bin"

# 2. Build
flutter pub get
flutter build web --release --dart-define=SUPABASE_URL=$SUPABASE_URL --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY
