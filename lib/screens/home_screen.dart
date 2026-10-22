import 'package:flutter/material.dart';

// PLACEHOLDER — diisi tahap 2:
// daftar 4+ paket wisata (Card/ListView) + tombol logout
// (pushNamedAndRemoveUntil ke Splash).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nusa Travel')),
      body: const Center(
        child: Text('Daftar Paket Wisata — diisi tahap berikutnya'),
      ),
    );
  }
}
