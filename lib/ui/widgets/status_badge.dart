import 'package:flutter/material.dart';

import '../../models/status_gempa.dart';
import 'status_style.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final StatusGempa status;

  @override
  Widget build(BuildContext context) {
    final warna = warnaStatus(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: warna.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: warna,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
