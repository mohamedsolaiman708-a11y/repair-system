import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';
import 'core/constants/supabase_constants.dart';
import 'core/utils/logger.dart';

void main() async {
  // 1. ضمان تشغيل المحرك
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. تهيئة سوبابيس قبل تشغيل الـ ProviderScope لضمان الأمان
  String? initError;
  try {
    if (SupabaseConstants.url.isEmpty || SupabaseConstants.anonKey.isEmpty) {
      throw 'Environment Variables (URL/KEY) are missing in Vercel!';
    }
    await Supabase.initialize(
      url: SupabaseConstants.url,
      anonKey: SupabaseConstants.anonKey,
    );
    Log.i('Supabase Initialized Successfully');
  } catch (e, stack) {
    Log.e('Supabase Init Failed', e, stack);
    initError = e.toString();
  }

  runApp(
    ProviderScope(
      child: initError != null 
          ? ErrorApp(message: initError) 
          : const MyApp(),
    ),
  );
}

class ErrorApp extends StatelessWidget {
  final String message;
  const ErrorApp({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 60),
                const SizedBox(height: 20),
                const Text('خطأ في تشغيل النظام', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
              ],
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
      title: 'Repair System',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
