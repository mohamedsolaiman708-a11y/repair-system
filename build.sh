#!/bin/bash
# تفعيل تتبع الأوامر لرؤية التفاصيل في سجل Vercel
set -x
# الخروج في حال حدوث خطأ
set -e

echo "--- Step 1: Downloading Flutter ---"
# حذف المجلد القديم لضمان نظافة النسخة
rm -rf f
git clone -b stable --depth 1 https://github.com/flutter/flutter f

# تحديد المسار المباشر للملف التنفيذي
FLUTTER_PATH="$(pwd)/f/bin/flutter"

echo "--- Step 2: Preparing Flutter ---"
# استدعاء المسار المباشر حصراً
$FLUTTER_PATH config --enable-web
$FLUTTER_PATH pub get

echo "--- Step 3: Building Web ---"
# استخدام المسار المباشر مع تنسيق --web-renderer=html
$FLUTTER_PATH build web --release --web-renderer=html --dart-define=SUPABASE_URL="${SUPABASE_URL}" --dart-define=SUPABASE_ANON_KEY="${SUPABASE_ANON_KEY}"

echo "--- Build Finished Successfully ---"
