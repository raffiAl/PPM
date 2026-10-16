import 'package:flutter/foundation.dart'; // buat ChangeNotifier

// State tema GLOBAL (Light/Dark).
// Alur kerjanya: toggleTheme() dipanggil dari UI → notifyListeners() →
// widget yang nge-watch (di main.dart) rebuild → MaterialApp ganti
// themeMode → seluruh aplikasi ikut berubah tema.
class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false; // default: Light mode

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners(); // WAJIB — tanpa ini tema gak bakal pernah berubah
  }
}
