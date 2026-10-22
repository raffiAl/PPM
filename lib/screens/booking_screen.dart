import 'package:flutter/material.dart';

import '../models/tour_package.dart';

// PLACEHOLDER — diisi tahap 3:
// form pemesanan + PopScope (dialog konfirmasi sebelum back)
// + pop dengan result.
class BookingScreen extends StatelessWidget {
  final TourPackage package;

  const BookingScreen({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pemesanan')),
      body: Center(
        child: Text('Booking: ${package.title} — diisi tahap berikutnya'),
      ),
    );
  }
}
