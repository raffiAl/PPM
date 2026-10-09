import 'dart:async'; // WAJIB DIIMPORT untuk pakai Timer

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // state keranjang global

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp DIBUNGKUS ChangeNotifierProvider.
    // Efeknya: CartProvider hidup DI ATAS semua halaman, jadi state
    // keranjang bertahan walau pindah-pindah halaman / push-pop route.
    return ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: MaterialApp(
        title: 'Product & Profile App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 240, 58, 134),
          ),
          useMaterial3: true,
        ),
        home: const ProfilePage(title: 'PPM Sesi 2 - Moh. Raffi Alfatih'),
      ),
    );
  }
}

// ============================================================
// MODEL — 1 item di keranjang
// ============================================================
class CartItem {
  final String nama;
  final int harga; // harga SATUAN (int, rupiah)
  final String gambar; // url gambar
  int jumlah; // bisa berubah (di +/-/hapus), makanya gak final

  CartItem({
    required this.nama,
    required this.harga,
    required this.gambar,
    required this.jumlah,
  });
}

// ============================================================
// STATE KERANJANG GLOBAL — CartProvider
// Semua halaman (Produk, Keranjang, badge AppBar) baca dari sini.
// Setiap ada perubahan → panggil notifyListeners() biar UI ke-update.
// ============================================================
class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  // Daftar item (buat UI halaman Keranjang nanti)
  List<CartItem> get items => _items;

  // Total SEMUA jumlah — buat badge keranjang (contoh: 2 item x 3 = 6)
  int get totalQuantity => _items.fold(0, (total, item) => total + item.jumlah);

  // Total harga = harga satuan x jumlah, dijumlahkan semua item
  int get totalPrice =>
      _items.fold(0, (total, item) => total + (item.harga * item.jumlah));

  // Cari item berdasarkan nama (kalau gak ada → null)
  CartItem? _cariItem(String nama) {
    for (final item in _items) {
      if (item.nama == nama) return item;
    }
    return null;
  }

  // Tambah produk ke keranjang.
  // Kalau item yang sama udah ada → jumlahnya ditambah, JANGAN duplikat.
  void addItem({
    required String nama,
    required int harga,
    required String gambar,
    required int jumlah,
  }) {
    final sudahAda = _cariItem(nama);
    if (sudahAda != null) {
      sudahAda.jumlah += jumlah; // item sama, jumlah ditumpuk
    } else {
      _items.add(
        CartItem(nama: nama, harga: harga, gambar: gambar, jumlah: jumlah),
      );
    }
    notifyListeners();
  }

  // Tambah jumlah 1 item (+1)
  void tambahJumlah(String nama) {
    final item = _cariItem(nama);
    if (item != null) {
      item.jumlah++;
      notifyListeners();
    }
  }

  // Kurangi jumlah 1 item (minimal 1 — buat hapus total, ada removeItem)
  void kurangiJumlah(String nama) {
    final item = _cariItem(nama);
    if (item != null && item.jumlah > 1) {
      item.jumlah--;
      notifyListeners();
    }
  }

  // Hapus 1 item dari keranjang
  void removeItem(String nama) {
    _items.removeWhere((item) => item.nama == nama);
    notifyListeners();
  }

  // Kosongkan seluruh keranjang
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}

// ============================================================
// HELPER FORMAT RUPIAH — 150000 → "Rp 150.000"
// Tanpa package intl: sisipkan titik tiap 3 digit dari belakang
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
// HALAMAN 1: PROFILE
// Fix tahap ini: ikon keranjang sekarang pakai CartIconButton
// (widget reusable) → badge jumlah item juga muncul di sini.
// ============================================================
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        // Ikon keranjang + badge — SEKARANG pakai CartIconButton.
        // Gak perlu atur tombol back — Profile ini route pertama,
        // jadi back arrow-nya otomatis gak muncul.
        actions: const [CartIconButton()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // a. Kartu mahasiswa — versi CENTERED
            StudentCard(
              nama: 'Moh. Raffi Alfatih',
              nim: '20240040066',
              prodi: 'Teknik Informatika',
            ),
            const SizedBox(height: 24),

            // b + c. Tombol full-width → ke halaman Produk
            // Style PERSIS kayak tombol Add to Cart di ProductCard
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProductPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.storefront),
                label: const Text('Lihat Produk'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 240, 58, 134),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// HALAMAN 2: PRODUK
// Fix tahap ini: kode badge yang tadinya nempel langsung di sini
// DIHAPUS (pindah ke CartIconButton) — biar gak ada 2 versi kode
// badge yang beda. Baris context.watch di build juga gak perlu lagi.
// ============================================================
class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text('Produk'),
        centerTitle: true,
        // Ikon keranjang + badge — sekarang cukup panggil widget reusable
        actions: const [CartIconButton()],
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // a. PromoBanner — DIPINDAH dari Profile, dipakai lagi di sini
            PromoBanner(),
            SizedBox(height: 20),

            // b. ProductCard — semua fitur lama tetap
            // (gambar, likes, auto-repeat +/-, Add to Cart)
            ProductCard(),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// HALAMAN 3: KERANJANG
// Fix tahap ini: CartIconButton juga dipasang di AppBar sini biar
// badge konsisten di SEMUA halaman (sesuai test checklist).
// ============================================================
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch: tiap ada perubahan di CartProvider (tambah/kurang/hapus/
    // clear), halaman ini rebuild otomatis — list & total selalu fresh
    final cart = context.watch<CartProvider>();
    final kosong = cart.items.isEmpty;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text('Keranjang Saya'),
        centerTitle: true, // back arrow otomatis (bukan route pertama)
        // Badge juga tampil di sini biar konsisten di semua halaman
        actions: const [CartIconButton()],
      ),

      // ===== 2 KONDISI: kosong / ada item =====
      body: kosong
          ? const _EmptyCart()
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final item = cart.items[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  // ValueKey biar state tiap kartu "nempel" ke item yang
                  // bener pas daftar berubah (ada yang kehapus, dll.)
                  child: _CartItemCard(key: ValueKey(item.nama), item: item),
                );
              },
            ),

      // ===== Bagian bawah FIXED — di luar ListView biar gak ikut scroll =====
      bottomNavigationBar: kosong
          ? null
          : const SafeArea(child: _CartBottomBar()),
    );
  }
}

// ---------- Kondisi 1: KERANJANG KOSONG (empty state) ----------
class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shopping_cart_outlined,
              size: 100,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'Keranjang kamu masih kosong',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // "Kembali Belanja" — style pink yang sama kayak tombol lain
            ElevatedButton.icon(
              onPressed: () {
                // pushReplacement: halaman Keranjang DIGANTI Produk,
                // jadi back dari Produk balik ke Profile — bukan ke
                // keranjang kosong lagi
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ProductPage()),
                );
              },
              icon: const Icon(Icons.storefront),
              label: const Text('Kembali Belanja'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 240, 58, 134),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- Kondisi 2: KARTU TIAP ITEM ----------
// Style Card sama kayak halaman lain (elevation 8, radius 15,
// surfaceContainerHighest)
class _CartItemCard extends StatelessWidget {
  final CartItem item;

  const _CartItemCard({super.key, required this.item});

  // Hapus item + feedback SnackBar (konsisten sama fitur lainnya)
  void _hapus(BuildContext context) {
    context.read<CartProvider>().removeItem(item.nama);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.nama} dihapus dari keranjang'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Baris atas: gambar + nama + harga satuan + tombol hapus
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar kecil — ClipRRect + errorBuilder (sama kayak Produk)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    item.gambar,
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 80,
                      width: 80,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.nama,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatRupiah(item.harga), // harga SATUAN
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 240, 58, 134),
                        ),
                      ),
                    ],
                  ),
                ),
                // Tombol hapus item
                IconButton(
                  onPressed: () => _hapus(context),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  tooltip: 'Hapus item',
                ),
              ],
            ),
            const Divider(thickness: 1.5),

            // Baris bawah: jumlah (+/-) + subtotal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Widget reusable! Logika "apa yang terjadi saat jumlah = 1"
                // ada DI SINI (si pemanggil): di Keranjang → item DIHAPUS
                // (beda sama di halaman Produk → SnackBar "minimal 1")
                QuantitySelector(
                  jumlah: item.jumlah,
                  onTambah: () =>
                      context.read<CartProvider>().tambahJumlah(item.nama),
                  onKurang: () {
                    if (item.jumlah == 1) {
                      _hapus(context); // mentok 1 → hapus dari daftar
                    } else {
                      context.read<CartProvider>().kurangiJumlah(item.nama);
                    }
                  },
                ),

                // Subtotal = harga satuan × jumlah
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Subtotal',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      formatRupiah(item.harga * item.jumlah),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 240, 58, 134),
                      ),
                    ),
                  ],
                ),
              ],
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

  // Checkout dummy: tampilin dialog sukses → kosongin keranjang
  void _checkout(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // harus tekan OK biar alurnya jelas
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Column(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 56),
              SizedBox(height: 8),
              Text('Checkout Berhasil!', textAlign: TextAlign.center),
            ],
          ),
          content: const Text(
            'Terima kasih sudah berbelanja!\nPesananmu sedang diproses.',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext); // tutup dialog dulu
                context.read<CartProvider>().clearCart(); // baru kosongin
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Total harga semua item
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total', style: TextStyle(fontSize: 16)),
              Text(
                formatRupiah(cart.totalPrice),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 240, 58, 134),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Tombol Checkout full-width — style pink yang sama
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _checkout(context),
              icon: const Icon(Icons.payment),
              label: const Text('Checkout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 240, 58, 134),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// WIDGET REUSABLE — CartIconButton  🆕 FIX BADGE
// Ikon keranjang + badge jumlah item (Stack + Positioned).
// Dipakai di AppBar SEMUA halaman biar badge-nya konsisten.
//
// KENAPA WAJIB context.watch, BUKAN context.read?
// - watch = buat TAMPILAN yang harus rebuild pas data berubah.
//   Badge harus ke-update real-time tiap keranjang berubah.
// - read = buat AKSI/klik (dipakai di dalam onPressed/callback),
//   gak memicu rebuild. Kalau badge pakai read, dia gak akan pernah
//   ke-update — inilah penyebab paling umum badge "diam aja".
// ============================================================
class CartIconButton extends StatelessWidget {
  const CartIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch: begitu CartProvider berubah (addItem/removeItem/clearCart),
    // widget ini auto rebuild → angka badge ke-update real-time
    final int totalItem = context.watch<CartProvider>().totalQuantity;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Stack(
        children: [
          // Tombol keranjang → ke halaman Keranjang
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            tooltip: 'Keranjang',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
          ),

          // Badge angka — Stack + Positioned, style SAMA PERSIS kayak
          // yang dulu nempel di halaman Produk.
          // Cuma muncul kalau total item > 0 (kalau 0 → ikon polos)
          if (totalItem > 0)
            Positioned(
              top: 4,
              right: 4,
              // IgnorePointer biar badge gak "makan" sentuhan
              // di area ikon keranjang
              child: IgnorePointer(
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 240, 58, 134),
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Center(
                    child: Text(
                      '$totalItem',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ============================================================
// WIDGET REUSABLE — QuantitySelector
// Tombol +/- dengan fitur tahan-tombol auto-repeat (Listener + Timer).
// Diekstrak dari ProductCard biar bisa dipakai di Keranjang juga.
//
// Pembagian tugas:
// - WIDGET ini: urus tahan-tombol, Timer, dispose (anti memory leak)
// - SI PEMANGGIL: tentuin APA yang terjadi lewat callback
//   onTambah/onKurang (naikin _jumlah di Produk, tambah/hapus
//   item di Keranjang)
// ============================================================
class QuantitySelector extends StatefulWidget {
  final int jumlah; // jumlah sekarang (ditampilin di tengah tombol)
  final VoidCallback onTambah;
  final VoidCallback onKurang;

  const QuantitySelector({
    super.key,
    required this.jumlah,
    required this.onTambah,
    required this.onKurang,
  });

  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  Timer? _timer;

  // Mesin auto-repeat: jalan instan sekali pas jari nyentuh,
  // terus ngulang tiap 100 ms selama ditahan.
  // [berhentiJika] = kondisi buat stop ngulang otomatis.
  void _startAutoRepeat(VoidCallback action, {bool Function()? berhentiJika}) {
    if (_timer != null) return;

    action(); // langsung jalan sekali

    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (berhentiJika != null && berhentiJika()) {
        _stopAutoRepeat();
        return;
      }
      action();
    });
  }

  void _stopAutoRepeat() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  @override
  void dispose() {
    _stopAutoRepeat(); // WAJIB bersihin timer biar gak memory leak
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Tombol Kurang (-) dengan deteksi tahan
        Listener(
          onPointerDown: (_) => _startAutoRepeat(
            widget.onKurang,
            // Pas jumlah udah 1 → ngulangnya berhenti otomatis (biar gak
            // spam respons). Panggilan PERTAMA tetap jalan, jadi si
            // pemanggil tetap bisa ngasih respons: di Produk → SnackBar,
            // di Keranjang → hapus item. Widget ini gak ikut campur.
            berhentiJika: () => widget.jumlah <= 1,
          ),
          onPointerUp: (_) => _stopAutoRepeat(),
          onPointerCancel: (_) => _stopAutoRepeat(),
          child: FloatingActionButton.small(
            onPressed: () {}, // kosongin aja, logika udah di Listener
            tooltip: 'Kurang (Tahan untuk auto)',
            backgroundColor: Colors.redAccent.shade100,
            child: const Icon(Icons.remove),
          ),
        ),
        SizedBox(
          width: 40,
          child: Text(
            '${widget.jumlah}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        // Tombol Tambah (+) dengan deteksi tahan
        Listener(
          onPointerDown: (_) => _startAutoRepeat(widget.onTambah),
          onPointerUp: (_) => _stopAutoRepeat(),
          onPointerCancel: (_) => _stopAutoRepeat(),
          child: FloatingActionButton.small(
            onPressed: () {}, // kosongin aja, logika udah di Listener
            tooltip: 'Tambah (Tahan untuk auto)',
            backgroundColor: Colors.greenAccent.shade100,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// KARTU MAHASISWA — SUDAH JADI, TIDAK DIUBAH
// ============================================================
class StudentCard extends StatelessWidget {
  final String nama;
  final String nim;
  final String prodi;

  const StudentCard({
    super.key,
    required this.nama,
    required this.nim,
    required this.prodi,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          // SEMUA CENTER
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header tetap dipertahankan biar konsisten sama kartu produk
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
            const SizedBox(height: 16),

            // Foto profil — default ikon person background pink.
            // Kalau nanti punya foto asset, tinggal ganti jadi:
            // CircleAvatar(
            //   radius: 65,
            //   backgroundImage: AssetImage('assets/foto.jpg'),
            // )
            const CircleAvatar(
              radius: 65,
              backgroundColor: Color.fromARGB(255, 240, 58, 134),
              child: Icon(Icons.person, size: 70, color: Colors.white),
            ),
            const SizedBox(height: 16),

            // Nama — besar & bold
            Text(
              nama,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),

            // NIM — lebih kecil, abu-abu
            Text(
              nim,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.grey,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 4),

            // Program Studi — lebih kecil, abu-abu
            Text(
              prodi,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// BANNER PROMOSI — Stack + Positioned (syarat tugas)
// ============================================================
class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Layer dasar banner
        Container(
          height: 130,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 240, 58, 134),
                Color.fromARGB(255, 250, 150, 195),
              ],
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'DISKON 50%',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Khusus pembelian hari ini, buruan checkout!',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),

        // Badge "PROMO" nempel di pojok kanan atas (Positioned)
        Positioned(
          top: 10,
          right: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'PROMO',
              style: TextStyle(
                color: Color.fromARGB(255, 240, 58, 134),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // Ikon kecil di pojok kanan bawah (Positioned)
        const Positioned(
          bottom: 10,
          right: 10,
          child: Icon(Icons.local_offer, color: Colors.white70),
        ),
      ],
    );
  }
}

// ============================================================
// KARTU PRODUK — StatefulWidget (TIDAK DIUBAH tahap ini)
// ============================================================
class ProductCard extends StatefulWidget {
  const ProductCard({super.key});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  // ---------- DATA PRODUK (konstanta) ----------
  // Dipakai buat nampilin UI DAN dikirim ke keranjang pas Add to Cart
  static const String _namaProduk = 'Boneka Anjing Lucu';
  static const int _hargaProduk = 150000;
  static const String _gambarProduk = 'https://picsum.photos/id/237/400/250';

  // ---------- STATE ----------
  int _jumlah = 1; // jumlah yang lagi dipilih (minimal 1)
  int _likes = 128; // jumlah like awal
  bool _isFavorite = false; // status favorit

  // ---------- AKSI FAVORITE (hati) ----------
  void _toggleFavorite() {
    setState(() {
      if (_isFavorite) {
        _likes--; // batal like
      } else {
        _likes++; // tambah like
      }
      _isFavorite = !_isFavorite;
    });
  }

  // ---------- AKSI JUMLAH (+ / -) — logikanya tetap DI SINI ----------
  void _tambahJumlah() {
    setState(() {
      _jumlah++;
    });
  }

  void _kurangiJumlah() {
    if (_jumlah > 1) {
      setState(() {
        _jumlah--; // hanya bisa dikurangi kalau masih di atas 1
      });
    } else {
      // Di halaman PRODUK: mentok 1 → SnackBar.
      // (Beda sama di KERANJANG: di sana mentok 1 → item dihapus.
      //  Makanya logika kayak gini ditaruh di pemanggil, bukan di widget)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jumlah minimal 1!'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  // ---------- ADD TO CART — nyimpen ke CartProvider ----------
  void _addToCart() {
    context.read<CartProvider>().addItem(
      nama: _namaProduk,
      harga: _hargaProduk,
      gambar: _gambarProduk,
      jumlah: _jumlah, // jumlah yang lagi dipilih SAAT INI
    );

    // Feedback SnackBar tetap ada
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Berhasil menambahkan $_jumlah produk ke keranjang!'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header, disamain kayak kartu mahasiswa biar desain konsisten
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'DETAIL PRODUK',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                Icon(
                  Icons.shopping_bag,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
            const Divider(thickness: 1.5),
            const SizedBox(height: 10),

            // Gambar produk
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                _gambarProduk,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 64, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Nama, harga & deskripsi produk
            Text(
              _namaProduk,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              formatRupiah(_hargaProduk), // 150000 → "Rp 150.000"
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 240, 58, 134),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Boneka super lucu & lembut, cocok buat hadiah.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 12),

            // Tombol FAVORITE (hati) — jumlah likes ikut berubah
            Row(
              children: [
                IconButton(
                  onPressed: _toggleFavorite,
                  icon: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite
                        ? const Color.fromARGB(255, 240, 58, 134)
                        : Colors.grey,
                    size: 28,
                  ),
                ),
                Text(
                  '$_likes likes',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const Divider(thickness: 1.5),

            // Jumlah (+ / -) — sekarang pakai QuantitySelector (reusable).
            // Widget-nya cuma urus tahan-tombol + Timer;
            // logika naik/turun + SnackBar tetap DI SINI (si pemanggil)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Jumlah', style: TextStyle(fontSize: 16)),
                QuantitySelector(
                  jumlah: _jumlah,
                  onTambah: _tambahJumlah,
                  onKurang: _kurangiJumlah,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Tombol ADD TO CART — nyimpen ke CartProvider + Snackbar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _addToCart,
                icon: const Icon(Icons.shopping_cart),
                label: const Text('Add to Cart'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 240, 58, 134),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
