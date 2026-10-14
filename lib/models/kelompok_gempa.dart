import 'gempa.dart';
import 'lokasi_pengguna.dart';

/// Hasil pengelompokan gempa: semua, terdekat, dan satu pulau dengan pengguna.
class KelompokGempa {
  const KelompokGempa({
    required this.semua,
    required this.sepulau,
    this.terdekat,
    this.jarakTerdekatKm,
  });

  /// Mengelompokkan [semua] gempa berdasarkan [lokasi] (boleh null).
  factory KelompokGempa.dari(List<Gempa> semua, LokasiPengguna? lokasi) {
    if (lokasi == null) {
      return KelompokGempa(
        semua: List.unmodifiable(semua),
        sepulau: const [],
      );
    }

    Gempa? terdekat;
    double? jarakTerdekat;
    for (final g in semua) {
      final d = g.jarakKm(lokasi.latitude, lokasi.longitude);
      if (jarakTerdekat == null || d < jarakTerdekat) {
        terdekat = g;
        jarakTerdekat = d;
      }
    }

    return KelompokGempa(
      semua: List.unmodifiable(semua),
      sepulau: List.unmodifiable(
        semua.where((g) => g.pulau == lokasi.pulau),
      ),
      terdekat: terdekat,
      jarakTerdekatKm: jarakTerdekat,
    );
  }

  final List<Gempa> semua;
  final List<Gempa> sepulau;
  final Gempa? terdekat;
  final double? jarakTerdekatKm;

  /// Gempa sepulau, tanpa gempa terdekat (supaya tidak tampil dua kali).
  List<Gempa> get sepulauLain =>
      sepulau.where((g) => !identical(g, terdekat)).toList();

  double get magnitudoTertinggi =>
      semua.fold<double>(0, (m, g) => g.magnitude > m ? g.magnitude : m);

  int get jumlahDirasakan =>
      semua.where((g) => g.dirasakan.isNotEmpty).length;
}
