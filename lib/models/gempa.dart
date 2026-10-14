import 'dart:math';

import 'pulau.dart';
import 'status_gempa.dart';

/// Satu kejadian gempa dari BMKG. Seluruh field bersifat immutable.
class Gempa {
  const Gempa({
    required this.tanggal,
    required this.jam,
    required this.dateTime,
    required this.latitude,
    required this.longitude,
    required this.lintang,
    required this.bujur,
    required this.magnitude,
    required this.kedalaman,
    required this.wilayah,
    required this.potensi,
    required this.dirasakan,
    required this.pulau,
  });

  /// Membuat [Gempa] dari satu objek gempa milik BMKG.
  factory Gempa.fromJson(Map<String, dynamic> json) {
    final koordinat = _asString(json['Coordinates']).split(',');
    final lat =
        koordinat.length == 2 ? double.tryParse(koordinat[0].trim()) : null;
    final lon =
        koordinat.length == 2 ? double.tryParse(koordinat[1].trim()) : null;

    return Gempa(
      tanggal: _asString(json['Tanggal']),
      jam: _asString(json['Jam']),
      dateTime: DateTime.tryParse(_asString(json['DateTime'])),
      latitude: lat ?? 0,
      longitude: lon ?? 0,
      lintang: _asString(json['Lintang']),
      bujur: _asString(json['Bujur']),
      magnitude: double.tryParse(_asString(json['Magnitude'])) ?? 0,
      kedalaman: _asString(json['Kedalaman']),
      wilayah: _asString(json['Wilayah']),
      potensi: _asString(json['Potensi']),
      dirasakan: _asString(json['Dirasakan']),
      pulau: Pulau.dariKoordinat(lat ?? 0, lon ?? 0),
    );
  }

  final String tanggal;
  final String jam;
  final DateTime? dateTime;
  final double latitude;
  final double longitude;
  final String lintang;
  final String bujur;
  final double magnitude;
  final String kedalaman;
  final String wilayah;
  final String potensi;
  final String dirasakan;
  final Pulau pulau;

  StatusGempa get status => StatusGempa.dariMagnitudo(magnitude);

  /// Waktu kejadian untuk keperluan pengurutan.
  DateTime get waktu => dateTime ?? DateTime.fromMillisecondsSinceEpoch(0);

  bool get berpotensiTsunami {
    final teks = potensi.toLowerCase();
    return teks.contains('tsunami') && !teks.contains('tidak');
  }

  /// Jarak (km) dari titik [lat],[lon] ke pusat gempa (rumus haversine).
  double jarakKm(double lat, double lon) {
    const radiusBumi = 6371.0;
    final dLat = _radian(lat - latitude);
    final dLon = _radian(lon - longitude);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_radian(latitude)) *
            cos(_radian(lat)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    return 2 * radiusBumi * asin(sqrt(a));
  }

  /// Teks relatif seperti "5 menit lalu".
  String waktuLalu(DateTime sekarang) {
    final t = dateTime;
    if (t == null) return '';
    final selisih = sekarang.difference(t);
    if (selisih.inMinutes < 1) return 'baru saja';
    if (selisih.inMinutes < 60) return '${selisih.inMinutes} menit lalu';
    if (selisih.inHours < 24) return '${selisih.inHours} jam lalu';
    return '${selisih.inDays} hari lalu';
  }

  static double _radian(double derajat) => derajat * pi / 180;

  static String _asString(Object? value) => value?.toString() ?? '';
}
