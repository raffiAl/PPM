import 'package:flutter/material.dart';

import '../models/event_item.dart';

/// Layar Registrasi — di-push dari shell saat seminar dipilih.
/// Di tahap ini masih placeholder; form + validasi digarap di tahap 3.
class EventRegistrationScreen extends StatelessWidget {
  const EventRegistrationScreen({super.key, required this.event});

  /// Event yang sedang didaftarkan (dikirim dari shell).
  final EventItem event;

  // TODO tahap 3: diganti implementasi asli (Form + GlobalKey<FormState>
  // + validasi + showDatePicker + loading 2 detik + ticketCode).
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrasi Tiket')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Form registrasi untuk:',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                event.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              // Tombol dummy: kembali tanpa menghasilkan tiket.
              FilledButton(
                onPressed: () => Navigator.pop(context, null),
                child: const Text('Kembali'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
