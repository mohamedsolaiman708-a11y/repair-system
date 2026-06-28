import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';
import 'core/constants/supabase_constants.dart';
import 'core/utils/logger.dart';

void main() {
  // 1. ضمان تشغيل المحرك فوراً لتقليل وقت ظهور الشاشة البيضاء
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. تشغيل التطبيق فوراً بدون انتظار أي await في الـ main
  runApp(
    const ProviderScope(
      child: AppLauncher(),
    ),
  );
}

class AppLauncher extends StatefulWidget {
  const AppLauncher({super.key});

  @override
  State<AppLauncher> createState() => _AppLauncherState();
}

class _AppLauncherState extends State<AppLauncher> {
  bool _initialized = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    try {
      // التحقق من المتغيرات قبل البدء
      if (SupabaseConstants.url.isEmpty || SupabaseConstants.anonKey.isEmpty) {
        throw 'Environment Variables (SUPABASE_URL/KEY) are missing in Vercel settings.';
      }

      await Supabase.initialize(
        url: SupabaseConstants.url,
        anonKey: SupabaseConstants.anonKey,
      );
      
      Log.i('Supabase Initialized');
      if (mounted) setState(() => _initialized = true);
    } catch (e, stack) {
      Log.e('Initialization Failed', e, stack);
      if (mounted) setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  const Text('حدث خطأ في تشغيل النظام', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(_error!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ),
        ),
      );
    }

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

    return const MyApp();
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Repair System',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
