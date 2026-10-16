// Model data buku — class Dart murni, gak butuh import apa-apa.
// id dipakai sebagai "kunci" buat ngebedain buku (anti-duplikat
// pas masuk keranjang).
class Book {
  final int id;
  final String title;
  final String author;
  final int price; // harga dalam rupiah (int, misal 85000)
  final String imageUrl;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.price,
    required this.imageUrl,
  });
}
