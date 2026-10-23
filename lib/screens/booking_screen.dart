import 'package:flutter/material.dart';

import '../models/tour_package.dart';
import 'home_screen.dart'; // formatRupiah

// ============================================================
// BOOKING — form pemesanan.
// Syarat tugas: PopScope — back (AppBar ATAU system) kena
// dialog konfirmasi dulu, gak boleh langsung keluar.
//
// StatefulWidget karena ada state: jumlah orang + validasi form.
// ============================================================
class BookingScreen extends StatefulWidget {
  final TourPackage package;

  const BookingScreen({super.key, required this.package});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _hpController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();

  int _jumlahOrang = 1;

  @override
  void dispose() {
    _namaController.dispose();
    _hpController.dispose();
    _tanggalController.dispose();
    super.dispose();
  }

  // ---------- Dialog konfirmasi sebelum back (syarat PopScope) ----------
  void _tanyaBatal() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Batalkan pemesanan?'),
        content: const Text('Data yang sudah kamu isi akan hilang.'),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext), // Batal → tutup dialog
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext); // tutup dialog
              Navigator.pop(context); // ← beneran keluar dari Booking
            },
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );
  }

  // ---------- Submit form ----------
  void _konfirmasiPesanan() {
    // Validasi semua TextFormField.
    // Kalau ada yang gak lolos, Form auto nampilin error text.
    if (_formKey.currentState!.validate()) {
      // Lolos validasi → pop DENGAN RESULT (string sukses).
      // Result ini yang ditangkap await Navigator.push di DetailScreen
      Navigator.pop(context, 'Pemesanan ${widget.package.title} berhasil!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final paket = widget.package;

    return PopScope(
      // canPop: false → back DIBLOKIR. Flutter kasih tau lewat
      // callback dengan didPop = false, dan KITA yang tentuin
      // apa yang terjadi (tampil dialog dulu).
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        // didPop = true berarti pop udah terjadi (gak relevan di sini,
        // karena canPop false). Ini jalan tiap ada percobaan back:
        // back AppBar maupun tombol system back.
        if (!didPop) {
          _tanyaBatal(); // tampil dialog konfirmasi
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Pemesanan')),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== Ringkasan paket (live) =====
                Card(
                  color: colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          paket.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${formatRupiah(paket.price)} / orang',
                          style: TextStyle(
                            fontSize: 14,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ===== Form fields =====
                TextFormField(
                  controller: _namaController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Lengkap',
                    hintText: 'Masukkan nama lengkap',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _hpController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'No. HP',
                    hintText: 'Masukkan nomor HP',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'No. HP wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // BONUS: readOnly + tap → showDatePicker
                TextFormField(
                  controller: _tanggalController,
                  readOnly: true, // gak bisa diketik manual
                  decoration: const InputDecoration(
                    labelText: 'Tanggal Kedatangan',
                    hintText: 'Pilih tanggal',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_month),
                  ),
                  onTap: () async {
                    final dipilih = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().add(const Duration(days: 1)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (dipilih != null) {
                      _tanggalController.text =
                          '${dipilih.day}/${dipilih.month}/${dipilih.year}';
                    }
                  },
                ),
                const SizedBox(height: 20),

                // ===== Jumlah orang (− / +) =====
                Text(
                  'Jumlah Orang',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      onPressed: _jumlahOrang > 1
                          ? () => setState(() => _jumlahOrang--)
                          : null, // disabled pas mentok 1
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    SizedBox(
                      width: 56,
                      child: Center(
                        child: Text(
                          '$_jumlahOrang',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() => _jumlahOrang++),
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // ===== Ringkasan total (live, ikut jumlah orang) =====
                Card(
                  color: colorScheme.secondaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          // harga × jumlah orang — auto-update via setState
                          formatRupiah(paket.price * _jumlahOrang),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ===== Tombol konfirmasi =====
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _konfirmasiPesanan,
                    icon: const Icon(Icons.check_circle),
                    label: const Text(
                      'Konfirmasi Pesanan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
