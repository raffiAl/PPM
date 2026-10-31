import 'package:flutter/material.dart';

/// Bottom sheet filter kategori untuk Tab Daftar Seminar.
///
/// Dipanggil lewat [FilterBottomSheet.show]; kategori terpilih
/// dikembalikan dengan Navigator.pop(context, kategori).
/// Nilai null berarti sheet ditutup tanpa memilih.
class FilterBottomSheet {
  FilterBottomSheet._(); // kelas utilitas statis, tidak diinstansiasi.

  /// Daftar opsi kategori sesuai urutan soal.
  static const List<String> categories = <String>[
    'Semua',
    'AI',
    'Mobile',
    'IoT',
    'Keamanan Siber',
  ];

  /// Membuka modal bottom sheet dan mengembalikan pilihan pengguna.
  static Future<String?> show(BuildContext context, String currentCategory) {
    return showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 0, 24, 8),
                child: Text(
                  'Filter Kategori',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              ...categories.map(
                (category) => ListTile(
                  leading: _categoryDot(category),
                  title: Text(category),
                  dense: true,
                  trailing: category == currentCategory
                      ? const Icon(Icons.check)
                      : null,
                  onTap: () => Navigator.pop(sheetContext, category),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  /// Titik warna kecil sebagai penanda kategori (senada dengan chip kartu).
  static Widget _categoryDot(String category) {
    final Color color = switch (category) {
      'AI' => Colors.indigo,
      'Mobile' => Colors.green,
      'IoT' => Colors.orange,
      'Keamanan Siber' => Colors.red,
      _ => Colors.blueGrey,
    };
    return Icon(Icons.circle, size: 12, color: color);
  }
}
