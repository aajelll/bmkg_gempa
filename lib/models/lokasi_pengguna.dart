import 'pulau.dart';

/// Lokasi pengguna saat ini beserta pulau tempatnya berada.
class LokasiPengguna {
  LokasiPengguna({required this.latitude, required this.longitude})
      : pulau = Pulau.dariKoordinat(latitude, longitude);

  final double latitude;
  final double longitude;
  final Pulau pulau;
}
