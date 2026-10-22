import 'package:flutter/material.dart';

import 'routes/app_routes.dart';
import 'screens/home_screen.dart';
import 'screens/not_found_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const NusaTravelApp());
}

class NusaTravelApp extends StatelessWidget {
  const NusaTravelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nusa Travel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),

      // 4 API routing WAJIB — semua kepakai:
      initialRoute: AppRoutes.splash,

      // Route STATIS: gak butuh arguments, cukup map doang.
      // ('/detail' SENGAJA gak ada di sini — lihat komentar app_routes.dart)
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.home: (context) => const HomeScreen(),
      },

      // Route DINAMIS: butuh baca arguments (Detail)
      onGenerateRoute: AppRoutes.onGenerateRoute,

      // Fallback: route gak dikenal / arguments invalid → 404
      onUnknownRoute: (settings) =>
          MaterialPageRoute(builder: (context) => const NotFoundScreen()),
    );
  }
}
