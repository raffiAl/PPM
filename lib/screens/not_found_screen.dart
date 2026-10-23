import 'package:flutter/material.dart';

import '../routes/app_routes.dart';

// 404 — muncul via onUnknownRoute: route gak dikenal
// atau arguments Detail yang null/salah tipe.
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Halaman Tidak Ditemukan')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // "404" super besar bold
              Text(
                '404',
                style: TextStyle(
                  fontSize: 96,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Halaman tidak ditemukan',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 32),

              // Kembali ke Home — bersihin stack juga biar gak numpuk
              FilledButton.icon(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.home,
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.home),
                label: const Text('Kembali ke Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
