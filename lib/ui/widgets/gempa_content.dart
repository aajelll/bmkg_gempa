import 'package:flutter/material.dart';

import '../../models/gempa.dart';
import '../../models/kelompok_gempa.dart';
import '../../models/lokasi_pengguna.dart';
import 'app_colors.dart';
import 'gempa_card.dart';
import 'hero_banner.dart';
import 'lokasi_notice.dart';
import 'ringkasan_section.dart';
import 'section_header.dart';
import 'semua_gempa_section.dart';

/// Halaman penuh saat data berhasil dimuat.
class GempaContent extends StatelessWidget {
  const GempaContent({
    super.key,
    required this.kelompok,
    required this.lokasi,
    required this.lokasiError,
    required this.sekarang,
    required this.diperbarui,
    required this.sedangMemuat,
    required this.semuaTerbuka,
    required this.semuaKey,
    required this.onRefresh,
    required this.onLihatSemua,
    required this.onToggleSemua,
    required this.onRetryLokasi,
    required this.onDetail,
  });

  final KelompokGempa kelompok;
  final LokasiPengguna? lokasi;
  final String? lokasiError;
  final DateTime sekarang;
  final String diperbarui;
  final bool sedangMemuat;
  final bool semuaTerbuka;
  final GlobalKey semuaKey;
  final VoidCallback onRefresh;
  final VoidCallback onLihatSemua;
  final VoidCallback onToggleSemua;
  final VoidCallback onRetryLokasi;
  final void Function(Gempa) onDetail;

  static const EdgeInsets _sisi = EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    final lok = lokasi;
    final terdekat = kelompok.terdekat;
    final sepulauLain = kelompok.sepulauLain;

    double? jarakDari(Gempa g) =>
        lok == null ? null : g.jarakKm(lok.latitude, lok.longitude);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HeroBanner(
            lokasiLabel: lok == null
                ? 'Lokasi belum aktif'
                : 'Lokasimu: ${lok.pulau.label}',
            diperbarui: diperbarui,
            sedangMemuat: sedangMemuat,
            onRefresh: onRefresh,
            onLihatSemua: onLihatSemua,
          ),
          const SizedBox(height: 24),
          if (lok == null)
            Padding(
              padding: _sisi,
              child: LokasiNotice(
                pesan: lokasiError ?? 'Lokasi belum diizinkan.',
                onRetry: onRetryLokasi,
              ),
            )
          else ...[
            const Padding(
              padding: _sisi,
              child: SectionHeader(
                icon: Icons.my_location,
                judul: 'Gempa Terdekat dari Lokasimu',
              ),
            ),
            const SizedBox(height: 12),
            if (terdekat != null)
              Padding(
                padding: _sisi,
                child: GempaCard(
                  gempa: terdekat,
                  sekarang: sekarang,
                  jarakKm: kelompok.jarakTerdekatKm,
                  onDetail: () => onDetail(terdekat),
                ),
              ),
            const SizedBox(height: 24),
            Padding(
              padding: _sisi,
              child: SectionHeader(
                icon: Icons.terrain,
                judul: 'Gempa Lain di ${lok.pulau.label}',
              ),
            ),
            const SizedBox(height: 12),
            if (sepulauLain.isEmpty)
              const Padding(
                padding: _sisi,
                child: Text(
                  'Belum ada gempa lain yang tercatat di wilayah ini.',
                  style: TextStyle(color: AppColors.teksRedup),
                ),
              )
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(20, 4, 8, 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final g in sepulauLain)
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: GempaCard(
                          width: 280,
                          gempa: g,
                          sekarang: sekarang,
                          jarakKm: jarakDari(g),
                          onDetail: () => onDetail(g),
                        ),
                      ),
                  ],
                ),
              ),
          ],
          const SizedBox(height: 24),
          Padding(
            padding: _sisi,
            child: RingkasanSection(
              total: kelompok.semua.length,
              magnitudoTertinggi: kelompok.magnitudoTertinggi,
              dirasakan: kelompok.jumlahDirasakan,
              sepulau: lok == null ? null : kelompok.sepulau.length,
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: _sisi,
            child: SemuaGempaSection(
              key: semuaKey,
              daftar: kelompok.semua,
              terbuka: semuaTerbuka,
              sekarang: sekarang,
              jarakDari: jarakDari,
              onToggle: onToggleSemua,
              onDetail: onDetail,
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'Sumber: BMKG',
              style: TextStyle(fontSize: 12, color: AppColors.teksRedup),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 24),
        ],
      ),
    );
  }
}
