
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../controllers/akun_controller.dart';
import '../theme.dart';

class HalamanMasuk extends StatefulWidget {
  const HalamanMasuk({super.key});

  @override
  State<HalamanMasuk> createState() => _HalamanMasukState();
}

class _HalamanMasukState extends State<HalamanMasuk> {
  final _nama = TextEditingController();
  final _email = TextEditingController();
  final _sandi = TextEditingController();

  bool _modeDaftar = false;
  bool _sandiTerlihat = false;

  @override
  void dispose() {
    _nama.dispose();
    _email.dispose();
    _sandi.dispose();
    super.dispose();
  }

  Future<void> _kirim() async {
    final akun = context.read<AkunController>();

    if (_email.text.trim().isEmpty || _sandi.text.isEmpty) {
      return;
    }

    if (_modeDaftar && _nama.text.trim().isEmpty) {
      return;
    }

    if (_modeDaftar) {
      await akun.daftar(
        _nama.text.trim(),
        _email.text.trim(),
        _sandi.text,
      );
    } else {
      await akun.masuk(
        _email.text.trim(),
        _sandi.text,
      );
    }
  }

  void _gantiMode() {
    setState(() {
      _modeDaftar = !_modeDaftar;
    });

    context.read<AkunController>().hapusPesan();
  }

  @override
  Widget build(BuildContext context) {
    final akun = context.watch<AkunController>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: glassCard(radius: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      LucideIcons.messageCircle,
                      size: 42,
                      color: BL.sky700,
                    ),
                    const SizedBox(height: 20),

                    Text(
                      _modeDaftar
                          ? 'Buat Akun Sura'
                          : 'Selamat Datang!',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: BL.ink,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      _modeDaftar
                          ? 'Daftar untuk mulai menggunakan Sura'
                          : 'Masuk ke akunmu dan mulai berkomunikasi',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: BL.inkMuted,
                      ),
                    ),
                    const SizedBox(height: 30),

                    if (_modeDaftar) ...[
                      _label('Nama Lengkap'),
                      const SizedBox(height: 8),
                      _field(
                        controller: _nama,
                        hint: 'Masukkan nama lengkap',
                        icon: LucideIcons.user,
                      ),
                      const SizedBox(height: 18),
                    ],

                    _label('Email'),
                    const SizedBox(height: 8),
                    _field(
                      controller: _email,
                      hint: 'Masukkan email',
                      icon: LucideIcons.mail,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 18),

                    _label('Kata Sandi'),
                    const SizedBox(height: 8),
                    _field(
                      controller: _sandi,
                      hint: 'Masukkan kata sandi',
                      icon: LucideIcons.lock,
                      obscureText: !_sandiTerlihat,
                      suffix: IconButton(
                        onPressed: () {
                          setState(() {
                            _sandiTerlihat = !_sandiTerlihat;
                          });
                        },
                        icon: Icon(
                          _sandiTerlihat
                              ? LucideIcons.eye
                              : LucideIcons.eyeOff,
                          size: 19,
                          color: BL.inkMuted,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    if (akun.pesan != null) ...[
                      Text(
                        akun.pesan!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: akun.pesanBerhasil
                              ? BL.emerald600
                              : BL.rose600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    SizedBox(
                      height: 50,
                      child: FilledButton(
                        onPressed: akun.sibuk ? null : _kirim,
                        style: FilledButton.styleFrom(
                          backgroundColor: BL.sky700,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: akun.sibuk
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                _modeDaftar ? 'Daftar' : 'Masuk',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _modeDaftar
                              ? 'Sudah punya akun? '
                              : 'Belum punya akun? ',
                          style: const TextStyle(
                            color: BL.inkMuted,
                            fontSize: 13,
                          ),
                        ),
                        GestureDetector(
                          onTap: _gantiMode,
                          child: Text(
                            _modeDaftar ? 'Masuk' : 'Daftar',
                            style: const TextStyle(
                              color: BL.sky700,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: BL.ink,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: (_) => setState(() {}),
      style: const TextStyle(
        color: BL.ink,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFF94A3B8),
          fontSize: 13,
        ),
        prefixIcon: Icon(
          icon,
          size: 19,
          color: BL.inkMuted,
        ),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.55),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFFE2E8F0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: BL.sky600,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
