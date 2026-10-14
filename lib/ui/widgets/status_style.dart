import 'package:flutter/material.dart';

import '../../models/status_gempa.dart';

/// Warna untuk tiap status gempa.
Color warnaStatus(StatusGempa status) {
  return switch (status) {
    StatusGempa.ringan => const Color(0xFF14C9A0),
    StatusGempa.sedang => const Color(0xFFF5B800),
    StatusGempa.berat => const Color(0xFFFF8A3D),
    StatusGempa.kritis => const Color(0xFFEF4444),
  };
}
