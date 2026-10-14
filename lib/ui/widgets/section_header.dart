import 'package:flutter/material.dart';

import 'app_colors.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.icon,
    required this.judul,
    this.trailing,
  });

  final IconData icon;
  final String judul;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final ekor = trailing;
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(
            gradient: AppColors.gradasi,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: Colors.white),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            judul,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.teks,
            ),
          ),
        ),
        ?ekor,
      ],
    );
  }
}
