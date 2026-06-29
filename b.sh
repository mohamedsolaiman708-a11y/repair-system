#!/bin/bash
set -e
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable --depth 1
fi
./flutter/bin/flutter config --enable-web
./flutter/bin/flutter precache --web
./flutter/bin/flutter pub get
./flutter/bin/flutter build web --release --web-renderer=html --base-href / --dart-define=SUPABASE_URL=$SUPABASE_URL --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY
mkdir -p public
cp -r build/web/* public/
