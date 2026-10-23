🧭 Nusa Travel — Aplikasi Pariwisata Flutter
Tugas Pemrograman Perangkat Mobile (PPM) — Materi Navigation & Routing

Nama	Moh. Raffi Alfatih
NIM	20240040066
Program Studi	Teknik Informatika
📖 Deskripsi Aplikasi
Nusa Travel adalah aplikasi pariwisata sederhana yang dibangun menggunakanFlutter (Dart) dengan fokus utama pada penerapan Navigation & Routingmenggunakan Navigator 1.0 (named routes).

Aplikasi terdiri dari 5 halaman yang saling terhubung:

Splash Screen — halaman awal berisi logo dan tombol "Mulai Jelajah"
Home Screen — katalog paket wisata (Card + ListView) dan tombol logout
Detail Screen — detail paket wisata, menerima data melalui route arguments
Booking Screen — form pemesanan dengan dialog konfirmasi sebelum kembali
Not Found Screen — halaman 404 untuk route yang tidak dikenal
Aplikasi ini tanpa package tambahan — murni Flutter SDK.

🧭 Alur Navigasi
SPLASH ──"Mulai Jelajah"──► HOME ──tap kartu──► DETAIL ──"Pesan Sekarang"──► BOOKING   ▲                          │                   ▲                              │   │  logout (hapus semua     │                   │   pop dengan result          │   └──── history rute) ◄──────┘                   └──────── SnackBar ◄───────────┘Route tidak dikenal ──► 404 Not Found
Dari	Ke	Trigger	API Navigator
Splash	Home	Tombol "Mulai Jelajah"	pushReplacementNamed()
Home	Detail	Tap kartu paket	pushNamed() + arguments
Detail	Booking	Tombol "Pesan Sekarang"	Navigator.push()
Booking	Detail	Konfirmasi pesanan	Navigator.pop(context, result)
Detail	(tetap)	Hasil booking	SnackBar menampilkan result
Booking	(tetap)	Back / back sistem	PopScope + dialog konfirmasi
Home	Splash	Logout	pushNamedAndRemoveUntil()
Semua	Not Found	Route tidak dikenal	onUnknownRoute
📄 Fitur per Halaman
1️⃣ Splash Screen
Logo aplikasi, nama, dan tagline
Tombol "Mulai Jelajah" → berpindah ke Home tanpa menyisakan Splashdi history (pushReplacementNamed)
2️⃣ Home Screen
Menampilkan 6 paket wisata Indonesia (Bali, Raja Ampat, Bromo,Labuan Bajo, Borobudur, Danau Toba) — syarat minimal 4
Card + ListView.builder: gambar, judul, deskripsi singkat, harga (format Rupiah)
Tap kartu → Detail dengan data paket dikirim via arguments
Tombol logout dengan dialog konfirmasi → kembali ke Splash danmenghapus seluruh history rute (pushNamedAndRemoveUntil)
3️⃣ Detail Screen
Menerima objek TourPackage dari route arguments
Gambar besar, judul, harga menonjol, deskripsi lengkap, chip info (durasi & kuota)
Tombol "Pesan Sekarang" → Navigator.push ke Booking, lalu menungguhasil (await) dan menampilkannya sebagai SnackBar
4️⃣ Booking Screen
PopScope: tombol back (AppBar maupun sistem) memunculkan dialogkonfirmasi "Batalkan pemesanan?" sebelum benar-benar keluar
Form (Form + GlobalKey): Nama Lengkap, No. HP (validasi wajib isi),Tanggal Kedatangan (showDatePicker), dan jumlah orang (tombol − / +)
Ringkasan total harga live (harga × jumlah orang)
Tombol "Konfirmasi Pesanan" → validasi → Navigator.pop(context, result)→ SnackBar sukses muncul di halaman Detail
5️⃣ Not Found Screen
Tampilan 404 — "Halaman tidak ditemukan"
Dijangkau otomatis oleh route apa pun yang tidak terdaftar (onUnknownRoute)
Tombol kembali ke Home
🧠 Implementasi Navigation & Routing
Konfigurasi MaterialApp
MaterialApp(  initialRoute: AppRoutes.splash,              // route awal (Splash)  routes: {                                    // route statis    AppRoutes.splash: (_) => const SplashScreen(),    AppRoutes.home:   (_) => const HomeScreen(),  },  onGenerateRoute: AppRoutes.onGenerateRoute,  // route dinamis + arguments  onUnknownRoute: (_) => MaterialPageRoute(   // fallback 404    builder: (_) => const NotFoundScreen(),  ),)
Pemetaan API
API / Konsep	Penerapan
initialRoute + routes	Registrasi route statis: / (Splash) dan /home
onGenerateRoute	Route dinamis /detail — ekstraksi arguments (validasi tipe TourPackage)
onUnknownRoute	Route tak dikenal → NotFoundScreen (404)
pushReplacementNamed()	Splash → Home (Splash dibuang dari history)
pushNamed() + arguments	Home → Detail (mengirim objek TourPackage)
pushNamedAndRemoveUntil()	Logout → Splash dengan history dibersihkan (route) => false
Navigator.push() / pop(result)	Detail ↔ Booking dengan membawa hasil booking
PopScope + onPopInvokedWithResult	Intercept back button → dialog konfirmasi
showDialog / showDatePicker	Dialog konfirmasi & pemilih tanggal
SnackBar	Feedback hasil booking sukses
Widget & Konsep Lain
Scaffold, AppBar, Card, ListView.builder, Column, Row,Form + TextFormField (validasi), Image.network + errorBuilder,ClipRRect, ElevatedButton, Chip, setState.

📂 Struktur Proyek
lib/├── main.dart                    # Entry point + konfigurasi routing├── models/│   └── tour_package.dart        # Model TourPackage (id, title, description, price, imageUrl)├── routes/│   └── app_routes.dart          # Konstanta nama route + onGenerateRoute└── screens/    ├── splash_screen.dart    ├── home_screen.dart    ├── detail_screen.dart    ├── booking_screen.dart    └── not_found_screen.dart
⚙️ Cara Menjalankan
# 1. Clone repositorygit clone <url-repo-ini>cd nusa_travel# 2. Install dependency (murni Flutter SDK, tanpa package tambahan)flutter pub get# 3. Jalankan (pilih emulator, device, atau Chrome)flutter run
📶 Catatan: gambar paket wisata dimuat dari internet (picsum.photos),pastikan koneksi aktif agar gambar tampil.

📸 Screenshot
📌 Semua screenshot disimpan di folder screenshots/.

Halaman	Screenshot
Splash Screen — logo & tombol "Mulai Jelajah"	
Home Screen — katalog paket wisata	
Detail Screen — detail paket via arguments	
Booking Screen — form pemesanan	
Dialog PopScope — konfirmasi sebelum back dari Booking	
SnackBar — tampil di Detail setelah booking berhasil	
Not Found Screen — halaman 404	
Dialog Logout — konfirmasi sebelum kembali ke Splash (bonus)	
🔧 Catatan Implementasi
/detail sengaja tidak didaftarkan di routes map — route tersebutmembutuhkan arguments, sehingga hanya bisa diproses lewatonGenerateRoute. Jika didaftarkan di routes, onGenerateRoutetidak akan pernah terpanggil untuk route tersebut.
Validasi arguments di onGenerateRoute: jika arguments bernilainull atau salah tipe, fungsi mengembalikan null sehingga jatuh keonUnknownRoute → halaman 404 (defensive programming).
PopScope menggunakan canPop: false + callbackonPopInvokedWithResult (API Flutter 3.24+) sehingga tombol back diAppBar maupun tombol back sistem Android keduanya ter-intercept dengandialog konfirmasi.
initialRoute diset eksplisit ke Splash — aplikasi selalu dimulaidari Splash meskipun terdapat sisa route sebelumnya.
