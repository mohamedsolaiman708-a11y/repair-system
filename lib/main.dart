import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';
import 'core/constants/supabase_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // صائد أخطاء شامل لعرض أي مشكلة بدلاً من الشاشة البيضاء
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.red.shade900,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Icon(Icons.bug_report, color: Colors.white, size: 50),
                const SizedBox(height: 10),
                const Text('Runtime Error:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                SelectableText(
                  '${details.exception}\n\n${details.stack}',
                  style: const TextStyle(color: Colors.white70, fontSize: 10, fontFamily: 'monospace'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  };

  try {
    // تنظيف المتغيرات من أي علامات تنصيص زائدة قد يضعها Vercel
    final url = SupabaseConstants.url.replaceAll('"', '').replaceAll("'", "").trim();
    final key = SupabaseConstants.anonKey.replaceAll('"', '').replaceAll("'", "").trim();

    print('DEBUG: Supabase URL length: ${url.length}');

    if (url.isEmpty || key.isEmpty) {
      throw 'Environment Variables (SUPABASE_URL/KEY) are missing in Vercel!';
    }

    await Supabase.initialize(url: url, anonKey: key);

    runApp(
      const ProviderScope(
        child: MyApp(),
      ),
    );
  } catch (e, stack) {
    print('CRITICAL INIT ERROR: $e');
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SelectableText('Initialization Failed: $e\n\n$stack'),
          ),
        ),
      ),
    ));
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    
    return MaterialApp.router(
      title: 'Repair Systems',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
