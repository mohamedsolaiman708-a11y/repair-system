#!/bin/bash
# إيقاف السكريبت عند حدوث أي خطأ
set -e

echo "--- 1. Setup Flutter ---"
if [ ! -d "flutter" ]; then
  echo "Cloning Flutter SDK..."
  git clone https://github.com/flutter/flutter.git -b stable --depth 1
fi

# إعداد المسارات المطلقة لضمان استخدام النسخة المحلية
export PATH="$(pwd)/flutter/bin:$PATH"

echo "--- 2. Configure Web ---"
flutter config --no-analytics
flutter config --enable-web
flutter precache --web

echo "--- 3. Initialize/Repair Web Platform ---"
# إعادة تهيئة ملفات الويب لضمان التوافق التام مع النسخة المحملة
flutter create . --platforms web

echo "--- 4. Getting Dependencies ---"
flutter pub get

echo "--- 5. Building Web application ---"
# كتابة الأمر في سطر واحد تماماً لتجنب مشاكل تفسير الأسطر المائلة في Linux
flutter build web --release --web-renderer=html --base-href=/ --dart-define=SUPABASE_URL="${SUPABASE_URL}" --dart-define=SUPABASE_ANON_KEY="${SUPABASE_ANON_KEY}"

echo "--- 6. Preparing Output ---"
mkdir -p public
if [ -d "build/web" ]; then
  cp -r build/web/* public/
  echo "--- Build Success ---"
else
  echo "--- Error: build/web directory not found ---"
  exit 1
fi
