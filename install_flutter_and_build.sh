#!/bin/bash
# 1. Download Flutter stable (Depth 1 for speed)
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable --depth 1
fi

# 2. Setup PATH (Put our version FIRST to avoid Error 64)
export PATH="$PWD/flutter/bin:$PATH"

# 3. Build Web
flutter config --enable-web
flutter pub get
# Use single line command to avoid shell/CRLF issues
flutter build web --release --web-renderer html --dart-define=SUPABASE_URL="$SUPABASE_URL" --dart-define=SUPABASE_ANON_KEY="$SUPABASE_ANON_KEY"
