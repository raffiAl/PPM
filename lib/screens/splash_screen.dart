import 'package:flutter/material.dart';

import '../routes/app_routes.dart';

// Splash: halaman pertama, full-screen TANPA AppBar.
// Tombol "Mulai Jelajah" pakai pushReplacementNamed — Splash DIGANTI
// Home di stack, jadi gak bisa back ke sini lagi.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primary,
              const Color(0xFF00695C), // teal gelap — gradasi laut/nusantara
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo — ikon dalam lingkaran putih + shadow lembut
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.travel_explore,
                  size: 78,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 32),

              // Nama app
              Text(
                'Nusa Travel',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),

              // Tagline
              Text(
                'Jelajahi Keindahan Nusantara',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 48),

              // Tombol mulai — SPLASH DIGANTI HOME (bukan ditumpuk)
              FilledButton.icon(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.home);
                },
                icon: const Icon(Icons.explore),
                label: const Text(
                  'Mulai Jelajah',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: colorScheme.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
