#!/bin/bash
# 1. تحميل فلاتر بسرعة (depth 1)
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable --depth 1
fi

# 2. إعداد المسارات
export PATH="$PATH:`pwd`/flutter/bin"

# 3. بناء الويب مع تمرير المتغيرات
flutter pub get
flutter build web --release --dart-define=SUPABASE_URL=$SUPABASE_URL --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY
