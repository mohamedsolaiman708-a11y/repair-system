#!/bin/bash
# 1. تحميل نسخة مستقرة من فلاتر (سرعة عالية)
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable --depth 1
fi

# 2. إجبار السيرفر على استخدام النسخة اللي نزلناها (وضعها في أول الـ PATH)
export PATH="`pwd`/flutter/bin:$PATH"

# 3. إعدادات البيئة وتنزيل المكتبات
flutter config --enable-web
flutter pub get

# 4. البناء مع إجبار الـ HTML renderer (الحل السحري لمنع الشاشة البيضاء)
# دمجنا الفلاجات في سطر واحد لضمان عدم حدوث خطأ 64
flutter build web --release --web-renderer html --dart-define=SUPABASE_URL=$SUPABASE_URL --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY
