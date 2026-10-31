import 'package:flutter/material.dart';

/// Kartu denah venue dengan zoom & pan via InteractiveViewer,
/// dilengkapi tombol reset zoom, petunjuk interaksi, dan legenda area.
class VenueMapViewer extends StatefulWidget {
  const VenueMapViewer({super.key});

  @override
  State<VenueMapViewer> createState() => _VenueMapViewerState();
}

class _VenueMapViewerState extends State<VenueMapViewer> {
  /// Gambar denah venue (contoh 800x500, seed 'denah').
  static const String _mapImageUrl = 'https://picsum.photos/seed/denah/800/500';

  /// Pengontrol transformasi (zoom & posisi) milik InteractiveViewer.
  final TransformationController _transformationController =
      TransformationController();

  /// Mengembalikan denah ke skala dan posisi awal (identitas).
  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- Judul + tombol reset zoom ----------
            Row(
              children: [
                Icon(
                  Icons.map_outlined,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Denah Venue — Main Hall',
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Reset zoom',
                  onPressed: _resetZoom,
                ),
              ],
            ),
            const SizedBox(height: 4),

            // ---------- Denah interaktif ----------
            // ClipRRect menentukan radius pemotongan gambar saat
            // digeser/di-zoom; InteractiveViewer sendiri Clip.none.
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                // Rasio sama dengan gambar denah (800x500) agar
                // tinggi slot deterministik (anti layout error).
                aspectRatio: 800 / 500,
                child: InteractiveViewer(
                  transformationController: _transformationController,
                  clipBehavior: Clip.none,
                  maxScale: 4,
                  minScale: 0.5,
                  boundaryMargin: const EdgeInsets.all(double.infinity),
                  child: Image.network(
                    _mapImageUrl,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey.shade300,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.map_outlined,
                        size: 48,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ---------- Petunjuk interaksi ----------
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.touch_app_outlined,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Cubit untuk zoom, geser untuk melihat detail area',
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: Colors.grey.shade700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ---------- Legenda area venue ----------
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                _LegendChip(
                  label: 'Panggung Utama',
                  icon: Icons.mic_outlined,
                  color: Colors.indigo,
                ),
                _LegendChip(
                  label: 'Area Booth',
                  icon: Icons.storefront_outlined,
                  color: Colors.green,
                ),
                _LegendChip(
                  label: 'Pendaftaran',
                  icon: Icons.how_to_reg_outlined,
                  color: Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Chip kecil untuk legenda area pada denah.
class _LegendChip extends StatelessWidget {
  const _LegendChip({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      avatar: Icon(icon, size: 16, color: color),
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      side: BorderSide.none,
      backgroundColor: Colors.grey.shade100,
      labelStyle: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade800,
      ),
    );
  }
}
