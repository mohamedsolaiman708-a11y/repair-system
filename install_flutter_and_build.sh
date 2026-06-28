#!/bin/bash
# 1. Download Flutter stable (Depth 1 for speed)
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable --depth 1
fi

# 2. Fix PATH (Absolute)
export PATH="$PWD/flutter/bin:$PATH"

# 3. Build Command (Single line, no spaces at ends, explicit = sign)
flutter config --enable-web
flutter pub get
flutter build web --release --web-renderer=html --dart-define=SUPABASE_URL="$SUPABASE_URL" --dart-define=SUPABASE_ANON_KEY="$SUPABASE_ANON_KEY"
