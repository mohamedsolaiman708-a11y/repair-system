import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';
import 'core/constants/supabase_constants.dart';
import 'core/utils/logger.dart';

void main() {
  // 1. بدء تشغيل المحرك فوراً
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. تشغيل التطبيق بدون انتظار الـ Init لضمان عدم بقاء الشاشة بيضاء
  runApp(
    const ProviderScope(
      child: AppBootstrap(),
    ),
  );
}

class AppBootstrap extends StatefulWidget {
  const AppBootstrap({super.key});

  @override
  State<AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends State<AppBootstrap> {
  bool _initialized = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    try {
      // التأكد من وصول المتغيرات من Vercel
      if (SupabaseConstants.url.isEmpty || SupabaseConstants.anonKey.isEmpty) {
        throw 'Environment variables (SUPABASE_URL/KEY) are missing. Check Vercel settings.';
      }

      await Supabase.initialize(
        url: SupabaseConstants.url,
        anonKey: SupabaseConstants.anonKey,
      );
      
      Log.i('Supabase Initialized');
      
      if (mounted) {
        setState(() => _initialized = true);
      }
    } catch (e, stack) {
      Log.e('Initialization Failed', e, stack);
      if (mounted) {
        setState(() => _error = e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // في حالة وجود خطأ، نعرضه بشكل واضح
    if (_error != null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 20),
                  const Text('خطأ في تهيئة النظام', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(_error!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => setState(() { _error = null; _initApp(); }),
                    child: const Text('إعادة المحاولة'),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }

    // في حالة التحميل، نعرض مؤشر تحميل (بدلاً من الشاشة البيضاء)
    if (!_initialized) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text('جاري تحميل النظام...', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
      );
    }

    // عندما يكون كل شيء جاهزاً، نشغل التطبيق الأصلي
    return const MyApp();
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
