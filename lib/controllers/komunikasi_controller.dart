
import 'dart:async';

import 'package:flutter/foundation.dart';
import '../services/layanan_stt.dart';

class KomunikasiController extends ChangeNotifier {
  KomunikasiController(this._stt);

  final LayananStt _stt;

  final List<String> _kalimat = [];

  String _sementara = '';
  bool _mendengar = false;
  bool _siap = false;
  bool _menjadwalkan = false;
  bool _sedangMemulai = false;

  String? _localeId;
  String? _pesan;

  Timer? _timerMulaiUlang;

  List<String> get kalimat => List.unmodifiable(_kalimat);
  String get sementara => _sementara;
  bool get mendengar => _mendengar;
  String? get pesan => _pesan;

  Future<void> mulai() async {
    if (_mendengar || _sedangMemulai) return;

    _pesan = null;
    _sedangMemulai = true;

    try {
      if (!_siap) {
        _siap = await _stt.siapkan(
          saatStatus: _saatStatus,
          saatGalat: _saatGalat,
        );

        if (!_siap) {
          _pesan =
              'Mikrofon tidak bisa dipakai. Izinkan akses mikrofon dan pastikan layanan suara Google terpasang.';
          notifyListeners();
          return;
        }

        _localeId = await _stt.cariLocaleIndonesia();

        if (_localeId == null) {
          _pesan =
              'Bahasa Indonesia tidak ditemukan. Memakai bahasa bawaan HP.';
        }
      }

      _mendengar = true;
      notifyListeners();
    } catch (e) {
      _pesan = 'Gagal menyiapkan pengenalan suara: $e';
      notifyListeners();
      return;
    } finally {
      _sedangMemulai = false;
    }

    await _dengar();
  }

  Future<void> berhenti() async {
    _mendengar = false;
    _timerMulaiUlang?.cancel();
    _menjadwalkan = false;

    notifyListeners();

    if (_stt.sedangMendengar) {
      await _stt.berhenti();
    }

    _simpanSementara();
  }

  void hapus() {
    _kalimat.clear();
    _sementara = '';
    _pesan = null;
    notifyListeners();
  }

  Future<void> _dengar() async {
    if (!_mendengar ||
        _sedangMemulai ||
        _stt.sedangMendengar) {
      return;
    }

    _sedangMemulai = true;

    try {
      await _stt.mulai(
        localeId: _localeId,
        saatHasil: _saatHasil,
      );
    } catch (e) {
      _pesan = 'Gagal memulai pengenalan suara: $e';
      _mendengar = false;
      notifyListeners();
    } finally {
      _sedangMemulai = false;
    }
  }

  void _saatHasil(String teks, bool akhir) {
    if (!_mendengar) return;

    if (akhir) {
      _sementara = teks;
      _simpanSementara();
    } else {
      _sementara = teks;
      notifyListeners();
    }
  }

  void _simpanSementara() {
    final teks = _sementara.trim();

    if (teks.isNotEmpty) {
      if (_kalimat.isEmpty || _kalimat.last != teks) {
        _kalimat.add(teks);
      }
    }

    _sementara = '';
    notifyListeners();
  }

  void _saatStatus(String status) {
    if (status == 'done' || status == 'notListening') {
      _jadwalkanUlang();
    }
  }

  void _saatGalat(String galat) {
    if (!_mendengar) return;

    if (galat.contains('permission')) {
      _berhentiDenganPesan(
        'Izin mikrofon ditolak. Izinkan lewat Pengaturan HP.',
      );
    } else if (galat.contains('network')) {
      _berhentiDenganPesan(
        'Pengenalan suara membutuhkan internet. Periksa koneksimu.',
      );
    } else if (galat.contains('no_match') ||
        galat.contains('timeout') ||
        galat.contains('busy')) {
      _jadwalkanUlang();
    } else {
      _berhentiDenganPesan('Galat suara: $galat');
    }
  }

  void _berhentiDenganPesan(String pesan) {
    _mendengar = false;
    _pesan = pesan;
    _timerMulaiUlang?.cancel();
    _menjadwalkan = false;
    notifyListeners();
  }

  void _jadwalkanUlang() {
    if (!_mendengar || _menjadwalkan) return;

    _menjadwalkan = true;
    _timerMulaiUlang?.cancel();

    _timerMulaiUlang = Timer(
      const Duration(milliseconds: 600),
      () {
        _menjadwalkan = false;

        if (_mendengar) {
          _dengar();
        }
      },
    );
  }

  @override
  void dispose() {
    _timerMulaiUlang?.cancel();
    super.dispose();
  }
}
