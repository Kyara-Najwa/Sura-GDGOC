import 'package:supabase_flutter/supabase_flutter.dart';

class LayananAkun {
  final GoTrueClient _auth = Supabase.instance.client.auth;

  User? get penggunaSaatIni => _auth.currentUser;

  Stream<User?> get perubahanPengguna =>
      _auth.onAuthStateChange.map((state) => state.session?.user);

  Future<void> masuk(String email, String sandi) async {
    await _auth.signInWithPassword(email: email.trim(), password: sandi);
  }

  Future<bool> daftar(String nama, String email, String sandi) async {
    final hasil = await _auth.signUp(
      email: email.trim(),
      password: sandi,
      data: {'nama': nama.trim()},
    );
    return hasil.session != null;
  }

  Future<void> keluar() => _auth.signOut();
}