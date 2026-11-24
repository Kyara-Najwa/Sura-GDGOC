import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/akun_controller.dart';
import 'controllers/komunikasi_controller.dart';
import 'controllers/navigasi_controller.dart';
import 'services/layanan_akun.dart';
import 'services/layanan_stt.dart';
import 'theme.dart';
import 'views/auth_gate.dart';

class SuraApp extends StatelessWidget {
  const SuraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigasiController()),
        ChangeNotifierProvider(create: (_) => AkunController(LayananAkun())),
        ChangeNotifierProvider(
          create: (_) => KomunikasiController(LayananStt()),
        ),
      ],
      child: MaterialApp(
        title: 'Sura',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        builder: (context, child) => GradientBackground(child: child!),
        home: const AuthGate(),
      ),
    );
  }
}