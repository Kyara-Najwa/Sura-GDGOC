import 'package:flutter/material.dart';
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

  bool get _formValid =>
      _email.text.trim().isNotEmpty &&
      _sandi.text.length >= 6 &&
      (!_modeDaftar || _nama.text.trim().isNotEmpty);

  void _kirim() {
    final akun = context.read<AkunController>();
    if (_modeDaftar) {
      akun.daftar(_nama.text, _email.text, _sandi.text);
    } else {
      akun.masuk(_email.text, _sandi.text);
    }
  }

  void _gantiMode() {
    context.read<AkunController>().hapusPesan();
    setState(() => _modeDaftar = !_modeDaftar);
  }

  @override
  Widget build(BuildContext context) {
    final akun = context.watch<AkunController>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [BL.sky600, Color(0xFF3B82F6)],
                      ),
                    ),
                    child: const Text(
                      'S',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Sura',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: BL.ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Teks langsung dari ucapan lawan bicara',
                    style: TextStyle(color: BL.inkMuted),
                  ),
                  const SizedBox(height: 28),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: glassCard(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          _modeDaftar ? 'Buat akun' : 'Masuk',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (_modeDaftar) ...[
                          TextField(
                            controller: _nama,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                              labelText: 'Nama',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                          const SizedBox(height: 12),
                        ],
                        TextField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _sandi,
                          obscureText: !_sandiTerlihat,
                          decoration: InputDecoration(
                            labelText: 'Kata sandi (min. 6 karakter)',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(_sandiTerlihat
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () => setState(
                                  () => _sandiTerlihat = !_sandiTerlihat),
                            ),
                          ),
                          onChanged: (_) => setState(() {}),
                          onSubmitted: (_) {
                            if (_formValid && !akun.sibuk) _kirim();
                          },
                        ),
                        if (akun.pesan != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            akun.pesan!,
                            style: TextStyle(
                              fontSize: 13,
                              color: akun.pesanBerhasil
                                  ? BL.emerald600
                                  : BL.rose600,
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed:
                              (_formValid && !akun.sibuk) ? _kirim : null,
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                          ),
                          child: akun.sibuk
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(_modeDaftar ? 'Daftar' : 'Masuk'),
                        ),
                        const SizedBox(height: 4),
                        TextButton(
                          onPressed: _gantiMode,
                          child: Text(_modeDaftar
                              ? 'Sudah punya akun? Masuk'
                              : 'Belum punya akun? Daftar'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}