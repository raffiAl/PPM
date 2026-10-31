import 'dart:math';

import 'package:flutter/material.dart';

import '../models/event_item.dart';
import '../models/registration_ticket.dart';

/// Layar Registrasi Tiket — di-push dari shell saat kartu seminar di-tap.
///
/// Form + GlobalKey<FormState> berisi validasi Nama, NIM, Email, dan
/// No. WhatsApp. Tanggal Kunjungan dipilih lewat showDatePicker (tanpa
/// package intl — format tanggal manual Indonesia). Saat submit valid:
/// indikator loading 2 detik (simulasi proses server), lalu tiket
/// dikembalikan ke shell lewat Navigator.pop(context, ticket).
class EventRegistrationScreen extends StatefulWidget {
  const EventRegistrationScreen({super.key, required this.event});

  /// Event yang didaftarkan (dikirim dari shell).
  final EventItem event;

  @override
  State<EventRegistrationScreen> createState() =>
      _EventRegistrationScreenState();
}

class _EventRegistrationScreenState extends State<EventRegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();
  final TextEditingController _visitDateController = TextEditingController();

  /// Tanggal kunjungan hasil showDatePicker (null = belum dipilih).
  DateTime? _visitDate;

  /// Pesan error field tanggal — divalidasi manual di _submit()
  /// supaya submit kosong memunculkan tepat 4 pesan error (sesuai
  /// validasi Nama, NIM, Email, WhatsApp).
  String? _visitDateError;

  /// True saat "proses server" berjalan — tombol disabled + spinner.
  bool _isLoading = false;

  /// Nama bulan Indonesia (format tanggal TANPA package intl).
  static const List<String> _monthNamesIndonesia = <String>[
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  String _formatDateIndonesia(DateTime date) =>
      '${date.day} ${_monthNamesIndonesia[date.month - 1]} ${date.year}';

  /// Membuka date picker: hari ini s/d +1 tahun.
  Future<void> _pickVisitDate() async {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _visitDate ?? today,
      firstDate: today,
      lastDate: today.add(const Duration(days: 365)),
      helpText: 'Pilih Tanggal Kunjungan',
      cancelText: 'Batal',
      confirmText: 'Pilih',
    );

    if (picked == null || !mounted) return;

    setState(() {
      _visitDate = picked;
      _visitDateController.text = _formatDateIndonesia(picked);
      _visitDateError = null;
    });
  }

  /// Proses submit: validasi → loading 2 detik → kembalikan tiket ke shell.
  Future<void> _submit() async {
    // Tutup keyboard dulu supaya pesan error tidak tertutup.
    FocusScope.of(context).unfocus();

    // Validasi 4 field teks (Nama, NIM, Email, No. WhatsApp).
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    // Tanggal dicek terpisah — jangan sampai tiket lahir tanpa tanggal.
    if (_visitDate == null) {
      setState(() => _visitDateError = 'Pilih tanggal kunjungan dulu');
      return;
    }

    setState(() => _isLoading = true);

    // Simulasi proses server selama 2 detik.
    await Future.delayed(const Duration(seconds: 2));

    // WAJIB: layar bisa saja sudah tidak ada saat await selesai
    // (user menekan tombol back saat loading).
    if (!mounted) return;

    final Random random = Random();
    final RegistrationTicket ticket = RegistrationTicket(
      id: DateTime.now().millisecondsSinceEpoch,
      eventTitle: widget.event.title,
      eventCategory: widget.event.category,
      name: _nameController.text.trim(),
      nim: _nimController.text.trim(),
      email: _emailController.text.trim(),
      whatsapp: _whatsappController.text.trim(),
      visitDate: _formatDateIndonesia(_visitDate!),
      // 'NEH-' + 4 digit acak (1000-9999).
      ticketCode: 'NEH-${1000 + random.nextInt(9000)}',
    );

    // Kirim tiket kembali ke shell — shell yang menambahkannya ke list.
    Navigator.pop(context, ticket);
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: const OutlineInputBorder(),
    );
  }

  /// Kartu ringkasan event yang didaftarkan (di atas form).
  Widget _buildEventSummaryCard() {
    final (chipBackground, chipForeground) = _categoryColors(
      widget.event.category,
    );

    return Card(
      margin: EdgeInsets.zero,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.event.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.event_outlined,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    widget.event.date,
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: Colors.grey.shade700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.place_outlined,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    widget.event.location,
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: Colors.grey.shade700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Chip(
              label: Text(widget.event.category),
              backgroundColor: chipBackground,
              labelStyle: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: chipForeground,
              ),
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              side: BorderSide.none,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nimController.dispose();
    _emailController.dispose();
    _whatsappController.dispose();
    _visitDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrasi Tiket')),
      // Form dibungkus ListView + padding: field bisa discroll dan
      // tidak tertutup keyboard di layar sempit.
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            _buildEventSummaryCard(),
            const SizedBox(height: 16),

            // ---------- 1. Nama Lengkap ----------
            TextFormField(
              controller: _nameController,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              decoration: _inputDecoration(
                label: 'Nama Lengkap',
                icon: Icons.person_outline,
              ),
              validator: (value) {
                final String text = value?.trim() ?? '';
                if (text.isEmpty) return 'Nama wajib diisi';
                if (text.length < 3) return 'Nama minimal 3 karakter';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // ---------- 2. NIM ----------
            TextFormField(
              controller: _nimController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              decoration: _inputDecoration(
                label: 'NIM',
                icon: Icons.badge_outlined,
              ),
              validator: (value) {
                final String text = value ?? '';
                if (text.isEmpty) return 'NIM wajib diisi';
                if (!RegExp(r'^\d+$').hasMatch(text)) {
                  return 'NIM hanya boleh berisi angka';
                }
                if (text.length < 8 || text.length > 13) {
                  return 'NIM harus 8-13 digit';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // ---------- 3. Email ----------
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: _inputDecoration(
                label: 'Email',
                icon: Icons.alternate_email,
              ),
              validator: (value) {
                final String text = value?.trim() ?? '';
                if (text.isEmpty) return 'Email wajib diisi';
                final bool valid = RegExp(
                  r'^[\w\-.]+@([\w\-]+\.)+[a-zA-Z]{2,}$',
                ).hasMatch(text);
                if (!valid) return 'Format email tidak valid';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // ---------- 4. No. WhatsApp ----------
            TextFormField(
              controller: _whatsappController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              decoration: _inputDecoration(
                label: 'No. WhatsApp',
                icon: Icons.phone_outlined,
              ),
              validator: (value) {
                final String text = value?.trim() ?? '';
                if (text.isEmpty) return 'No. WhatsApp wajib diisi';
                if (!RegExp(r'^\d+$').hasMatch(text)) {
                  return 'Nomor hanya boleh berisi angka';
                }
                if (!text.startsWith('08')) {
                  return 'Nomor harus diawali 08';
                }
                if (text.length < 10 || text.length > 13) {
                  return 'Total digit harus 10-13';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // ---------- 5. Tanggal Kunjungan ----------
            TextFormField(
              controller: _visitDateController,
              readOnly: true,
              onTap: _pickVisitDate,
              decoration: InputDecoration(
                labelText: 'Tanggal Kunjungan',
                hintText: 'Pilih tanggal kunjungan',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_month),
                  tooltip: 'Pilih tanggal kunjungan',
                  onPressed: _pickVisitDate,
                ),
                border: const OutlineInputBorder(),
                errorText: _visitDateError,
              ),
            ),
            const SizedBox(height: 24),

            // ---------- Tombol Submit ----------
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isLoading ? null : _submit,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Daftar Sekarang',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
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

/// Warna chip kategori — senada dengan EventCard di Tab Daftar Seminar.
(Color, Color) _categoryColors(String category) {
  switch (category) {
    case 'AI':
      return (Colors.indigo.shade100, Colors.indigo.shade800);
    case 'Mobile':
      return (Colors.green.shade100, Colors.green.shade800);
    case 'IoT':
      return (Colors.orange.shade100, Colors.orange.shade900);
    case 'Keamanan Siber':
      return (Colors.red.shade100, Colors.red.shade800);
    default:
      return (Colors.blueGrey.shade100, Colors.blueGrey.shade800);
  }
}
