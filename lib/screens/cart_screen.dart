import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../main.dart'; // design system: NeoColors, NeoCard, NeoButton, NeoIconButton, CartIconButton, showNeoSnackBar
import '../providers/cart_provider.dart';
import 'catalog_screen.dart'; // formatRupiah

// ============================================================
// HALAMAN KERANJANG — versi NEOBRUTALISM
// Logic gak berubah sama sekali: watch buat tampilan,
// read buat aksi (decrement/increment/remove/clear).
// ============================================================
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = NeoColors.of(context);

    // WATCH — list & kondisi kosong real-time
    final cart = context.watch<CartProvider>();
    final kosong = cart.items.isEmpty;

    return Scaffold(
      backgroundColor: palette.bg,
      appBar: AppBar(
        backgroundColor: palette.bg,
        foregroundColor: palette.ink, // back arrow ikut warna ink
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        // Border bawah tebal — sama persis katalog
        shape: Border(bottom: BorderSide(color: palette.ink, width: 3)),
        title: Text(
          'KERANJANG',
          style: GoogleFonts.archivoBlack(fontSize: 22, color: palette.ink),
        ),
        actions: const [CartIconButton()], // badge real-time
      ),

      // ===== 2 KONDISI =====
      body: kosong
          ? const _EmptyCart()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                return _CartItemCard(item: cart.items[index]);
              },
            ),

      // Bawah FIXED — di luar ListView biar gak ikut scroll
      bottomNavigationBar: kosong
          ? null
          : const SafeArea(child: _CartBottomBar()),
    );
  }
}

// ---------- Kondisi 1: KERANJANG KOSONG ----------
class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    final palette = NeoColors.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ikon keranjang besar dalam lingkaran border ink + hard shadow
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: palette.surface,
                shape: BoxShape.circle,
                border: Border.all(color: palette.ink, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: palette.ink,
                    offset: const Offset(6, 6),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Icon(
                Icons.shopping_cart_outlined,
                size: 64,
                color: palette.ink,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'Keranjang masih kosong',
              textAlign: TextAlign.center,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: palette.ink,
              ),
            ),
            const SizedBox(height: 24),

            // Cukup pop — halaman ini didorong DI ATAS Katalog
            NeoButton(
              label: 'Kembali Belanja',
              color: NeoColors.mint,
              icon: Icons.menu_book,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- Kondisi 2: KARTU PER ITEM ----------
class _CartItemCard extends StatelessWidget {
  final CartItem item;

  const _CartItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final palette = NeoColors.of(context);

    // Aksen STABIL per buku — buku yang sama dapat warna sama
    // kayak di Katalog (di sana index = id - 1)
    final aksen =
        NeoColors.accents[(item.book.id - 1) % NeoColors.accents.length];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16), // 16 antar card
      child: NeoCard(
        child: Padding(
          padding: const EdgeInsets.all(12), // 12 dalam card
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar kecil — border ink 2 + errorBuilder (tetap)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: palette.ink, width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item.book.imageUrl,
                    width: 64,
                    height: 92,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 64,
                      height: 92,
                      color: NeoColors.lavender,
                      child: const Icon(
                        Icons.menu_book,
                        color: NeoColors.onAccent,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Kolom info + aksi
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Judul + tombol hapus
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.book.title.toUpperCase(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.archivoBlack(
                              fontSize: 15,
                              height: 1.15,
                              color: palette.ink,
                            ),
                          ),
                        ),
                        // Hapus — persegi coral (token oranye) border ink
                        NeoIconButton(
                          color: NeoColors.oranye,
                          icon: Icons.delete_outline,
                          tooltip: 'Hapus',
                          onPressed: () {
                            // AKSI pakai READ
                            context.read<CartProvider>().removeItem(
                              item.book.id,
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Harga satuan
                    Text(
                      formatRupiah(item.book.price),
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: palette.inkSoft,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Quantity: − (pink) / angka besar / + (mint)
                    // + subtotal chip aksen
                    Row(
                      children: [
                        NeoIconButton(
                          color: NeoColors.pink,
                          icon: Icons.remove,
                          tooltip: 'Kurangi',
                          onPressed: () {
                            // − sampai 0 → item TERHAPUS otomatis
                            // (logic-nya di provider, gak berubah)
                            context.read<CartProvider>().decrementQty(
                              item.book.id,
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 36,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '${item.quantity}',
                              style: GoogleFonts.archivoBlack(
                                fontSize: 20,
                                color: palette.ink,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        NeoIconButton(
                          color: NeoColors.mint,
                          icon: Icons.add,
                          tooltip: 'Tambah',
                          onPressed: () {
                            context.read<CartProvider>().incrementQty(
                              item.book.id,
                            );
                          },
                        ),

                        // Subtotal chip — nempel kanan.
                        // Flexible + FittedBox: pas subtotalnya panjang
                        // (misal RP 9.500.000) chip auto-nyusut,
                        // GAK PERNAH overflow
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: aksen,
                                  border: Border.all(
                                    color: palette.ink,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  formatRupiah(item.book.price * item.quantity)
                                      .toUpperCase(),
                                  style: GoogleFonts.archivoBlack(
                                    fontSize: 13,
                                    color: NeoColors.onAccent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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

// ---------- Bagian bawah: TOTAL + Checkout ----------
class _CartBottomBar extends StatelessWidget {
  const _CartBottomBar();

  // Urutan & logic TIDAK BERUBAH: (a) SnackBar dulu, (b) clearCart.
  // Setelah clearCart → semua yang watch (halaman ini + badge di
  // semua halaman) rebuild → otomatis balik ke empty state.
  void _checkout(BuildContext context) {
    showNeoSnackBar(context, 'Checkout berhasil!');
    context.read<CartProvider>().clearCart();
  }

  @override
  Widget build(BuildContext context) {
    // WATCH — total auto-update tiap qty berubah
    final cart = context.watch<CartProvider>();

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // TOTAL — NeoCard kuning
          NeoCard(
            color: NeoColors.kuning,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TOTAL',
                    style: GoogleFonts.archivoBlack(
                      fontSize: 18,
                      color: NeoColors.onAccent,
                    ),
                  ),
                  Text(
                    formatRupiah(cart.totalPrice).toUpperCase(),
                    style: GoogleFonts.archivoBlack(
                      fontSize: 22,
                      color: NeoColors.onAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Checkout — NeoButton pink full-width
          NeoButton(
            label: 'Checkout / Bayar',
            color: NeoColors.pink,
            icon: Icons.payment,
            onPressed: () => _checkout(context),
          ),
        ],
      ),
    );
  }
}
