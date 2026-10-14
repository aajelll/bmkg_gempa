import 'package:flutter/material.dart';

import '../../models/gempa.dart';
import 'app_colors.dart';
import 'info_baris.dart';
import 'status_badge.dart';
import 'status_style.dart';

/// Kartu satu gempa: garis warna status di atas, magnitudo, waktu, lokasi.
class GempaCard extends StatelessWidget {
  const GempaCard({
    super.key,
    required this.gempa,
    required this.sekarang,
    required this.onDetail,
    this.jarakKm,
    this.width,
  });

  final Gempa gempa;
  final DateTime sekarang;
  final VoidCallback onDetail;
  final double? jarakKm;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final warna = warnaStatus(gempa.status);
    final waktuLalu = gempa.waktuLalu(sekarang);
    final jarak = jarakKm;

    return Container(
      width: width,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 8, color: warna),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'M ${gempa.magnitude.toStringAsFixed(1)}',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: warna,
                      ),
                    ),
                    const Spacer(),
                    StatusBadge(status: gempa.status),
                  ],
                ),
                const SizedBox(height: 8),
                InfoBaris(
                  icon: Icons.schedule,
                  teks: '${gempa.tanggal}, ${gempa.jam}',
                ),
                const SizedBox(height: 4),
                InfoBaris(
                  icon: Icons.update,
                  teks: waktuLalu.isEmpty ? '-' : waktuLalu,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 38,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on, size: 18, color: warna),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          gempa.wilayah,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.teks,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                InfoBaris(
                  icon: Icons.vertical_align_bottom,
                  teks: 'Kedalaman ${gempa.kedalaman}',
                ),
                const SizedBox(height: 4),
                InfoBaris(
                  icon: Icons.explore_outlined,
                  teks: '${gempa.lintang}, ${gempa.bujur}',
                ),
                if (jarak != null) ...[
                  const SizedBox(height: 4),
                  InfoBaris(
                    icon: Icons.near_me_outlined,
                    teks: 'Jarak ± ${jarak.round()} km dari lokasimu',
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          Material(
            color: Colors.white,
            child: InkWell(
              onTap: onDetail,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Text(
                      'lihat Detail',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.teks,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_forward, size: 18, color: AppColors.teks),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
