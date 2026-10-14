import 'package:flutter/material.dart';

import '../../models/gempa.dart';
import 'app_colors.dart';
import 'gempa_card.dart';
import 'section_header.dart';

/// Opsi untuk melihat gempa real-time dari seluruh Indonesia.
class SemuaGempaSection extends StatelessWidget {
  const SemuaGempaSection({
    super.key,
    required this.daftar,
    required this.terbuka,
    required this.sekarang,
    required this.jarakDari,
    required this.onToggle,
    required this.onDetail,
  });

  final List<Gempa> daftar;
  final bool terbuka;
  final DateTime sekarang;
  final double? Function(Gempa) jarakDari;
  final VoidCallback onToggle;
  final void Function(Gempa) onDetail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(
          icon: Icons.sensors,
          judul: 'Gempa Real-Time Indonesia',
          trailing: _LiveBadge(),
        ),
        const SizedBox(height: 12),
        Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${daftar.length} gempa terbaru dari seluruh Indonesia, '
                'diurutkan dari yang paling baru dan diperbarui otomatis '
                'setiap 1 menit.',
                style: const TextStyle(color: AppColors.teksRedup, height: 1.4),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: onToggle,
                icon: Icon(terbuka ? Icons.expand_less : Icons.expand_more),
                label: Text(
                  terbuka
                      ? 'Sembunyikan Daftar'
                      : 'Lihat Gempa Seluruh Indonesia',
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.biru,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                ),
              ),
            ],
          ),
        ),
        if (terbuka)
          for (final gempa in daftar)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: GempaCard(
                gempa: gempa,
                sekarang: sekarang,
                jarakKm: jarakDari(gempa),
                onDetail: () => onDetail(gempa),
              ),
            ),
      ],
    );
  }
}

class _LiveBadge extends StatelessWidget {
  const _LiveBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0x26EF4444),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8, color: Color(0xFFEF4444)),
          SizedBox(width: 5),
          Text(
            'LIVE',
            style: TextStyle(
              color: Color(0xFFEF4444),
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
