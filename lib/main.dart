import 'dart:async'; // WAJIB DIIMPORT untuk pakai Timer

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KTM & Counter App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 240, 58, 134),
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'PPM Sesi 1 - Moh. Raffi Alfatih'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  Timer? _timer; // Variabel untuk menyimpan timer auto-repeat

  // Fungsi dasar tambah
  void _increment() {
    setState(() {
      _counter++;
    });
  }

  // Fungsi dasar kurang
  void _decrement() {
    setState(() {
      if (_counter > 0) {
        _counter--;
      }
    });
  }

  // Menjalankan auto-repeat saat tombol ditahan
  void _startAutoRepeat(VoidCallback action) {
    if (_timer != null) return;

    // Jalankan aksi pertama kali secara instan saat disentuh
    action();

    // Set timer untuk mengulang aksi setiap 100 milidetik (bisa lu sesuain kecepatannya)
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      action();
    });
  }

  // Menghentikan auto-repeat saat tombol dilepas
  void _stopAutoRepeat() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  @override
  void dispose() {
    _stopAutoRepeat(); // Bersihkan timer saat widget dihancurkan biar gak memory leak
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // ==================== KARTU MAHASISWA ====================
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'KARTU MAHASISWA',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          Icon(
                            Icons.school,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                      const Divider(thickness: 1.5),
                      const SizedBox(height: 10),

                      const Text(
                        'Nama:',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const Text(
                        'Moh. Raffi Alfatih',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      const Text(
                        'NIM:',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const Text(
                        '20240040066',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 10),

                      const Text(
                        'Program Studi:',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const Text(
                        'Teknik Informatika',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // =========================================================

              const SizedBox(height: 60),

              const Text(
                'Tahan tombol di bawah buat auto tambah/kurang!:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 40),

              // Tombol Custom dengan Fitur Hold / Long Press
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Tombol Kurang (-) dengan Deteksi Tahan
                  GestureDetector(
                    onTapDown: (_) => _startAutoRepeat(_decrement),
                    onTapUp: (_) => _stopAutoRepeat(),
                    onTapCancel: () => _stopAutoRepeat(),
                    child: FloatingActionButton(
                      onPressed: () {}, // Kosongkan karena logika handle ada di GestureDetector
                      tooltip: 'Kurang (Tahan untuk auto)',
                      backgroundColor: Colors.redAccent.shade100,
                      child: const Icon(Icons.remove),
                    ),
                  ),

                  const SizedBox(width: 30),

                  // Tombol Tambah (+) dengan Deteksi Tahan
                  GestureDetector(
                    onTapDown: (_) => _startAutoRepeat(_increment),
                    onTapUp: (_) => _stopAutoRepeat(),
                    onTapCancel: () => _stopAutoRepeat(),
                    child: FloatingActionButton(
                      onPressed: () {}, // Kosongkan karena logika handle ada di GestureDetector
                      tooltip: 'Tambah (Tahan untuk auto)',
                      backgroundColor: Colors.greenAccent.shade100,
                      child: const Icon(Icons.add),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
