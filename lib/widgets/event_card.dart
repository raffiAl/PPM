import 'package:flutter/material.dart';

import '../models/event_item.dart';

/// Kartu item seminar untuk Tab Daftar Seminar.
///
/// Layout: Card + InkWell (efek ripple) → Row [gambar | kolom info].
/// Semua teks dibungkus Expanded agar aman dari overflow di layar sempit.
class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.event, required this.onTap});

  final EventItem event;

  /// Callback ketika kartu di-tap (membuka layar registrasi).
  final VoidCallback onTap;

  /// Warna chip kategori: (background lembut, teks gelap).
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

  @override
  Widget build(BuildContext context) {
    final (chipBackground, chipForeground) = _categoryColors(event.category);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Gambar cover (fallback abu-abu bila gagal dimuat) ---
              SizedBox(
                width: 96,
                height: 96,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    event.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey.shade300,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.broken_image_outlined,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // --- Kolom info ---
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Judul: bold, 1 baris, ellipsis.
                    Text(
                      event.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    _InfoRow(icon: Icons.person_outline, text: event.speaker),
                    const SizedBox(height: 2),
                    _InfoRow(icon: Icons.event_outlined, text: event.date),
                    const SizedBox(height: 2),
                    _InfoRow(icon: Icons.place_outlined, text: event.location),
                    const SizedBox(height: 8),
                    // Chip kategori — warna berbeda per kategori.
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Chip(
                        label: Text(event.category),
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Baris info kecil (ikon + teks abu-abu, ellipsis bila kepanjangan).
class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade600),
        const SizedBox(width: 4),
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
