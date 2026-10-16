import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../main.dart'; // design system: NeoColors, NeoCard, NeoButton, NeoIconButton, CartIconButton
import '../models/book.dart';
import '../providers/cart_provider.dart';
import '../providers/theme_provider.dart';

// ============================================================
// HELPER — format rupiah (TETAP, gak berubah)
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
// DATA BUKU — TETAP persis sebelumnya
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

// Genre paralel per index — buat sticker.
// Model Book GAK BOLEH diubah, jadi data genre numpang di file ini.
const List<String> _genre = [
  'Fiksi', // Laskar Pelangi
  'Fantasi', // Bumi
  'Non-Fiksi', // Filosofi Teras
  'Inspirasi', // Negeri 5 Menara
  'Romance', // Perahu Kertas
  'Fiksi Sains', // Hujan
];

// ============================================================
// HALAMAN KATALOG — versi NEOBRUTALISM
// ============================================================
class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = NeoColors.of(context);

    // WATCH (tampilan) — buat ikon toggle tema
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;

    return Scaffold(
      backgroundColor: palette.bg,
      appBar: AppBar(
        backgroundColor: palette.bg,
        elevation: 0,
        // Matiin shadow & tint M3 pas di-scroll — border tebal kita
        // yang jadi pemisah
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        // Border bawah tebal via shape (gak nambah tinggi AppBar)
        shape: Border(bottom: BorderSide(color: palette.ink, width: 3)),
        title: Text(
          'NUSABOOKSTORE',
          style: GoogleFonts.archivoBlack(fontSize: 22, color: palette.ink),
        ),
        actions: [
          // Toggle Light/Dark — persegi kuning border ink.
          // Ikon: dark_mode pas lagi terang, light_mode pas gelap.
          // AKSI tetap pakai READ — aturan gak berubah!
          NeoIconButton(
            color: NeoColors.kuning,
            icon: isDarkMode ? Icons.light_mode : Icons.dark_mode,
            tooltip: isDarkMode ? 'Mode Terang' : 'Mode Gelap',
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
          ),
          const SizedBox(width: 8),
          const CartIconButton(),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _daftarBuku.length,
        itemBuilder: (context, index) {
          return _BookCard(
            book: _daftarBuku[index],
            genre: _genre[index],
            // Aksen BERGANTIAN per index
            aksen: NeoColors.accents[index % NeoColors.accents.length],
          );
        },
      ),
    );
  }
}

// ============================================================
// KARTU PER BUKU — NeoCard + sticker + chip harga + NeoButton
// ============================================================
class _BookCard extends StatelessWidget {
  final Book book;
  final String genre;
  final Color aksen;

  const _BookCard({
    required this.book,
    required this.genre,
    required this.aksen,
  });

  @override
  Widget build(BuildContext context) {
    final palette = NeoColors.of(context);

    return Padding(
      // Jarak antar card — kasih ruang buat hard shadow (6px)
      padding: const EdgeInsets.only(bottom: 20),
      child: NeoCard(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== Gambar + genre sticker =====
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // Gambar — border ink 2 + ClipRRect + errorBuilder (tetap)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: palette.ink, width: 2),
                    ),
                    child: ClipRRect(
                      // 12 - 2 biar gambar gak nimpa border di sudut
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        book.imageUrl,
                        width: 92,
                        height: 138,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 92,
                          height: 138,
                          color: NeoColors.lavender,
                          child: const Icon(
                            Icons.menu_book,
                            color: NeoColors.onAccent,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Genre sticker — aksen bergantian, dirotasi -2°,
                  // nempel di pojok kiri atas gambar (nongol keluar dikit)
                  Positioned(
                    top: -10,
                    left: -10,
                    child: Transform.rotate(
                      angle: -2 * math.pi / 180, // -2 derajat → radian
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: aksen,
                          border: Border.all(color: palette.ink, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          genre.toUpperCase(),
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: NeoColors.onAccent,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),

              // ===== Kolom info =====
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Judul — Archivo Black, UPPERCASE
                    Text(
                      book.title.toUpperCase(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.archivoBlack(
                        fontSize: 18,
                        height: 1.15,
                        color: palette.ink,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Author — Space Grotesk, abu adaptif
                    Text(
                      book.author,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 13,
                        color: palette.inkSoft,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Harga — chip aksen, Archivo Black UPPERCASE
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: aksen,
                        border: Border.all(color: palette.ink, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        formatRupiah(book.price).toUpperCase(),
                        style: GoogleFonts.archivoBlack(
                          fontSize: 13,
                          color: NeoColors.onAccent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Tombol — LOGIC TIDAK BERUBAH:
                    // read + addItem + SnackBar
                    NeoButton(
                      label: 'Tambah ke Keranjang',
                      color: NeoColors.kuning,
                      icon: Icons.add_shopping_cart,
                      onPressed: () {
                        context.read<CartProvider>().addItem(book);

                        showNeoSnackBar(
                          context,
                          'Berhasil ditambahkan ke keranjang',
                        );
                      },
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
