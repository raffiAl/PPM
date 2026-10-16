import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import 'catalog_screen.dart'; // formatRupiah didefinisikan di sana

// ============================================================
// WIDGET REUSABLE — CartIconButton
// Ikon keranjang + badge jumlah item (Stack + Positioned).
// Dulunya class _CartIconWithBadge di catalog_screen.dart — sekarang
// jadi PUBLIC dan dipakai di AppBar Katalog DAN Keranjang.
// Cuma ada SATU versi kode badge di seluruh app (anti copy-paste).
//
// WATCH di sini (tampilan): badge auto-update tiap keranjang berubah
// ============================================================
class CartIconButton extends StatelessWidget {
  const CartIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // WATCH (tampilan): totalItems harus selalu fresh
    final totalItems = context.watch<CartProvider>().totalItems;

    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          tooltip: 'Keranjang',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartScreen()),
            );
          },
        ),

        // Badge angka — cuma muncul kalau totalItems > 0
        if (totalItems > 0)
          Positioned(
            top: 4,
            right: 4,
            // IgnorePointer biar badge gak "makan" sentuhan ikon
            child: IgnorePointer(
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  // borderRadius (bukan shape.circle) biar pas angkanya
                  // 2 digit bentuknya jadi kapsul, bukan ke-overflow
                  color: colorScheme.error,
                  borderRadius: BorderRadius.circular(100),
                ),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                child: Center(
                  child: Text(
                    '$totalItems',
                    style: TextStyle(
                      color: colorScheme.onError,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ============================================================
// HALAMAN KERANJANG
// ============================================================
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // WATCH: list & kondisi kosong ke-update real-time tiap qty
    // berubah / item dihapus / checkout
    final cart = context.watch<CartProvider>();
    final kosong = cart.items.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang'),
        // back arrow otomatis — halaman ini didorong lewat Navigator.push
        actions: const [
          CartIconButton(), // widget reusable — badge real-time
        ],
      ),

      // ===== 2 KONDISI =====
      body: kosong
          ? const _EmptyCart()
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                return _CartItemCard(item: cart.items[index]);
              },
            ),

      // Bagian bawah FIXED — di luar ListView biar gak ikut scroll
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
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ikon keranjang besar "abu" — pakai warna scheme biar
            // tetap oke di dark mode (bukan Colors.grey hardcoded)
            Icon(
              Icons.shopping_cart_outlined,
              size: 100,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Keranjang masih kosong',
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),

            // Cukup pop — halaman ini memang didorong DI ATAS Katalog
            FilledButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.menu_book),
              label: const Text('Kembali Belanja'),
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
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar kecil (cover buku) — ClipRRect + errorBuilder
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.book.imageUrl,
                width: 70,
                height: 105,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 70,
                  height: 105,
                  color: colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.menu_book,
                    color: colorScheme.onSurfaceVariant,
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
                          item.book.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Hapus item — AKSI pakai READ
                      IconButton(
                        onPressed: () {
                          context.read<CartProvider>().removeItem(item.book.id);
                        },
                        icon: const Icon(Icons.delete_outline),
                        color: colorScheme.error,
                        tooltip: 'Hapus',
                      ),
                    ],
                  ),

                  // Penulis
                  Text(
                    item.book.author,
                    style: TextStyle(
                      fontSize: 13,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Harga satuan
                  Text(
                    formatRupiah(item.book.price),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Baris quantity (− qty +) + subtotal
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Tombol − dan + — AKSI pakai READ.
                      // decrementQty otomatis HAPUS item pas qty sampai 0
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              context.read<CartProvider>().decrementQty(
                                item.book.id,
                              );
                            },
                            icon: const Icon(Icons.remove_circle_outline),
                            tooltip: 'Kurangi',
                          ),
                          SizedBox(
                            width: 32,
                            child: Center(
                              child: Text(
                                '${item.quantity}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              context.read<CartProvider>().incrementQty(
                                item.book.id,
                              );
                            },
                            icon: const Icon(Icons.add_circle_outline),
                            tooltip: 'Tambah',
                          ),
                        ],
                      ),

                      // Subtotal = harga satuan × qty
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Subtotal',
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            formatRupiah(item.book.price * item.quantity),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
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

// ---------- Bagian bawah: total harga + checkout ----------
class _CartBottomBar extends StatelessWidget {
  const _CartBottomBar();

  // Checkout: (a) SnackBar dulu, (b) baru clearCart.
  // Setelah clearCart, halaman otomatis balik ke empty state karena
  // CartScreen nge-watch provider
  void _checkout(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Checkout berhasil! Terima kasih sudah berbelanja'),
        duration: Duration(seconds: 2),
      ),
    );
    context.read<CartProvider>().clearCart();
  }

  @override
  Widget build(BuildContext context) {
    // WATCH: total harga auto-update tiap qty berubah
    final cart = context.watch<CartProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant, width: 1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Total harga — auto-update
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Text(
                formatRupiah(cart.totalPrice),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Checkout full-width
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _checkout(context),
              icon: const Icon(Icons.payment),
              label: const Text('Checkout / Bayar'),
            ),
          ),
        ],
      ),
    );
  }
}
