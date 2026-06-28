#!/bin/bash

# 1. تحميل Flutter stable إذا لم يكن موجوداً
if [ ! -d "flutter" ]; then
  echo "Downloading Flutter SDK..."
  git clone https://github.com/flutter/flutter.git -b stable --depth 1
fi

# 2. إضافة Flutter إلى المسار (PATH) بشكل صحيح
# استخدمنا $(pwd)/flutter/bin لأن المجلد تم تحميله في الجذر
export PATH="$PATH:$(pwd)/flutter/bin"

# 3. تحميل ملفات بناء الويب مسبقاً
echo "Precaching Web artifacts..."
flutter precache --web

# 4. جلب المكتبات
echo "Fetching dependencies..."
flutter pub get

# 5. بناء نسخة الويب
echo "Building Web application..."

# تأكد من تمرير متغيرات البيئة أثناء البناء
flutter build web --release \
  --dart-define=SUPABASE_URL=$SUPABASE_URL \
  --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY