import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/gempa.dart';

/// Error dengan pesan yang siap ditampilkan ke pengguna.
class GempaException implements Exception {
  const GempaException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Satu-satunya tempat yang memanggil package http.
class GempaService {
  GempaService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const String _base = 'https://data.bmkg.go.id/DataMKG/TEWS';

  /// Mengambil gempa terkini, M5+, dan gempa dirasakan, lalu menggabungkannya
  /// (tanpa duplikat) dan mengurutkan dari yang terbaru.
  Future<List<Gempa>> ambilSemua() async {
    String? pesanError;

    Future<List<Gempa>> aman(Future<List<Gempa>> permintaan) async {
      try {
        return await permintaan;
      } on GempaException catch (e) {
        pesanError ??= e.message;
        return const <Gempa>[];
      }
    }

    final hasil = await Future.wait([
      aman(_ambil('autogempa.json')),
      aman(_ambil('gempaterkini.json')),
      aman(_ambil('gempadirasakan.json')),
    ]);

    final unik = <String, Gempa>{};
    for (final daftar in hasil) {
      for (final g in daftar) {
        final kunci = '${g.waktu.millisecondsSinceEpoch}';
        final lama = unik[kunci];
        if (lama == null || (lama.dirasakan.isEmpty && g.dirasakan.isNotEmpty)) {
          unik[kunci] = g;
        }
      }
    }

    if (unik.isEmpty) {
      throw GempaException(
        pesanError ?? 'Data gempa dari BMKG kosong. Silakan coba lagi.',
      );
    }

    final daftar = unik.values.toList()
      ..sort((a, b) => b.waktu.compareTo(a.waktu));
    return daftar;
  }

  Future<List<Gempa>> _ambil(String file) async {
    try {
      final response = await _client
          .get(Uri.parse('$_base/$file'))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw GempaException(
          'Server BMKG merespons dengan kode ${response.statusCode}. '
          'Silakan coba lagi beberapa saat lagi.',
        );
      }

      final decoded = jsonDecode(response.body);
      final info = decoded is Map<String, dynamic> ? decoded['Infogempa'] : null;
      final gempa = info is Map<String, dynamic> ? info['gempa'] : null;
      final items = gempa is List ? gempa : [gempa];

      final hasil = <Gempa>[];
      for (final item in items) {
        if (item is Map<String, dynamic>) {
          hasil.add(Gempa.fromJson(item));
        }
      }
      if (hasil.isEmpty) {
        throw const GempaException(
          'Format data dari BMKG tidak sesuai yang diharapkan.',
        );
      }
      return hasil;
    } on TimeoutException {
      throw const GempaException(
        'Koneksi terlalu lama. Periksa jaringan internetmu lalu coba lagi.',
      );
    } on SocketException {
      throw const GempaException(
        'Tidak ada koneksi internet. Periksa jaringanmu lalu coba lagi.',
      );
    } on http.ClientException {
      throw const GempaException(
        'Gagal terhubung ke server BMKG. Coba lagi nanti.',
      );
    } on FormatException {
      throw const GempaException('Data dari BMKG tidak dapat dibaca.');
    }
  }

  void dispose() => _client.close();
}
