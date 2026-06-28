#!/bin/bash
# 1. Install Flutter
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable --depth 1
fi
export PATH="$PATH:`pwd`/flutter/bin"

# 2. Build
flutter pub get
# تعديل الفهمانين: إضافة الفلاج الفعلي لإجبار الـ html renderer لضمان التوافقية وسرعة التحميل
flutter build web --release --web-renderer html --dart-define=SUPABASE_URL=$SUPABASE_URL --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY
