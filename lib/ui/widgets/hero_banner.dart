import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Banner gelap di bagian paling atas halaman.
class HeroBanner extends StatelessWidget {
  const HeroBanner({
    super.key,
    required this.lokasiLabel,
    required this.diperbarui,
    required this.sedangMemuat,
    required this.onRefresh,
    required this.onLihatSemua,
  });

  final String lokasiLabel;
  final String diperbarui;
  final bool sedangMemuat;
  final VoidCallback onRefresh;
  final VoidCallback onLihatSemua;

  @override
  Widget build(BuildContext context) {
    final atas = MediaQuery.of(context).padding.top;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF021B26), Color(0xFF0B5D4B)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Stack(
        children: [
          const Positioned(
            right: -40,
            top: 30,
            child: _Lingkaran(ukuran: 160, warna: Color(0x2214E3B0)),
          ),
          const Positioned(
            right: 50,
            bottom: 90,
            child: _Lingkaran(ukuran: 36, warna: Color(0x44F5B800)),
          ),
          const Positioned(
            left: -30,
            bottom: -30,
            child: _Lingkaran(ukuran: 110, warna: Color(0x22EF4444)),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, atas + 20, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.public, color: AppColors.hijau),
                    SizedBox(width: 8),
                    Text(
                      'Pantau Gempa',
                      style: TextStyle(
                        color: AppColors.hijau,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _Chip(
                      leading: const Icon(
                        Icons.circle,
                        size: 8,
                        color: Color(0xFFEF4444),
                      ),
                      teks: 'LIVE • Diperbarui $diperbarui',
                    ),
                    _Chip(
                      leading: const Icon(
                        Icons.my_location,
                        size: 13,
                        color: AppColors.hijau,
                      ),
                      teks: lokasiLabel,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Pantau Informasi Gempa Bumi di Sekitarmu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    height: 1.15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Data real-time dari BMKG, dikelompokkan berdasarkan '
                  'lokasi dan pulau tempatmu berada.',
                  style: TextStyle(color: Colors.white70, height: 1.4),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: sedangMemuat ? null : onRefresh,
                        icon: sedangMemuat
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.refresh),
                        label: const Text('Perbarui'),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.biru,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(48),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onLihatSemua,
                        icon: const Icon(Icons.public),
                        label: const Text('Seluruh Indonesia'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.hijau,
                          side: const BorderSide(color: AppColors.hijau),
                          minimumSize: const Size.fromHeight(48),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Lingkaran extends StatelessWidget {
  const _Lingkaran({required this.ukuran, required this.warna});

  final double ukuran;
  final Color warna;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ukuran,
      height: ukuran,
      decoration: BoxDecoration(color: warna, shape: BoxShape.circle),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.leading, required this.teks});

  final Widget leading;
  final String teks;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0x26FFFFFF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          leading,
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              teks,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
