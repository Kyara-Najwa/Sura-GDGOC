import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/layanan_akun.dart';

class AkunController extends ChangeNotifier {
  AkunController(this._layanan) {
    _pengguna = _layanan.penggunaSaatIni;
    _langganan = _layanan.perubahanPengguna.listen((pengguna) {
      _pengguna = pengguna;
      notifyListeners();
    });
  }

  final LayananAkun _layanan;
  late final StreamSubscription<User?> _langganan;

  User? _pengguna;
  bool _sibuk = false;
  String? _pesan;
  bool _pesanBerhasil = false;

  bool get sudahMasuk => _pengguna != null;
  bool get sibuk => _sibuk;
  String? get pesan => _pesan;
  bool get pesanBerhasil => _pesanBerhasil;
  String? get email => _pengguna?.email;
  String get nama {
    final n = _pengguna?.userMetadata?['nama'];
    return (n is String && n.isNotEmpty) ? n : 'Pengguna';
  }

  Future<void> masuk(String email, String sandi) =>
      _jalankan(() => _layanan.masuk(email, sandi));

  Future<void> daftar(String nama, String email, String sandi) =>
      _jalankan(() async {
        final langsungMasuk = await _layanan.daftar(nama, email, sandi);
        if (!langsungMasuk) {
          _pesan = 'Pendaftaran berhasil. Cek email untuk verifikasi, lalu masuk.';
          _pesanBerhasil = true;
        }
      });

  Future<void> keluar() => _layanan.keluar();

  void hapusPesan() {
    _pesan = null;
    notifyListeners();
  }

  Future<void> _jalankan(Future<void> Function() aksi) async {
    _sibuk = true;
    _pesan = null;
    _pesanBerhasil = false;
    notifyListeners();
    try {
      await aksi();
    } on AuthException catch (e) {
      _pesan = _ramah(e.message);
    } catch (_) {
      _pesan = 'Tidak bisa terhubung. Periksa koneksi internet.';
    } finally {
      _sibuk = false;
      notifyListeners();
    }
  }

  String _ramah(String pesanAsli) {
    final p = pesanAsli.toLowerCase();
    if (p.contains('invalid login')) return 'Email atau kata sandi salah.';
    if (p.contains('already registered')) return 'Email ini sudah terdaftar. Coba masuk.';
    if (p.contains('at least')) return 'Kata sandi terlalu pendek. Minimal 6 karakter.';
    if (p.contains('not confirmed')) return 'Email belum diverifikasi. Cek kotak masukmu.';
    if (p.contains('valid email') || p.contains('invalid email')) {
      return 'Format email tidak valid.';
    }
    return pesanAsli;
  }

  @override
  void dispose() {
    _langganan.cancel();
    super.dispose();
  }
}