````markdown
# 🛍️ Aplikasi Toko Sederhana — Flutter

**Tugas Pemrograman Perangkat Mobile (PPM)**

| | |
|---|---|
| **Nama** | Moh. Raffi Alfatih |
| **NIM** | 20240040066 |
| **Program Studi** | Teknik Informatika |

---

## 📖 Deskripsi Aplikasi

Aplikasi mobile **toko sederhana** yang dibangun menggunakan **Flutter (Dart)**.
Aplikasi terdiri dari **3 halaman** yang saling terhubung melalui tombol navigasi:

1. **Profile** — halaman pertama yang dilihat pengguna (identitas mahasiswa)
2. **Produk** — detail produk + tambah ke keranjang
3. **Keranjang** — ringkasan belanja + checkout

Data keranjang bersifat **global** menggunakan package `Provider` (state
management), sehingga tetap tersimpan saat berpindah halaman, dan jumlah
itemnya tampil sebagai **badge counter** pada ikon keranjang di AppBar —
di semua halaman, secara real-time.

---

## 🧭 Alur Navigasi

```
PROFILE ──"Lihat Produk"──► PRODUK ◄──"Kembali Belanja"── KERANJANG
   │                          │                              ▲
   └───── ikon keranjang ─────┴────── ikon keranjang ────────┘
```
> Ikon keranjang terdapat di AppBar kanan **setiap halaman**, dilengkapi badge
> jumlah item. Tombol back bawaan (Android/iOS) dapat digunakan untuk kembali
> ke halaman sebelumnya.

---

## ✨ Fitur per Halaman

### 1️⃣ Halaman Profile (Entry Point)
- Foto/ikon profil (CircleAvatar), Nama, NIM, dan Program Studi — tampil di tengah layar
- Tombol **"Lihat Produk"** → navigasi ke halaman Produk
- Ikon keranjang (dengan badge) di AppBar → navigasi ke halaman Keranjang

### 2️⃣ Halaman Produk
- Banner promosi dengan badge "PROMO"
- Detail produk: gambar, nama, harga, dan deskripsi
- Tombol **like/favorite** dengan counter yang berubah secara real-time
- Pengaturan jumlah produk dengan tombol **+ / −**
  - Tombol dapat **ditahan (hold)** untuk auto-repeat dengan interval 100 ms
- Tombol **Add to Cart** → menyimpan data ke keranjang (state global)
  + feedback SnackBar + badge counter ikon keranjang langsung bertambah

### 3️⃣ Halaman Keranjang
- Daftar item: gambar, nama, harga satuan, dan subtotal per item
- Ubah jumlah item (+ / −) → subtotal & total harga otomatis ter-update
- Hapus item dari keranjang
- Total harga keseluruhan + tombol **Checkout** (dialog sukses dummy, lalu
  keranjang dikosongkan)
- **Empty state**: ikon keranjang kosong + tombol "Kembali Belanja"

---

## 🧠 Konsep Flutter yang Diimplementasikan

| Konsep | Penerapan dalam Aplikasi |
|---|---|
| **StatelessWidget** | Halaman Profile & banner promo — tampilan statis |
| **StatefulWidget + `setState()`** | Kartu produk: jumlah, likes, dan status favorit berubah real-time |
| **Stack + Positioned** | Badge "PROMO" pada banner & badge angka pada ikon keranjang di AppBar |
| **Listener (raw pointer events)** | Deteksi tombol +/− yang *ditahan* — dipilih karena tidak ikut bersaing di *gesture arena* (tidak seperti GestureDetector) |
| **`Timer.periodic` + `dispose()`** | Auto-repeat tiap 100 ms; timer di-cancel saat widget dibuang untuk mencegah *memory leak* |
| **Navigator.push + MaterialPageRoute** | Navigasi antar 3 halaman |
| **Provider + ChangeNotifier** | State keranjang global — data bertahan saat berpindah halaman |
| **`context.watch` vs `context.read`** | `watch` untuk tampilan yang rebuild saat data berubah (badge); `read` untuk aksi (onPressed) |
| **SnackBar** | Feedback "berhasil ditambahkan ke keranjang" & batas jumlah minimal |
| **AlertDialog** | Pesan sukses checkout |
| **`Image.network` + `errorBuilder`** | Gambar dari internet dengan tampilan fallback jika gagal dimuat |

---

## 🛠️ Teknologi & Package

- **Flutter** (Material 3) & **Dart**
- [`provider`](https://pub.dev/packages/provider) — state management
- Gambar dummy dari [picsum.photos](https://picsum.photos) *(butuh koneksi internet)*

---

## 📂 Struktur Proyek

```
lib/
├── main.dart                
```

---

## ⚙️ Cara Menjalankan

```bash
# 1. Pastikan Flutter SDK terinstall
flutter --version

# 2. Install dependencies
flutter pub get

# 3. Jalankan di emulator / physical device
flutter run
```

---

## 🔧 Tantangan Teknis & Solusi

1. **Tombol +/− tidak responsif saat ditahan** — gesture dari `GestureDetector`
   kalah bersaing dengan `FloatingActionButton`. Solusi: memakai `Listener`
   yang bekerja di level *raw pointer events*.
2. **Potensi memory leak dari `Timer`** — solusi: timer selalu di-`cancel()`
   di `dispose()`.
3. **Badge keranjang tidak sinkron antar halaman** — awalnya badge hanya
   muncul di halaman Produk. Solusi: ikon keranjang diekstrak menjadi widget
   reusable (`CartIconButton`) yang memakai `context.watch`, dipakai di
   semua halaman sehingga tampilannya selalu konsisten.

---

## 📸 Screenshot

| Profile | Produk | Keranjang |
|:---:|:---:|:---:|
| ![](screenshots/profile.png) | ![](screenshots/produk.png) | ![](screenshots/keranjang.png) |
````

---

