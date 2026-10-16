import 'package:flutter/foundation.dart'; // buat ChangeNotifier

import '../models/book.dart';

// 1 baris keranjang = buku + jumlahnya.
// Ditaruh di file ini (BUKAN file terpisah) biar struktur folder
// tetap PERSIS syarat tugas: models/ cuma boleh berisi book.dart.
class CartItem {
  final Book book;
  int quantity; // bisa berubah (+/-/hapus), makanya gak final

  CartItem({required this.book, required this.quantity});
}

// State keranjang GLOBAL.
// Dua aturan penting:
// 1. Setiap method yang MENGUBAH state wajib panggil notifyListeners()
// 2. JANGAN pakai context di dalam provider — provider gak tau
//    apa-apa soal UI, tugasnya cuma kelola data + kabarin listener.
//    (Buktinya: file ini cuma import foundation, gak import material)
class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  // Daftar item keranjang (buat UI halaman Keranjang nanti)
  List<CartItem> get items => _items;

  // Total SEMUA quantity — buat badge keranjang (misal: 2 buku x 3 = 6)
  // Getter gak perlu notifyListeners karena gak mengubah state
  int get totalItems => _items.fold(0, (total, item) => total + item.quantity);

  // Total harga = harga buku × quantity, dijumlah semua item
  int get totalPrice => _items.fold(
    0,
    (total, item) => total + (item.book.price * item.quantity),
  );

  // Helper: cari item berdasarkan id buku (kalau gak ada → null)
  CartItem? _findItem(int id) {
    for (final item in _items) {
      if (item.book.id == id) return item;
    }
    return null;
  }

  // Tambah buku ke keranjang.
  // Buku yang SAMA udah ada → quantity bertambah, JANGAN duplikat entry.
  void addItem(Book book) {
    final sudahAda = _findItem(book.id);
    if (sudahAda != null) {
      sudahAda.quantity++;
    } else {
      _items.add(CartItem(book: book, quantity: 1));
    }
    notifyListeners(); // state berubah → kabarin UI
  }

  // Hapus 1 item dari keranjang (berdasarkan id buku)
  void removeItem(int id) {
    _items.removeWhere((item) => item.book.id == id);
    notifyListeners();
  }

  // Tambah jumlah 1 item (+1)
  void incrementQty(int id) {
    final item = _findItem(id);
    if (item != null) {
      item.quantity++;
      notifyListeners();
    }
  }

  // Kurangi jumlah 1 item. Pas quantity sampai 0 → item TERHAPUS otomatis.
  void decrementQty(int id) {
    final item = _findItem(id);
    if (item == null) return; // item gak ada → gak ada yang berubah

    if (item.quantity > 1) {
      item.quantity--;
    } else {
      // quantity bakal jadi 0 → hapus entry-nya
      _items.removeWhere((i) => i.book.id == id);
    }
    notifyListeners();
  }

  // Kosongkan seluruh keranjang (dipanggil pas Checkout nanti)
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
