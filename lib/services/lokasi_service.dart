import 'dart:async';

import 'package:geolocator/geolocator.dart';

import '../models/lokasi_pengguna.dart';

/// Error lokasi dengan pesan yang siap ditampilkan.
class LokasiException implements Exception {
  const LokasiException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Mengambil lokasi pengguna (tidak memanggil http).
class LokasiService {
  Future<LokasiPengguna> ambilLokasi() async {
    try {
      final aktif = await Geolocator.isLocationServiceEnabled();
      if (!aktif) {
        throw const LokasiException(
          'Layanan lokasi (GPS) sedang mati. Aktifkan lalu coba lagi.',
        );
      }

      var izin = await Geolocator.checkPermission();
      if (izin == LocationPermission.denied) {
        izin = await Geolocator.requestPermission();
      }
      if (izin == LocationPermission.denied) {
        throw const LokasiException(
          'Izin lokasi ditolak. Izinkan akses lokasi agar gempa terdekat '
          'bisa ditampilkan.',
        );
      }
      if (izin == LocationPermission.deniedForever) {
        throw const LokasiException(
          'Izin lokasi diblokir. Aktifkan kembali lewat pengaturan '
          'browser atau aplikasi.',
        );
      }

      final posisi = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 15),
        ),
      );
      return LokasiPengguna(
        latitude: posisi.latitude,
        longitude: posisi.longitude,
      );
    } on LokasiException {
      rethrow;
    } on TimeoutException {
      throw const LokasiException(
        'Gagal mendapatkan lokasi karena terlalu lama. Coba lagi.',
      );
    } catch (_) {
      throw const LokasiException(
        'Lokasi tidak dapat diakses. Periksa izin lokasimu lalu coba lagi.',
      );
    }
  }
}
