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
  String? _localeId;
  String? _pesan;

  List<String> get kalimat => List.unmodifiable(_kalimat);
  String get sementara => _sementara;
  bool get mendengar => _mendengar;
  String? get pesan => _pesan;

  Future<void> mulai() async {
    _pesan = null;
    if (!_siap) {
      _siap = await _stt.siapkan(saatStatus: _saatStatus, saatGalat: _saatGalat);
      if (!_siap) {
        _pesan =
            'Mikrofon tidak bisa dipakai. Izinkan akses mikrofon dan pastikan layanan suara Google terpasang.';
        notifyListeners();
        return;
      }
      _localeId = await _stt.cariLocaleIndonesia();
      if (_localeId == null) {
        _pesan =
            'Bahasa Indonesia tidak ditemukan di HP ini. Memakai bahasa bawaan HP.';
      }
    }
    _mendengar = true;
    notifyListeners();
    await _dengar();
  }

  Future<void> berhenti() async {
    _mendengar = false;
    notifyListeners();
    await _stt.berhenti();
    await Future.delayed(const Duration(milliseconds: 300));
    if (_sementara.trim().isNotEmpty) {
      _kalimat.add(_sementara.trim());
      _sementara = '';
      notifyListeners();
    }
  }

  void hapus() {
    _kalimat.clear();
    _sementara = '';
    _pesan = null;
    notifyListeners();
  }

  Future<void> _dengar() async {
    if (!_mendengar || _stt.sedangMendengar) return;
    await _stt.mulai(localeId: _localeId, saatHasil: _saatHasil);
  }

  void _saatHasil(String teks, bool akhir) {
    if (akhir) {
      final t = teks.trim();
      if (t.isNotEmpty) _kalimat.add(t);
      _sementara = '';
    } else {
      _sementara = teks;
    }
    notifyListeners();
  }

  void _saatStatus(String status) {
    if (status == 'done' || status == 'notListening') _jadwalkanUlang();
  }

  void _saatGalat(String galat) {
    if (galat.contains('permission')) {
      _berhentiDenganPesan('Izin mikrofon ditolak. Izinkan lewat Pengaturan HP.');
    } else if (galat.contains('network')) {
      _berhentiDenganPesan('Pengenalan suara butuh internet. Periksa koneksimu.');
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
    notifyListeners();
  }

  void _jadwalkanUlang() {
    if (!_mendengar || _menjadwalkan) return;
    _menjadwalkan = true;
    Future.delayed(const Duration(milliseconds: 400), () {
      _menjadwalkan = false;
      _dengar();
    });
  }
}
