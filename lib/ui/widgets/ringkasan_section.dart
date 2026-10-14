import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'section_header.dart';

/// Ringkasan angka dalam kartu-kartu kecil.
class RingkasanSection extends StatelessWidget {
  const RingkasanSection({
    super.key,
    required this.total,
    required this.magnitudoTertinggi,
    required this.dirasakan,
    required this.sepulau,
  });

  final int total;
  final double magnitudoTertinggi;
  final int dirasakan;

  /// Null jika lokasi belum tersedia.
  final int? sepulau;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        children: [
          const SectionHeader(icon: Icons.insights, judul: 'Ringkasan'),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _Tile(
                  icon: Icons.monitor_heart_outlined,
                  warna: AppColors.biru,
                  nilai: '$total',
                  label: 'Total Gempa',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _Tile(
                  icon: Icons.bolt,
                  warna: const Color(0xFFEF4444),
                  nilai: magnitudoTertinggi.toStringAsFixed(1),
                  label: 'Magnitudo Tertinggi',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _Tile(
                  icon: Icons.people_outline,
                  warna: const Color(0xFFF5B800),
                  nilai: '$dirasakan',
                  label: 'Dirasakan',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _Tile(
                  icon: Icons.terrain,
                  warna: const Color(0xFF14C9A0),
                  nilai: sepulau == null ? '-' : '$sepulau',
                  label: 'Di Pulaumu',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.icon,
    required this.warna,
    required this.nilai,
    required this.label,
  });

  final IconData icon;
  final Color warna;
  final String nilai;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: warna.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: warna),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nilai,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: warna,
                  ),
                ),
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.teksRedup,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
