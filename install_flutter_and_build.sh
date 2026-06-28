#!/bin/bash

# 1. إعداد مسار Flutter
export PATH="$PATH:$(pwd)/flutter/bin"

# 2. تحميل Flutter stable إذا لم يكن موجوداً
if [ ! -d "flutter" ]; then
  echo "Downloading Flutter SDK..."
  git clone https://github.com/flutter/flutter.git -b stable --depth 1
fi

# 3. تنظيف أي بناء سابق وجلب المكتبات
echo "Cleaning and fetching dependencies..."
flutter clean
flutter pub get

# 4. بناء نسخة الويب
echo "Building Web application..."
# --web-renderer html هو الأكثر استقراراً مع Vercel
# --base-href / لضمان عمل الروابط بشكل صحيح
flutter build web --release --web-renderer html --base-href / \
  --dart-define=SUPABASE_URL=$SUPABASE_URL \
  --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY

echo "Build complete successfully!"
