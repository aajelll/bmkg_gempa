import 'dart:math';

/// Kotak koordinat kasar (bounding box) untuk satu bagian pulau.
class KotakKoordinat {
  const KotakKoordinat(this.latMin, this.latMax, this.lonMin, this.lonMax);

  final double latMin;
  final double latMax;
  final double lonMin;
  final double lonMax;

  /// 0 jika titik berada di dalam kotak, selain itu jarak (derajat) ke tepi.
  double jarakDerajat(double lat, double lon) {
    final dy = lat < latMin ? latMin - lat : (lat > latMax ? lat - latMax : 0.0);
    final dx = lon < lonMin ? lonMin - lon : (lon > lonMax ? lon - lonMax : 0.0);
    return sqrt(dx * dx + dy * dy);
  }
}

/// Kelompok pulau utama di Indonesia. Pengelompokan bersifat pendekatan:
/// titik di laut dimasukkan ke pulau terdekat.
enum Pulau {
  sumatera('Pulau Sumatera', [
    KotakKoordinat(-6.0, 6.2, 95.0, 106.1),
    KotakKoordinat(-3.4, -1.4, 105.0, 108.4),
  ]),
  jawa('Pulau Jawa', [KotakKoordinat(-8.9, -5.9, 105.1, 114.4)]),
  baliNusaTenggara('Bali & Nusa Tenggara', [
    KotakKoordinat(-11.0, -8.0, 114.4, 127.0),
  ]),
  sulawesi('Pulau Sulawesi', [KotakKoordinat(-6.0, 3.0, 118.7, 125.4)]),
  kalimantan('Pulau Kalimantan', [KotakKoordinat(-4.3, 4.5, 108.8, 119.0)]),
  maluku('Kepulauan Maluku', [
    KotakKoordinat(-4.0, 3.5, 125.5, 130.7),
    KotakKoordinat(-8.4, -4.2, 126.0, 135.0),
  ]),
  papua('Pulau Papua', [KotakKoordinat(-9.2, 0.9, 130.7, 141.1)]);

  const Pulau(this.label, this.kotak);

  final String label;
  final List<KotakKoordinat> kotak;

  static Pulau dariKoordinat(double lat, double lon) {
    var terbaik = Pulau.sumatera;
    var jarakTerbaik = double.infinity;
    for (final pulau in Pulau.values) {
      for (final k in pulau.kotak) {
        final d = k.jarakDerajat(lat, lon);
        if (d < jarakTerbaik) {
          jarakTerbaik = d;
          terbaik = pulau;
        }
      }
    }
    return terbaik;
  }
}
