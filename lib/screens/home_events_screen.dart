import 'package:flutter/material.dart';

import '../models/event_item.dart';
import '../models/registration_ticket.dart';
import 'event_registration_screen.dart';
import 'registered_tickets_screen.dart';

/// Shell utama NusaEvent Hub — pemilik seluruh state aplikasi
/// (tab aktif + daftar tiket) TANPA Provider.
///
/// Pola state:
/// - Tab aktif    : IndexedStack + NavigationBar (state tiap tab terjaga,
///                  tidak dibangun ulang saat berpindah tab).
/// - Tambah tiket : shell push layar registrasi → layar mengembalikan
///                  RegistrationTicket via Navigator.pop(context, result)
///                  → shell setState add + SnackBar.
/// - Hapus tiket  : tab tiket memanggil callback onRemoveTicket dari shell.
class HomeEventsScreen extends StatefulWidget {
  const HomeEventsScreen({super.key});

  @override
  State<HomeEventsScreen> createState() => _HomeEventsScreenState();
}

class _HomeEventsScreenState extends State<HomeEventsScreen> {
  int _selectedIndex = 0;
  final List<RegistrationTicket> _tickets = <RegistrationTicket>[];

  void _onTabTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  /// Dipanggil saat kartu seminar di-tap (dari Tab 1).
  /// Menunggu hasil dari layar registrasi, lalu menambahkan tiket + SnackBar.
  Future<void> _openRegistration(EventItem event) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventRegistrationScreen(event: event),
      ),
    );

    if (result is RegistrationTicket && mounted) {
      setState(() => _tickets.add(result));
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Pendaftaran berhasil')));
    }
  }

  /// Callback hapus tiket dari Tab 3 (shell tetap satu-satunya pemilik list).
  // TODO tahap 5: dipanggil setelah user konfirmasi batal lewat AlertDialog.
  void _removeTicket(RegistrationTicket ticket) {
    setState(() => _tickets.remove(ticket));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // Tab 1 — Daftar Seminar (placeholder, ter-wired ke registrasi).
          _SeminarListTab(onRegister: _openRegistration),
          // Tab 2 — Galeri & Denah (placeholder).
          const _GalleryTab(),
          // Tab 3 — Tiket Saya (placeholder, ter-wired ke list tiket shell).
          RegisteredTicketsScreen(
            tickets: _tickets,
            onRemoveTicket: _removeTicket,
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onTabTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.event),
            label: 'Daftar Seminar',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            label: 'Galeri & Denah',
          ),
          NavigationDestination(
            icon: Icon(Icons.confirmation_number_outlined),
            label: 'Tiket Saya',
          ),
        ],
      ),
    );
  }
}

/// Tab 1 — Daftar Seminar (placeholder).
// TODO tahap 2: diganti implementasi asli (ListView.builder + EventCard
// + filter kategori via showModalBottomSheet).
class _SeminarListTab extends StatelessWidget {
  const _SeminarListTab({required this.onRegister});

  /// Callback ke shell: buka layar registrasi untuk event ini.
  final void Function(EventItem event) onRegister;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Seminar')),
      body: const Center(child: Text('Daftar seminar akan tampil di sini.')),
    );
  }
}

/// Tab 2 — Galeri & Denah (placeholder).
// TODO tahap 4: diganti implementasi asli (GridView.builder galeri
// + InteractiveViewer denah venue).
class _GalleryTab extends StatelessWidget {
  const _GalleryTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Galeri & Denah')),
      body: const Center(
        child: Text('Galeri foto dan denah venue akan tampil di sini.'),
      ),
    );
  }
}
