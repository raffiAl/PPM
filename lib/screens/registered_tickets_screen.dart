import 'package:flutter/material.dart';

import '../models/registration_ticket.dart';

/// Layar Tab 3 — Tiket Saya.
///
/// StatelessWidget: menerima daftar tiket + callback hapus (berdasarkan
/// id) dari shell — bukan pemilik state. Swipe kiri pada kartu memunculkan
/// dialog konfirmasi lewat confirmDismiss (dipanggil SEBELUM item hilang),
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
  /// Return true = batalkan tiket, false/null = batal menghapus.
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
                    // StatelessWidget → panggil field langsung
                    // (tanpa awalan "widget." — itu hanya untuk State<T>).
                    onRemoveTicket(ticket.id);
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

/// Kartu tiket terdaftar: kode tiket, judul event, nama & NIM,
/// tanggal kunjungan, dan chip kategori.
class _TicketCard extends StatelessWidget {
  const _TicketCard({required this.ticket});

  final RegistrationTicket ticket;

  @override
  Widget build(BuildContext context) {
    final (chipBackground, chipForeground) = _categoryColors(
      ticket.eventCategory,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- Kode tiket ----------
            Row(
              children: [
                Icon(
                  Icons.confirmation_number_outlined,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  ticket.ticketCode,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // ---------- Judul event ----------
            Text(
              ticket.eventTitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // ---------- Nama & NIM ----------
            _TicketInfoRow(
              icon: Icons.person_outline,
              text: '${ticket.name} • NIM ${ticket.nim}',
            ),
            const SizedBox(height: 4),

            // ---------- Tanggal kunjungan ----------
            _TicketInfoRow(
              icon: Icons.calendar_month_outlined,
              text: 'Kunjungan: ${ticket.visitDate}',
            ),
            const SizedBox(height: 10),

            // ---------- Chip kategori ----------
            Chip(
              label: Text(ticket.eventCategory),
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
}

/// Baris info kecil pada kartu tiket (ikon + teks abu, anti overflow).
class _TicketInfoRow extends StatelessWidget {
  const _TicketInfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade600),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: Colors.grey.shade700),
          ),
        ),
      ],
    );
  }
}

/// Warna chip kategori — senada dengan EventCard & layar registrasi.
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
