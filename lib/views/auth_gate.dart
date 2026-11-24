import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/akun_controller.dart';
import 'halaman_masuk.dart';
import 'halaman_utama.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final sudahMasuk = context.watch<AkunController>().sudahMasuk;
    return sudahMasuk ? const HalamanUtama() : const HalamanMasuk();
  }
}