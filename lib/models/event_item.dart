/// Model data seminar/event untuk NusaEvent Hub.
class EventItem {
  final int id;
  final String title;

  /// Salah satu dari: 'AI', 'Mobile', 'IoT', 'Keamanan Siber'.
  final String category;
  final String speaker;

  /// Tanggal dalam format siap tampil, contoh: 'Sabtu, 14 November 2026'.
  final String date;
  final String location;
  final String description;

  /// URL foto cover (landscape 600x400).
  final String imageUrl;

  const EventItem({
    required this.id,
    required this.title,
    required this.category,
    required this.speaker,
    required this.date,
    required this.location,
    required this.description,
    required this.imageUrl,
  });
}