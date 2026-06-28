#!/bin/bash
# إيقاف السكريبت عند حدوث أي خطأ
set -e

echo "--- Starting Flutter Build Process ---"

# 1. تحميل Flutter stable إذا لم يكن موجوداً
if [ ! -d "flutter" ]; then
  echo "Downloading Flutter SDK..."
  git clone https://github.com/flutter/flutter.git -b stable --depth 1
else
  echo "Flutter SDK already exists, skipping download."
fi

# 2. إعداد المسارات (استخدام المسار المطلق لضمان الأولوية)
export FLUTTER_ROOT="$(pwd)/flutter"
export PATH="$FLUTTER_ROOT/bin:$PATH"

# 3. التأكد من استخدام النسخة المحملة وتفعيل الويب
echo "Checking Flutter version..."
flutter --version

echo "Enabling Web support..."
flutter config --enable-web

# 4. تنظيف وجلب المكتبات
echo "Fetching dependencies..."
flutter pub get

# 5. بناء نسخة الويب
echo "Building Web application..."
# إذا فشل هذا السطر، السكريبت سيتوقف بسبب 'set -e'
flutter build web --release --web-renderer html --base-href / \
  --dart-define=SUPABASE_URL=$SUPABASE_URL \
  --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY

# 6. تجهيز مجلد المخرجات لـ Vercel
echo "Preparing public directory for deployment..."
rm -rf public
mkdir -p public
cp -r build/web/* public/

echo "--- Build finished successfully! ---"
