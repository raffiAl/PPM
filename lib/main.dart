import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/cart_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/catalog_screen.dart';

void main() {
  runApp(const NusaBookstoreApp());
}

// ROOT aplikasi — tugasnya cuma satu: registrasi semua provider.
class NusaBookstoreApp extends StatelessWidget {
  const NusaBookstoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider: daftarin CartProvider + ThemeProvider SEKALIGUS.
    // Semua widget DI BAWAH ini bisa akses dua-duanya lewat context.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const _AppWithTheme(),
    );
  }
}

// Widget yang "nonton" ThemeProvider dan nyalain MaterialApp.
//
// KENAPA HARUS DIPISAH JADI 2 CLASS? (ini penting!)
// context.watch cuma boleh dipanggil dari widget yang berada
// DI BAWAH MultiProvider. Kalau watch dipasang di build
// NusaBookstoreApp (posisinya DI ATAS MultiProvider) → error
// ProviderNotFound, karena saat itu ThemeProvider-nya bahkan
// belum dibikin.
class _AppWithTheme extends StatelessWidget {
  const _AppWithTheme();

  @override
  Widget build(BuildContext context) {
    // Watch ThemeProvider: begitu toggleTheme() dipanggil dari halaman
    // mana pun, widget ini rebuild → themeMode ganti → tema berubah
    // GLOBAL di seluruh aplikasi
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;

    return MaterialApp(
      title: 'NusaBookstore',
      debugShowCheckedModeBanner: false,

      // TEMA TERANG
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),

      // TEMA GELAP — brightness WAJIB di-set dark, kalau gak,
      // skema warnanya tetap versi terang (padahal namanya darkTheme)
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
      ),

      // Sumber kebenaran tema: dari ThemeProvider, bukan hardcode
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

      home: const CatalogScreen(),
    );
  }
}
