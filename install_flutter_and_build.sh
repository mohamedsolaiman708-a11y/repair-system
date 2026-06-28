#!/bin/bash

# 1. إعداد مسار Flutter (وضعه في البداية لضمان استخدام النسخة المحملة)
export PATH="$(pwd)/flutter/bin:$PATH"

# 2. تحميل Flutter stable إذا لم يكن موجوداً
if [ ! -d "flutter" ]; then
  echo "Downloading Flutter SDK..."
  git clone https://github.com/flutter/flutter.git -b stable --depth 1
fi

# 3. تنظيف أي بناء سابق
echo "Cleaning old artifacts..."
flutter clean
flutter pub get

# 4. بناء نسخة الويب
echo "Building Web application..."
# نستخدم النسخة اللي حملناها للتأكد من دعم الـ renderer
flutter build web --release --web-renderer html --base-href / \
  --dart-define=SUPABASE_URL=$SUPABASE_URL \
  --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY

# 5. حل مشكلة المجلد لـ Vercel
# سنقوم بنقل الملفات المبنية إلى مجلد جديد اسمه 'public' 
# لأن Vercel أحياناً يرفض مجلد 'build' أو يتداخل مع مجلد 'web' الأصلي
echo "Preparing deployment directory..."
rm -rf public
cp -r build/web public

echo "Build complete! Use 'public' as your Output Directory in Vercel."
