import 'package:flutter/material.dart';

import '../../models/gempa.dart';
import 'app_colors.dart';
import 'status_badge.dart';
import 'status_style.dart';

/// Isi bottom sheet berisi detail lengkap satu gempa.
class DetailGempaSheet extends StatelessWidget {
  const DetailGempaSheet({
    super.key,
    required this.gempa,
    required this.sekarang,
    this.jarakKm,
  });

  final Gempa gempa;
  final DateTime sekarang;
  final double? jarakKm;

  @override
  Widget build(BuildContext context) {
    final warna = warnaStatus(gempa.status);
    final jarak = jarakKm;
    final waktuLalu = gempa.waktuLalu(sekarang);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'M ${gempa.magnitude.toStringAsFixed(1)}',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: warna,
                  ),
                ),
                const Spacer(),
                StatusBadge(status: gempa.status),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              gempa.wilayah,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.teks,
              ),
            ),
            const SizedBox(height: 16),
            _Baris(
              label: 'Waktu',
              nilai: '${gempa.tanggal}, ${gempa.jam}'
                  '${waktuLalu.isEmpty ? '' : ' ($waktuLalu)'}',
            ),
            _Baris(label: 'Wilayah', nilai: gempa.pulau.label),
            _Baris(
              label: 'Koordinat',
              nilai: '${gempa.lintang}, ${gempa.bujur}',
            ),
            _Baris(label: 'Kedalaman', nilai: gempa.kedalaman),
            if (jarak != null)
              _Baris(
                label: 'Jarak',
                nilai: '± ${jarak.round()} km dari lokasimu',
              ),
            _Baris(
              label: 'Potensi',
              nilai: gempa.potensi.isEmpty ? '-' : gempa.potensi,
              warna: gempa.berpotensiTsunami ? const Color(0xFFEF4444) : null,
            ),
            if (gempa.dirasakan.isNotEmpty)
              _Baris(label: 'Dirasakan (MMI)', nilai: gempa.dirasakan),
          ],
        ),
      ),
    );
  }
}

class _Baris extends StatelessWidget {
  const _Baris({required this.label, required this.nilai, this.warna});

  final String label;
  final String nilai;
  final Color? warna;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(color: AppColors.teksRedup),
            ),
          ),
          Expanded(
            child: Text(
              nilai,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: warna ?? AppColors.teks,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
