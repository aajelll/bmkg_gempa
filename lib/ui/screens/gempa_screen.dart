import 'dart:async';

import 'package:flutter/material.dart';

import '../../models/gempa.dart';
import '../../models/kelompok_gempa.dart';
import '../../models/lokasi_pengguna.dart';
import '../../services/gempa_service.dart';
import '../../services/lokasi_service.dart';
import '../widgets/detail_gempa_sheet.dart';
import '../widgets/error_view.dart';
import '../widgets/gempa_content.dart';
import '../widgets/loading_view.dart';

enum _Status { loading, success, error }

/// Halaman pengatur state: loading, sukses, dan error.
class GempaScreen extends StatefulWidget {
  const GempaScreen({super.key});

  @override
  State<GempaScreen> createState() => _GempaScreenState();
}

class _GempaScreenState extends State<GempaScreen> {
  final GempaService _gempaService = GempaService();
  final LokasiService _lokasiService = LokasiService();
  final GlobalKey _semuaKey = GlobalKey();

  Timer? _timer;
  bool _sedangMuat = false;
  bool _memuat = false;
  bool _semuaTerbuka = false;

  _Status _status = _Status.loading;
  KelompokGempa? _kelompok;
  LokasiPengguna? _lokasi;
  String? _lokasiError;
  String _errorMessage = '';
  DateTime _diperbarui = DateTime.now();

  @override
  void initState() {
    super.initState();
    _muat();
    // Real-time: data diperbarui otomatis tiap 1 menit (tanpa loading).
    _timer = Timer.periodic(
      const Duration(seconds: 60),
      (_) => _muat(senyap: true),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _gempaService.dispose();
    super.dispose();
  }

  Future<LokasiPengguna?> _ambilLokasi() async {
    try {
      final lokasi = await _lokasiService.ambilLokasi();
      _lokasiError = null;
      return lokasi;
    } on LokasiException catch (e) {
      _lokasiError = e.message;
      return null;
    }
  }

  Future<void> _muat({bool senyap = false}) async {
    if (_sedangMuat) return;
    _sedangMuat = true;

    if (!senyap) {
      setState(() {
        _memuat = true;
        if (_kelompok == null || _status == _Status.error) {
          _status = _Status.loading;
        }
      });
    }

    // Pembaruan otomatis tidak meminta ulang lokasi.
    final lokasiFuture =
        senyap ? Future<LokasiPengguna?>.value(_lokasi) : _ambilLokasi();

    try {
      final daftar = await _gempaService.ambilSemua();
      final lokasi = await lokasiFuture;
      if (!mounted) return;
      setState(() {
        _lokasi = lokasi;
        _kelompok = KelompokGempa.dari(daftar, lokasi);
        _diperbarui = DateTime.now();
        _status = _Status.success;
        _memuat = false;
      });
    } on GempaException catch (e) {
      if (!(senyap && _kelompok != null)) _tampilkanError(e.message);
    } catch (_) {
      if (!(senyap && _kelompok != null)) {
        _tampilkanError('Terjadi kesalahan tak terduga. Silakan coba lagi.');
      }
    } finally {
      _sedangMuat = false;
    }
  }

  void _tampilkanError(String pesan) {
    if (!mounted) return;
    setState(() {
      _errorMessage = pesan;
      _status = _Status.error;
      _memuat = false;
    });
  }

  void _bukaSemuaDanGulir() {
    setState(() => _semuaTerbuka = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final konteks = _semuaKey.currentContext;
      if (konteks != null) {
        Scrollable.ensureVisible(
          konteks,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _bukaDetail(Gempa gempa) {
    final lokasi = _lokasi;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (context) => DetailGempaSheet(
        gempa: gempa,
        sekarang: DateTime.now(),
        jarakKm: lokasi == null
            ? null
            : gempa.jarakKm(lokasi.latitude, lokasi.longitude),
      ),
    );
  }

  String _jamLabel() {
    final t = _diperbarui;
    final j = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    final d = t.second.toString().padLeft(2, '0');
    return '$j:$m:$d';
  }

  Widget _buildBody() {
    final kelompok = _kelompok;
    switch (_status) {
      case _Status.loading:
        return const SafeArea(child: LoadingView());
      case _Status.error:
        return SafeArea(
          child: ErrorView(message: _errorMessage, onRetry: _muat),
        );
      case _Status.success:
        if (kelompok == null) {
          return SafeArea(
            child: ErrorView(
              message: 'Data gempa kosong. Silakan coba lagi.',
              onRetry: _muat,
            ),
          );
        }
        return GempaContent(
          kelompok: kelompok,
          lokasi: _lokasi,
          lokasiError: _lokasiError,
          sekarang: DateTime.now(),
          diperbarui: _jamLabel(),
          sedangMemuat: _memuat,
          semuaTerbuka: _semuaTerbuka,
          semuaKey: _semuaKey,
          onRefresh: _muat,
          onLihatSemua: _bukaSemuaDanGulir,
          onToggleSemua: () => setState(() => _semuaTerbuka = !_semuaTerbuka),
          onRetryLokasi: _muat,
          onDetail: _bukaDetail,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody());
  }
}
