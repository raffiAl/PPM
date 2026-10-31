import 'package:flutter/material.dart';

import '../data/sample_events.dart';
import '../models/event_item.dart';
import '../models/registration_ticket.dart';
import '../widgets/event_card.dart';
import '../widgets/filter_bottom_sheet.dart';
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
  /// Menunggu hasil dari layar registrasi: jika ada tiket yang kembali,
  /// tambahkan ke list + SnackBar hijau dengan aksi "Lihat" yang
  /// langsung melompat ke tab Tiket Saya.
  Future<void> _openRegistration(EventItem event) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventRegistrationScreen(event: event),
      ),
    );

    if (result is RegistrationTicket && mounted) {
      setState(() => _tickets.add(result));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 5),
          content: Text(
            'Pendaftaran berhasil! Kode tiket: ${result.ticketCode}',
            style: const TextStyle(color: Colors.white),
          ),
          action: SnackBarAction(
            label: 'Lihat',
            textColor: Colors.white,
            onPressed: () {
              if (mounted) setState(() => _selectedIndex = 2);
            },
          ),
        ),
      );
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
          // Tab 1 — Daftar Seminar (list + filter kategori).
          _SeminarListTab(onRegister: _openRegistration),
          // Tab 2 — Galeri & Denah (placeholder).
          const _GalleryTab(),
          // Tab 3 — Tiket Saya (placeholder, ter-wiring ke list tiket shell).
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

/// Tab 1 — Daftar Seminar.
///
/// StatefulWidget sendiri agar filter kategori tersimpan selama tab hidup
/// di dalam IndexedStack (tidak reset saat berpindah tab).
class _SeminarListTab extends StatefulWidget {
  const _SeminarListTab({required this.onRegister});

  /// Callback ke shell: buka layar registrasi untuk event ini.
  final void Function(EventItem event) onRegister;

  @override
  State<_SeminarListTab> createState() => _SeminarListTabState();
}

class _SeminarListTabState extends State<_SeminarListTab> {
  /// Kategori aktif; 'Semua' berarti tanpa filter.
  String _selectedCategory = 'Semua';

  /// Buka bottom sheet filter, lalu terapkan hasilnya.
  Future<void> _openFilter() async {
    final result = await FilterBottomSheet.show(context, _selectedCategory);

    if (result != null && result != _selectedCategory && mounted) {
      setState(() => _selectedCategory = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<EventItem> filteredEvents = sampleEvents
        .where(
          (event) =>
              _selectedCategory == 'Semua' ||
              event.category == _selectedCategory,
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Seminar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: 'Filter Kategori',
            onPressed: _openFilter,
          ),
        ],
      ),
      body: filteredEvents.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 72, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  Text(
                    'Tidak ada seminar di kategori ini',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
              itemCount: filteredEvents.length,
              itemBuilder: (context, index) {
                final event = filteredEvents[index];
                return EventCard(
                  event: event,
                  onTap: () => widget.onRegister(event),
                );
              },
            ),
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
