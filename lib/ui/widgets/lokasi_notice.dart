import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Pesan saat lokasi belum bisa dipakai, lengkap dengan tombol coba lagi.
class LokasiNotice extends StatelessWidget {
  const LokasiNotice({super.key, required this.pesan, required this.onRetry});

  final String pesan;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFF8A3D)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.location_off, color: Color(0xFFFF8A3D)),
              SizedBox(width: 8),
              Text(
                'Lokasi belum tersedia',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.teks,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(pesan, style: const TextStyle(color: AppColors.teksRedup)),
          const SizedBox(height: 4),
          const Text(
            'Gempa terdekat dan gempa sepulau tidak bisa ditampilkan tanpa '
            'lokasi, tetapi daftar seluruh Indonesia tetap tersedia di bawah.',
            style: TextStyle(fontSize: 12, color: AppColors.teksRedup),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.replay),
            label: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }
}
