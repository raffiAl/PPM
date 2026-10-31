import 'package:flutter/material.dart';

import 'screens/home_events_screen.dart';

void main() {
  runApp(const NusaEventHubApp());
}

/// Root aplikasi NusaEvent Hub — event/seminar hub.
class NusaEventHubApp extends StatelessWidget {
  const NusaEventHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NusaEvent Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const HomeEventsScreen(),
    );
  }
}
