import 'package:flutter/material.dart';

import 'app_colors.dart';

class InfoBaris extends StatelessWidget {
  const InfoBaris({super.key, required this.icon, required this.teks});

  final IconData icon;
  final String teks;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColors.teksRedup),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            teks,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12.5, color: AppColors.teksRedup),
          ),
        ),
      ],
    );
  }
}
