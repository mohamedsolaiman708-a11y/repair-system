#!/bin/bash
# 1. Download Flutter stable (Depth 1 for speed)
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable --depth 1
fi

export PATH="$PATH:`pwd`/../flutter/bin"

# 3. جلب المكتبات
echo "Fetching dependencies..."
flutter pub get

# 4. بناء نسخة الويب
echo "Building Web application..."

flutter build web --release \
  --dart-define=SUPABASE_URL=$SUPABASE_URL \
  --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY

# 3. جلب المكتبات
echo "Fetching dependencies..."
flutter pub get


