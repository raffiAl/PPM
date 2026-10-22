import 'package:flutter/material.dart';

import '../models/tour_package.dart';

// PLACEHOLDER — diisi tahap 2.
// Konstruktor udah nerima TourPackage dari awal, karena halaman ini
// dipanggil dari onGenerateRoute: DetailScreen(package: args).
class DetailScreen extends StatelessWidget {
  final TourPackage package;

  const DetailScreen({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(package.title)),
      body: Center(
        child: Text('Detail: ${package.title} — diisi tahap berikutnya'),
      ),
    );
  }
}
