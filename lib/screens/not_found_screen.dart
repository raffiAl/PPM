import 'package:flutter/material.dart';

// PLACEHOLDER — diisi tahap 3 (di-mix bareng Booking).
// Muncul via onUnknownRoute pas route gak dikenal / arguments invalid.
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('404')),
      body: const Center(child: Text('Halaman tidak ditemukan')),
    );
  }
}
