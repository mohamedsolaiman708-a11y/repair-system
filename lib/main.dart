import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';
import 'core/constants/supabase_constants.dart';
import 'core/utils/logger.dart';
import 'dart:developer' as dev;

void main() {
  // 1. تشغيل المحرك فوراً
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. التقاط أخطاء الفريمورك
  FlutterError.onError = (details) {
    dev.log('Flutter Error: ${details.exception}', error: details.exception, stackTrace: details.stack);
  };

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
      dev.log('Supabase: Initializing with URL: ${SupabaseConstants.url}');
      
      if (SupabaseConstants.url.isEmpty || SupabaseConstants.anonKey.isEmpty) {
        throw 'Environment Variables (URL/KEY) are empty. Check Vercel Environment Variables settings.';
      }

      await Supabase.initialize(
        url: SupabaseConstants.url,
        anonKey: SupabaseConstants.anonKey,
      );
      
      dev.log('Supabase: Ready');
      if (mounted) setState(() => _initialized = true);
    } catch (e, stack) {
      dev.log('Supabase: Init Error', error: e, stackTrace: stack);
      if (mounted) setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // عرض رسالة خطأ واضحة بدلاً من الشاشة البيضاء
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
                  const Text('System Error', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(_error!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.redAccent)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => _initApp(),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // لودر انتظار سوبابيس
    if (!_initialized) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
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
