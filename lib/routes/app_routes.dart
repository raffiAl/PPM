import 'package:flutter/material.dart';

import '../models/tour_package.dart';
import '../screens/detail_screen.dart';

// Pusat routing named-route aplikasi.
//
// URUTAN KEPUTUSAN MaterialApp pas Navigator.pushNamed dipanggil:
//   1. Cek dulu map `routes` (statis) → kalau ketemu, pakai itu.
//   2. Kalau GAK ada di map → panggil `onGenerateRoute` (di sini).
//   3. Kalau onGenerateRoute return null → jatuh ke `onUnknownRoute` (404).
//
// PENTING: '/detail' SENGAJA GAK didaftarin di map routes (di main.dart).
// Kalau didaftarin, map bakal "menerjemahkan" '/detail' langsung dan
// onGenerateRoute gak akan pernah kepanggil buat route itu — padahal
// kita justru butuh onGenerateRoute buat baca arguments-nya.
class AppRoutes {
  // Konstanta nama route — biar gak typo string manual di mana-mana
  static const String splash = '/';
  static const String home = '/home';
  static const String detail = '/detail';

  // Dipanggil Flutter HANYA untuk nama route yang gak ada di map routes.
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case detail:
        // Baca arguments — harus dicek TIPE-nya, karena arguments
        // bertipe dynamic (bisa null, bisa apa aja)
        final args = settings.arguments;
        if (args is TourPackage) {
          return MaterialPageRoute(
            builder: (context) => DetailScreen(package: args),
            settings: settings, // pertahankan nama route & arguments
          );
        }
        // Arguments null / salah tipe → null → jatuh ke onUnknownRoute (404)
        return null;

      default:
        // Nama route gak dikenal sama sekali → null → 404
        return null;
    }
  }
}
