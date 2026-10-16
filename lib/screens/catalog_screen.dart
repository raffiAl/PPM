import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book.dart';
import '../providers/cart_provider.dart';
import '../providers/theme_provider.dart';
import 'cart_screen.dart';

// ============================================================
// HELPER — format rupiah manual: 95000 → "Rp 95.000"
// Pemisah ribuan pakai titik, tanpa package tambahan.
// Sengaja PUBLIC (tanpa underscore) supaya nanti halaman Keranjang
// bisa import fungsi ini dari file ini.
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
// DATA BUKU — 6 buku (syarat minimal 4, ambil 6 biar aman).
// price: int rupiah. imageUrl: picsum beda id per buku,
// ukuran 300x450 biar rasionya portrait kayak cover buku.
// ============================================================
const List<Book> _daftarBuku = [
  Book(
    id: 1,
    title: 'Laskar Pelangi',
    author: 'Andrea Hirata',
    price: 95000,
    imageUrl: 'https://picsum.photos/id/24/300/450',
  ),
  Book(
    id: 2,
    title: 'Bumi',
    author: 'Tere Liye',
    price: 105000,
    imageUrl: 'https://picsum.photos/id/25/300/450',
  ),
  Book(
    id: 3,
    title: 'Filosofi Teras',
    author: 'Henry Manampiring',
    price: 90000,
    imageUrl: 'https://picsum.photos/id/26/300/450',
  ),
  Book(
    id: 4,
    title: 'Negeri 5 Menara',
    author: 'A. Fuadi',
    price: 100000,
    imageUrl: 'https://picsum.photos/id/27/300/450',
  ),
  Book(
    id: 5,
    title: 'Perahu Kertas',
    author: 'Dee Lestari',
    price: 98000,
    imageUrl: 'https://picsum.photos/id/28/300/450',
  ),
  Book(
    id: 6,
    title: 'Hujan',
    author: 'Tere Liye',
    price: 92000,
    imageUrl: 'https://picsum.photos/id/29/300/450',
  ),
];

// ============================================================
// HALAMAN KATALOG — StatelessWidget.
// Semua state (keranjang, tema) urusan provider.
// ============================================================
class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // WATCH (tampilan): buat IKON tombol tema — begitu toggleTheme()
    // dipanggil, build ini jalan lagi → ikon ganti dark ↔ light
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('NusaBookstore'),
        actions: [
          // (a) Toggle Light/Dark mode.
          // Ikon: dark_mode pas lagi TERANG, light_mode pas lagi GELAP
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            tooltip: isDarkMode ? 'Mode Terang' : 'Mode Gelap',
            onPressed: () {
              // AKSI pakai READ — gak butuh rebuild, cukup panggil method
              context.read<ThemeProvider>().toggleTheme();
            },
          ),

          // (b) Ikon keranjang ber-badge — dibikin widget terpisah
          // supaya yang nge-watch cuma ikon ini (list buku gak
          // ikut rebuild tiap keranjang berubah)
          const CartIconButton(),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _daftarBuku.length,
        itemBuilder: (context, index) {
          return _BookCard(book: _daftarBuku[index]);
        },
      ),
    );
  }
}

// ============================================================
// KARTU PER BUKU — gambar cover + info + tombol tambah
// ============================================================
class _BookCard extends StatelessWidget {
  final Book book;

  const _BookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    // Semua warna dari colorScheme (JANGAN hardcode!) supaya
    // Light/Dark mode dua-duanya bagus otomatis
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar cover — ClipRRect + errorBuilder fallback.
            // Fallback "abu"-nya pakai warna SCHEME (bukan Colors.grey
            // hardcoded) biar tetap oke di dark mode
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                book.imageUrl,
                width: 90,
                height: 135, // rasio 2:3, portrait kayak cover buku
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 90,
                  height: 135,
                  color: colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.menu_book,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Kolom info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul — bold
                  Text(
                    book.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),

                  // Penulis — "abu" versi scheme (adaptif dark mode)
                  Text(
                    book.author,
                    style: TextStyle(
                      fontSize: 13,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Harga
                  Text(
                    formatRupiah(book.price), // 95000 → "Rp 95.000"
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Tombol Tambah ke Keranjang
                  FilledButton.icon(
                    onPressed: () {
                      // AKSI pakai READ — ini SYARAT PENILAIAN.
                      // addItem udah anti-duplikat: buku yang sama
                      // masuk lagi → quantity-nya yang nambah
                      context.read<CartProvider>().addItem(book);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Berhasil ditambahkan ke keranjang'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_shopping_cart, size: 18),
                    label: const Text('Tambah ke Keranjang'),
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
