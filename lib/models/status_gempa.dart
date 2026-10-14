/// Tingkat keparahan gempa berdasarkan magnitudo.
enum StatusGempa {
  ringan('Ringan'),
  sedang('Sedang'),
  berat('Berat'),
  kritis('Kritis');

  const StatusGempa(this.label);

  final String label;

  /// Ubah angka di sini kalau ingin mengganti batas kategori.
  static StatusGempa dariMagnitudo(double magnitudo) {
    if (magnitudo >= 6.5) return StatusGempa.kritis;
    if (magnitudo >= 5.5) return StatusGempa.berat;
    if (magnitudo >= 4.0) return StatusGempa.sedang;
    return StatusGempa.ringan;
  }
}
