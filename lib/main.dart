import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'providers/cart_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/cart_screen.dart'; // dipakai CartIconButton (navigasi)
import 'screens/catalog_screen.dart';

void main() {
  runApp(const NusaBookstoreApp());
}

// ============================================================
// ROOT — TIDAK DIUBAH SAMA SEKALI. MultiProvider tetap persis.
// ============================================================
class NusaBookstoreApp extends StatelessWidget {
  const NusaBookstoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const _AppWithTheme(),
    );
  }
}

// ============================================================
// Struktur TIDAK berubah (watch ThemeProvider → themeMode global).
// Cuma nilai ThemeData-nya disandingin ke NeoColors, biar seluruh
// app (termasuk halaman yang belum direstyle) duduk di palette baru.
// ============================================================
class _AppWithTheme extends StatelessWidget {
  const _AppWithTheme();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;

    return MaterialApp(
      title: 'NusaBookstore',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: NeoColors.lightBg,
        colorScheme: ColorScheme.fromSeed(seedColor: NeoColors.kuning),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: NeoColors.darkBg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: NeoColors.kuning,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const CatalogScreen(),
    );
  }
}

// ============================================================
// DESIGN TOKENS — NeoColors
// Light: bg krem, surface putih, ink hitam.
// Dark : bg gelap, surface gelap, ink KREM (efek invert — border &
//        shadow jadi "putih", tetap neobrutalism).
// Aksen: vivid, SAMA di kedua mode.
// ============================================================
class NeoColors {
  // ===== Dasar — LIGHT =====
  static const Color lightBg = Color(0xFFFFF6E5);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightInk = Color(0xFF111111);
  static const Color lightInkSoft = Color(0xFF6E6A5E); // teks sekunder

  // ===== Dasar — DARK =====
  static const Color darkBg = Color(0xFF15151B);
  static const Color darkSurface = Color(0xFF22222B);
  static const Color darkInk = Color(0xFFF4F1EA);
  static const Color darkInkSoft = Color(0xFF9C977F);

  // ===== Aksen vivid — sama di kedua mode =====
  static const Color kuning = Color(0xFFFFD23F);
  static const Color pink = Color(0xFFFF6B9D);
  static const Color mint = Color(0xFFB8F135);
  static const Color lavender = Color(0xFFB8A9FF);
  static const Color cyan = Color(0xFF7CF2D4);
  static const Color oranye = Color(0xFFFF8C42);

  // Daftar aksen — buat sticker/harga bergantian per index
  static const List<Color> accents = [
    kuning,
    pink,
    mint,
    lavender,
    cyan,
    oranye,
  ];

  // Teks di ATAS warna aksen → SELALU gelap.
  // Soalnya semua aksen vivid terang: krem (ink dark mode) di atas
  // kuning itu kontrasnya jelek, tapi hitam di atas kuning aman
  // di DUA mode.
  static const Color onAccent = Color(0xFF111111);

  // ===== Palette hasil resolve per mode =====
  final Color bg;
  final Color surface;
  final Color ink;
  final Color inkSoft;

  const NeoColors._({
    required this.bg,
    required this.surface,
    required this.ink,
    required this.inkSoft,
  });

  // Panggil di build → dapat palette sesuai mode.
  // REAKTIF: ini baca Theme.of(context), jadi begitu themeMode ganti,
  // semua widget yang manggil ini auto rebuild dengan palette baru.
  static NeoColors of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const NeoColors._(
            bg: darkBg,
            surface: darkSurface,
            ink: darkInk,
            inkSoft: darkInkSoft,
          )
        : const NeoColors._(
            bg: lightBg,
            surface: lightSurface,
            ink: lightInk,
            inkSoft: lightInkSoft,
          );
  }
}

// ============================================================
// WIDGET REUSABLE 1 — NeoCard
// Border ink 3 + hard shadow (6,6) tanpa blur + radius 16.
// Kalau ada onTap → efek press: bergeser +4px & shadow menyusut ke 0.
// Pakai Listener (BUKAN GestureDetector) biar gak kalah gesture
// arena — pelajaran yang sama kayak tombol auto-repeat kemarin 😄
// ============================================================
class NeoCard extends StatefulWidget {
  final Color? color; // null → palette.surface
  final Widget child;
  final VoidCallback? onTap; // null → card statis (gak ada efek press)

  const NeoCard({super.key, this.color, required this.child, this.onTap});

  @override
  State<NeoCard> createState() => _NeoCardState();
}

class _NeoCardState extends State<NeoCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final palette = NeoColors.of(context);

    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      transform: Matrix4.translationValues(
        _pressed ? 4 : 0,
        _pressed ? 4 : 0,
        0,
      ),
      decoration: BoxDecoration(
        color: widget.color ?? palette.surface,
        border: Border.all(color: palette.ink, width: 3),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: palette.ink,
            offset: _pressed ? Offset.zero : const Offset(6, 6),
            blurRadius: 0, // HARD shadow — neobrutalism gak pakai blur
          ),
        ],
      ),
      child: widget.child,
    );

    // Gak ada onTap → card statis
    if (widget.onTap == null) return card;

    return Listener(
      onPointerDown: (_) => setState(() => _pressed = true),
      onPointerUp: (_) {
        setState(() => _pressed = false);
        widget.onTap!(); // "klik" = jari dilepas
      },
      onPointerCancel: (_) => setState(() => _pressed = false),
      child: card,
    );
  }
}

// ============================================================
// WIDGET REUSABLE 2 — NeoButton
// Teks bold UPPERCASE + border 3 + hard shadow (4,4) + press effect.
// Center di dalam → otomatis NGISI LEBAR yang tersedia
// (taruh di Column = langsung full-width).
// ============================================================
class NeoButton extends StatefulWidget {
  final String label;
  final Color color;
  final IconData? icon;
  final VoidCallback? onPressed;

  const NeoButton({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    this.onPressed,
  });

  @override
  State<NeoButton> createState() => _NeoButtonState();
}

class _NeoButtonState extends State<NeoButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final palette = NeoColors.of(context);
    final enabled = widget.onPressed != null;

    final button = AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      transform: Matrix4.translationValues(
        _pressed ? 4 : 0,
        _pressed ? 4 : 0,
        0,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: widget.color,
        border: Border.all(color: palette.ink, width: 3),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: palette.ink,
            offset: _pressed ? Offset.zero : const Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.icon != null) ...[
              Icon(widget.icon, size: 20, color: NeoColors.onAccent),
              const SizedBox(width: 8),
            ],
            Text(
              widget.label.toUpperCase(),
              style: GoogleFonts.spaceGrotesk(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: NeoColors.onAccent,
              ),
            ),
          ],
        ),
      ),
    );

    if (!enabled) return Opacity(opacity: 0.5, child: button);

    return Listener(
      onPointerDown: (_) => setState(() => _pressed = true),
      onPointerUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed!();
      },
      onPointerCancel: (_) => setState(() => _pressed = false),
      child: button,
    );
  }
}

// ============================================================
// BONUS KECIL — NeoIconButton (kotak ikon 44x44, border 2,
// shadow 4,4, press effect). Dipakai tombol toggle tema & CartIconButton
// biar gak nulis kode "kotak kuning border ink" dobel dua kali.
// ============================================================
class NeoIconButton extends StatefulWidget {
  final Color color;
  final IconData icon;
  final String? tooltip;
  final VoidCallback? onPressed;

  const NeoIconButton({
    super.key,
    required this.color,
    required this.icon,
    this.tooltip,
    this.onPressed,
  });

  @override
  State<NeoIconButton> createState() => _NeoIconButtonState();
}

class _NeoIconButtonState extends State<NeoIconButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final palette = NeoColors.of(context);

    Widget result = Listener(
      onPointerDown: widget.onPressed != null
          ? (_) => setState(() => _pressed = true)
          : null,
      onPointerUp: widget.onPressed != null
          ? (_) {
              setState(() => _pressed = false);
              widget.onPressed!();
            }
          : null,
      onPointerCancel: widget.onPressed != null
          ? (_) => setState(() => _pressed = false)
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: Matrix4.translationValues(
          _pressed ? 4 : 0,
          _pressed ? 4 : 0,
          0,
        ),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: widget.color,
          border: Border.all(color: palette.ink, width: 2), // kecil → 2
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: palette.ink,
              offset: _pressed ? Offset.zero : const Offset(4, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: Icon(widget.icon, size: 22, color: NeoColors.onAccent),
      ),
    );

    if (widget.tooltip != null) {
      result = Tooltip(message: widget.tooltip!, child: result);
    }
    return result;
  }
}

// ============================================================
// WIDGET REUSABLE 3 — CartIconButton (RESTYLE neobrutalism)
// PINDAHAN dari cart_screen.dart → jadi bagian design system.
// Persegi kuning border ink + badge pink border ink.
// Aturan lama TETAP: context.watch buat badge, hilang kalau 0,
// klik → Navigator.push ke CartScreen.
// ============================================================
class CartIconButton extends StatelessWidget {
  const CartIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = NeoColors.of(context);

    // WATCH (tampilan) — badge real-time, aturan gak berubah
    final totalItems = context.watch<CartProvider>().totalItems;

    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Stack(
        // Clip.none biar badge boleh nongol dikit keluar batas tombol
        clipBehavior: Clip.none,
        children: [
          NeoIconButton(
            color: NeoColors.kuning,
            icon: Icons.shopping_cart,
            tooltip: 'Keranjang',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),

          // Badge pink — cuma muncul kalau totalItems > 0
          if (totalItems > 0)
            Positioned(
              top: -6,
              right: -6,
              child: IgnorePointer(
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: NeoColors.pink,
                    // borderRadius (bukan shape.circle) biar pas angkanya
                    // 2 digit bentuknya jadi kapsul, bukan ke-overflow
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: palette.ink, width: 2),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  child: Center(
                    child: Text(
                      '$totalItems',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: NeoColors.onAccent,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ============================================================
// HELPER GLOBAL — SnackBar style neobrutalism.
// Satu gaya untuk SEMUA halaman: bg ink + teks warna bg (efek
// invert, aman di 2 mode) + floating + radius 12.
// Dipakai: Katalog (tambah keranjang) & Keranjang (checkout).
// ============================================================
void showNeoSnackBar(BuildContext context, String message) {
  final palette = NeoColors.of(context);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: GoogleFonts.spaceGrotesk(
          color: palette.bg,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: palette.ink,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 2),
    ),
  );
}
