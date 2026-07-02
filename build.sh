#!/bin/bash
# الخروج فور حدوث أي خطأ
set -e

echo "--- 1. Cleaning and Cloning Flutter ---"
rm -rf f build
git clone -b stable --depth 1 https://github.com/flutter/flutter f

# وضع Flutter في مقدمة المسار لضمان استخدامه حصراً
export PATH="$(pwd)/f/bin:$PATH"

echo "--- 2. Flutter Environment Check ---"
flutter --version

echo "--- 3. Installing Dependencies ---"
flutter pub get

echo "--- 4. Building Flutter Web ---"
# استخدام علامات التنصيص ضروري جداً لمنع انكسار الروابط
flutter build web --release --web-renderer html --dart-define=SUPABASE_URL="$SUPABASE_URL" --dart-define=SUPABASE_ANON_KEY="$SUPABASE_ANON_KEY"

echo "--- 5. Build Completed Successfully ---"
