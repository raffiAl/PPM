import 'package:flutter/material.dart';

import '../models/registration_ticket.dart';

/// Layar Tab 3 — Tiket Saya.
/// Menerima daftar tiket + callback hapus dari shell (bukan pemilik state).
/// Di tahap ini masih placeholder; isi interaktif digarap di tahap 5.
class RegisteredTicketsScreen extends StatelessWidget {
  const RegisteredTicketsScreen({
    super.key,
    required this.tickets,
    required this.onRemoveTicket,
  });

  /// Daftar tiket milik shell — berubah saat registrasi/hapus.
  final List<RegistrationTicket> tickets;

  /// Callback dari shell untuk menghapus tiket dari list.
  final void Function(RegistrationTicket ticket) onRemoveTicket;

  // TODO tahap 5: diganti implementasi asli (Dismissible + AlertDialog
  // konfirmasi pembatalan).
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tiket Saya')),
      body: Center(
        child: Text(
          tickets.isEmpty
              ? 'Belum ada tiket terdaftar.\nIkuti seminar dulu di tab Daftar Seminar.'
              : 'Kamu punya ${tickets.length} tiket terdaftar.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
