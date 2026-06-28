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

# 2. إعداد المسارات (وضعه في البداية لضمان استخدام النسخة المحملة)
export FLUTTER_ROOT="$(pwd)/flutter"
export PATH="$FLUTTER_ROOT/bin:$PATH"

# 3. التأكد من تفعيل الويب
echo "Enabling Web support..."
flutter config --no-analytics
flutter config --enable-web

# 4. جلب المكتبات
echo "Fetching dependencies..."
flutter pub get

# 5. بناء نسخة الويب (أمر السطر الواحد المضمون لتجنب أخطاء التنسيق)
echo "Building Web application..."
flutter build web --release --web-renderer html --base-href / --dart-define=SUPABASE_URL="${SUPABASE_URL}" --dart-define=SUPABASE_ANON_KEY="${SUPABASE_ANON_KEY}"

# 6. تجهيز مجلد المخرجات لـ Vercel
echo "Preparing public directory for deployment..."
rm -rf public
mkdir -p public
if [ -d "build/web" ]; then
  cp -r build/web/* public/
  echo "Success: Build files copied to public/ folder."
else
  echo "Error: build/web directory was not created!"
  exit 1
fi

echo "--- Build finished successfully! ---"
