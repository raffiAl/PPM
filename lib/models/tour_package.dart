// Model paket wisata — class Dart murni.
// Nanti dikirim ke DetailScreen lewat arguments (pushNamed)
// dan ke BookingScreen lewat constructor (Navigator.push langsung).
class TourPackage {
  final int id;
  final String title;
  final String description;
  final int price; // harga dalam rupiah (int, misal 1500000)
  final String imageUrl;

  const TourPackage({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
  });
}
