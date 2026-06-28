import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';
import 'core/utils/logger.dart';
import 'core/constants/supabase_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 1. التحقق من وجود المتغيرات
    if (SupabaseConstants.url.isEmpty || SupabaseConstants.anonKey.isEmpty) {
      throw Exception(
        'المتغيرات (Environment Variables) مفقودة!\n'
        'تأكد من إضافة SUPABASE_URL و SUPABASE_ANON_KEY في إعدادات Vercel.'
      );
    }

    // 2. محاولة تشغيل Supabase
    await Supabase.initialize(
      url: SupabaseConstants.url,
      anonKey: SupabaseConstants.anonKey,
    );
    Log.i('Supabase successfully initialized.');

    runApp(
      const ProviderScope(
        child: MyApp(),
      ),
    );
  } catch (e, stack) {
    Log.e('Failed to initialize app', e, stack);
    
    // 3. عرض الخطأ على الشاشة بدلاً من الصفحة البيضاء لكي نعرف السبب
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 20),
                  const Text('حدث خطأ في تشغيل النظام', 
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                  const SizedBox(height: 12),
                  Text(e.toString(), textAlign: TextAlign.center, 
                    style: const TextStyle(color: Colors.redAccent, fontFamily: 'monospace')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Repair Management System',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
