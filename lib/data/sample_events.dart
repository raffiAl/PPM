import '../models/event_item.dart';

/// Data contoh 8 seminar — 2 per kategori (AI, Mobile, IoT, Keamanan Siber).
/// Foto cover memakai picsum.photos dengan id berbeda-beda (600x400 landscape).
const List<EventItem> sampleEvents = <EventItem>[
  // ================= Kategori: AI =================
  EventItem(
    id: 1,
    title: 'Generative AI untuk Industri Kreatif Indonesia',
    category: 'AI',
    speaker: 'Dr. Anindya Prameswari, M.Kom. (AI Research Lead, BINUS AI Lab)',
    date: 'Sabtu, 14 November 2026',
    location: 'Balai Kartini, Jakarta',
    description:
        'Membedah tren generative AI dan bagaimana kreator Indonesia '
        'memanfaatkannya untuk produksi konten — dari copywriting hingga '
        'visual asset — lengkap dengan studi kasus dan demo live.',
    imageUrl: 'https://picsum.photos/id/1/600/400',
  ),
  EventItem(
    id: 2,
    title: 'Machine Learning Terapan di Layanan Keuangan Digital',
    category: 'AI',
    speaker: 'Ir. Bambang Wirawan, M.Sc. (Head of Data Science, Fintech)',
    date: 'Kamis, 3 Desember 2026',
    location: 'ITB Convention Center, Bandung',
    description:
        'Sesi praktis membangun model machine learning untuk deteksi fraud '
        'pada layanan keuangan digital: dari persiapan data, pelatihan model, '
        'hingga deployment ke lingkungan produksi.',
    imageUrl: 'https://picsum.photos/id/2/600/400',
  ),

  // ================= Kategori: Mobile =================
  EventItem(
    id: 3,
    title: 'Flutter di Skala Produksi: Studi Kasus 10 Juta Pengguna',
    category: 'Mobile',
    speaker: 'Rizky Ramadhan (Google Developer Expert, Flutter)',
    date: 'Sabtu, 21 November 2026',
    location: 'Sabuga, Bandung',
    description:
        'Belajar dari tim yang mengelola aplikasi Flutter dengan 10 juta+ '
        'pengguna aktif: arsitektur modular, optimasi performa, CI/CD, dan '
        'strategi testing yang terbukti di lapangan.',
    imageUrl: 'https://picsum.photos/id/3/600/400',
  ),
  EventItem(
    id: 4,
    title: 'Android Modern: Clean Architecture dengan Jetpack Compose',
    category: 'Mobile',
    speaker: 'Dewi Anggraini, M.Eng. (Lead Android Engineer)',
    date: 'Jumat, 4 Desember 2026',
    location: 'Auditorium Universitas Indonesia, Depok',
    description:
        'Panduan menerapkan Clean Architecture di aplikasi Android modern '
        'dengan Jetpack Compose, termasuk pemisahan layer, dependency '
        'injection, dan praktik unit testing.',
    imageUrl: 'https://picsum.photos/id/4/600/400',
  ),

  // ================= Kategori: IoT =================
  EventItem(
    id: 5,
    title: 'Smart City Indonesia: Jaringan Sensor untuk Kota Pintar',
    category: 'IoT',
    speaker:
        'Prof. Dr. Ir. Suryanto Mahmud, M.Sc. (Guru Besar Teknik Elektro ITS)',
    date: 'Rabu, 25 November 2026',
    location: 'Balai Pemuda, Surabaya',
    description:
        'Mengupas implementasi jaringan sensor untuk kota pintar di Indonesia: '
        'teknologi LPWAN, pemantauan kualitas udara dan lalu lintas, hingga '
        'pengelolaan data realtime dalam skala kota.',
    imageUrl: 'https://picsum.photos/id/5/600/400',
  ),
  EventItem(
    id: 6,
    title: 'IoT untuk Pertanian Presisi: dari Sensor hingga Panen',
    category: 'IoT',
    speaker: 'Andi Kurniawan, S.T. (IoT Solutions Architect)',
    date: 'Sabtu, 28 November 2026',
    location: 'Grha Sabha Pramana UGM, Yogyakarta',
    description:
        'Workshop membangun sistem pertanian presisi berbasis IoT: sensor '
        'kelembaban tanah, otomasi irigasi, dan dashboard monitoring yang '
        'terjangkau untuk petani kecil.',
    imageUrl: 'https://picsum.photos/id/6/600/400',
  ),

  // ================= Kategori: Keamanan Siber =================
  EventItem(
    id: 7,
    title: 'Ethical Hacking 101: Meretas dengan Izin',
    category: 'Keamanan Siber',
    speaker: 'Hendra Gunawan, OSCP (Senior Penetration Tester)',
    date: 'Sabtu, 5 Desember 2026',
    location: 'Auditorium Driyarkara, Jakarta',
    description:
        'Pengenalan dunia ethical hacking: pola pikir attacker, metodologi '
        'penetration testing, dan demo lab mencari celah keamanan di '
        'lingkungan yang legal dan terkontrol.',
    imageUrl: 'https://picsum.photos/id/7/600/400',
  ),
  EventItem(
    id: 8,
    title: 'Mengamankan Aplikasi Web: Praktik OWASP Top 10',
    category: 'Keamanan Siber',
    speaker: 'Maya Safitri, CISSP (Security Architect)',
    date: 'Selasa, 8 Desember 2026',
    location: 'Indonesia Convention Exhibition (ICE), Tangerang',
    description:
        'Membedah OWASP Top 10 lewat contoh kerentanan nyata pada aplikasi '
        'web, dilengkapi checklist praktis mengamankan aplikasi sebelum '
        'dirilis ke publik.',
    imageUrl: 'https://picsum.photos/id/8/600/400',
  ),
];
