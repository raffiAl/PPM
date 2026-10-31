import 'package:flutter/material.dart';

import '../models/registration_ticket.dart';

/// Layar Tab 3 — Tiket Saya.
///
/// Menerima daftar tiket + callback hapus (berdasarkan id) dari shell —
/// bukan pemilik state. Swipe kiri pada kartu memunculkan dialog
/// konfirmasi lewat confirmDismiss (dipanggil SEBELUM item hilang),
/// lalu shell menghapus tiket lewat onRemoveTicket + SnackBar feedback.
class RegisteredTicketsScreen extends StatelessWidget {
  const RegisteredTicketsScreen({
    super.key,
    required this.tickets,
    required this.onRemoveTicket,
  });

  /// Daftar tiket milik shell — berubah saat registrasi/hapus.
  final List<RegistrationTicket> tickets;

  /// Callback dari shell: hapus tiket dengan id ini dari list.
  final void Function(int ticketId) onRemoveTicket;

  /// Dialog konfirmasi pembatalan.
  ///
  /// WAJIB dipanggil dari confirmDismiss (bukan onDismissed) supaya
  /// keputusan user dijawab SEBELUM item dihapus dari layar.
  /// Return true = batalkan tiket, false = batal menghapus.
  Future<bool?> _confirmCancel(
    BuildContext context,
    RegistrationTicket ticket,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Batalkan pendaftaran?'),
        content: Text(
          'Pendaftaran Anda untuk seminar berikut akan dihapus:\n\n'
          '${ticket.eventTitle}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tiket Saya (${tickets.length})')),
      body: tickets.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.confirmation_number_outlined,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada tiket terdaftar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Yuk daftar seminar di tab Daftar Seminar',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                final RegistrationTicket ticket = tickets[index];
                return Dismissible(
                  key: ValueKey<int>(ticket.id),
                  // Hanya swipe dari kanan ke kiri.
                  direction: DismissDirection.endToStart,
                  // Background merah rounded + ikon hapus di kanan
                  // (margin & radius menyamai kartu tiket).
                  background: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: Colors.red.shade700,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  // Konfirmasi SEBELUM item hilang (anti bug klasik).
                  confirmDismiss: (direction) =>
                      _confirmCancel(context, ticket),
                  onDismissed: (direction) {
                    // Shell yang menghapus tiket dari list.
                    widget.onRemoveTicket(ticket.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pendaftaran dibatalkan')),
                    );
                  },
                  child: _TicketCard(ticket: ticket),
                );
              },
            ),
    );
  }
}

/// Kartu tiket ter
