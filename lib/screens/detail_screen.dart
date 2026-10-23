import 'package:flutter/material.dart';

import '../models/tour_package.dart';
import 'booking_screen.dart';
import 'home_screen.dart'; // formatRupiah — helper didefinisikan di sana

// ============================================================
// DETAIL — nerima TourPackage via constructor dari onGenerateRoute
// (arguments pushNamed). Nanti nangkap result dari Booking
// ditangani tahap 3.
// ============================================================
class DetailScreen extends StatelessWidget {
  final TourPackage package;

  const DetailScreen({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(package.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar besar + errorBuilder
            Image.network(
              package.imageUrl,
              width: double.infinity,
              height: 260,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: double.infinity,
                height: 260,
                color: colorScheme.surfaceContainerHighest,
                child: Icon(
                  Icons.landscape,
                  size: 64,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul besar
                  Text(
                    package.title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Harga menonjol
                  Text(
                    formatRupiah(package.price),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Chip info dummy: durasi & kuota
                  Wrap(
                    spacing: 8,
                    children: [
                      Chip(
                        avatar: const Icon(Icons.schedule, size: 18),
                        label: const Text('3 Hari 2 Malam'),
                      ),
                      Chip(
                        avatar: const Icon(Icons.people, size: 18),
                        label: const Text('Kuota: 12 orang'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Deskripsi lengkap (di sini gak ada maxLines)
                  Text(
                    package.description,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Tombol pesan — Navigator.push LANGSUNG (bukan named).
                  // Hasil pop-nya diolah di tahap 3 (await + SnackBar)
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () async {
                        // push() TUNGGU sampai Booking di-pop (await),
                        // lalu tangkap RESULT-nya
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookingScreen(package: package),
                          ),
                        );

                        // Result ada (String sukses dari Booking) → SnackBar
                        if (result != null && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(result),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.travel_explore),
                      label: const Text(
                        'Pesan Sekarang',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
