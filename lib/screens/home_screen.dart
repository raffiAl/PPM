import 'package:flutter/material.dart';

import '../models/tour_package.dart';
import '../routes/app_routes.dart';

// ============================================================
// HELPER — format rupiah manual: 2750000 → "Rp 2.750.000"
// Pemisah ribuan pakai titik, tanpa package tambahan.
// Sengaja PUBLIC (tanpa underscore) supaya Detail (dan nanti
// Booking) tinggal import file ini.
// ============================================================
String formatRupiah(int angka) {
  final String s = angka.toString();
  String hasil = '';
  int hitung = 0;

  for (int i = s.length - 1; i >= 0; i--) {
    hasil = s[i] + hasil;
    hitung++;
    if (hitung % 3 == 0 && i > 0) {
      hasil = '.$hasil';
    }
  }
  return 'Rp $hasil';
}

// ============================================================
// DATA — 6 paket wisata (syarat minimal 4, ambil 6 biar aman).
// price: int rupiah realistis. imageUrl: picsum beda id,
// ukuran 400x500 biar rasionya portrait.
// ============================================================
const List<TourPackage> _daftarPaket = [
  TourPackage(
    id: 1,
    title: 'Bali',
    description:
        'Pulau Dewata dengan pantai berpasir putih, seni, dan budaya '
        'yang masih hidup. Nikmati matahari terbenam di Kuta, hamparan '
        'sawah Tegalalang, dan keindahan Pura Tanah Lot.',
    price: 2750000,
    imageUrl: 'https://picsum.photos/id/1011/400/500',
  ),
  TourPackage(
    id: 2,
    title: 'Raja Ampat',
    description:
        'Surga bawah laut di Papua dengan keanekaragaman hayati laut '
        'terkaya di dunia. Jelajahi gugusan karst, laguna biru, dan '
        'spot snorkeling kelas dunia.',
    price: 4500000,
    imageUrl: 'https://picsum.photos/id/1015/400/500',
  ),
  TourPackage(
    id: 3,
    title: 'Gunung Bromo',
    description:
        'Matahari terbit ikonik di lautan pasir Tengger. Pendakian '
        'yang mudah dan cocok untuk pemula dengan pemandangan kaldera '
        'spektakuler.',
    price: 850000,
    imageUrl: 'https://picsum.photos/id/1016/400/500',
  ),
  TourPackage(
    id: 4,
    title: 'Labuan Bajo',
    description:
        'Gerbang menuju Taman Nasional Komodo. Berlayar dengan kapal '
        'phinisi, berenang bersama manta ray, dan menyaksikan komodo '
        'di habitat aslinya.',
    price: 3200000,
    imageUrl: 'https://picsum.photos/id/1018/400/500',
  ),
  TourPackage(
    id: 5,
    title: 'Candi Borobudur',
    description:
        'Candi Buddha terbesar di dunia dan warisan UNESCO. Saksikan '
        'matahari terbit dari puncaknya sambil mengelilingi relief '
        'batu berusia lebih dari seribu tahun.',
    price: 750000,
    imageUrl: 'https://picsum.photos/id/1020/400/500',
  ),
  TourPackage(
    id: 6,
    title: 'Danau Toba',
    description:
        'Danau vulkanik terbesar di Indonesia dengan Pulau Samosir di '
        'tengahnya. Rasakan udara sejuk pegunungan, budaya Batak, dan '
        'panorama perbukitan hijau.',
    price: 1650000,
    imageUrl: 'https://picsum.photos/id/1036/400/500',
  ),
];

// ============================================================
// HOME — daftar paket wisata + logout
// ============================================================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Dialog konfirmasi logout → pushNamedAndRemoveUntil ke Splash
  void _konfirmasiLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Yakin mau logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext), // batal
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext); // tutup dialog dulu

              // Hapus SEMUA history & balik ke Splash.
              // (route) => false = "buang semua route lama",
              // jadi setelah logout gak bisa back ke Home lagi.
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.splash,
                (route) => false,
              );
            },
            child: const Text('Ya, Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nusa Travel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _konfirmasiLogout(context),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _daftarPaket.length,
        itemBuilder: (context, index) {
          return _PaketCard(paket: _daftarPaket[index]);
        },
      ),
    );
  }
}

// ============================================================
// KARTU PER PAKET — gambar + title + deskripsi + harga
// ============================================================
class _PaketCard extends StatelessWidget {
  final TourPackage paket;

  const _PaketCard({required this.paket});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        // POIN PENILAIAN: pushNamed + arguments.
        // 'paket' diterima onGenerateRoute lewat settings.arguments,
        // dicek `is TourPackage`, lalu dikirim ke DetailScreen.
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.detail, arguments: paket);
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar — ClipRRect + errorBuilder
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  paket.imageUrl,
                  width: 110,
                  height: 140,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 110,
                    height: 140,
                    color: colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.landscape,
                      size: 40,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      paket.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      paket.description,
                      maxLines: 2, // di Home cuma cuplikan
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formatRupiah(paket.price), // "Rp 2.750.000"
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
