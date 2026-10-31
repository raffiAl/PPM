/// Model tiket hasil registrasi peserta.
class RegistrationTicket {
  final int id;
  final String eventTitle;
  final String eventCategory;
  final String name;
  final String nim;
  final String email;
  final String whatsapp;

  /// Tanggal kunjungan (hasil showDatePicker), disimpan sebagai String.
  final String visitDate;

  /// Kode unik tiket, contoh: 'NEH-A15-20261114'.
  final String ticketCode;

  const RegistrationTicket({
    required this.id,
    required this.eventTitle,
    required this.eventCategory,
    required this.name,
    required this.nim,
    required this.email,
    required this.whatsapp,
    required this.visitDate,
    required this.ticketCode,
  });
}
