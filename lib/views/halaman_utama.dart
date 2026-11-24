import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/navigasi_controller.dart';
import 'halaman_benchmark.dart';
import 'halaman_hud.dart';
import 'halaman_komunikasi.dart';
import 'halaman_profil.dart';

class _ItemTab {
  const _ItemTab({
    required this.nama,
    required this.ikon,
    required this.ikonAktif,
    required this.halaman,
  });

  final String nama;
  final IconData ikon;
  final IconData ikonAktif;
  final Widget halaman;
}

const _daftarTab = <_ItemTab>[
  _ItemTab(
    nama: 'Komunikasi',
    ikon: Icons.chat_bubble_outline,
    ikonAktif: Icons.chat_bubble,
    halaman: HalamanKomunikasi(),
  ),
  _ItemTab(
    nama: 'HUD',
    ikon: Icons.visibility_outlined,
    ikonAktif: Icons.visibility,
    halaman: HalamanHud(),
  ),
  _ItemTab(
    nama: 'Benchmark',
    ikon: Icons.analytics_outlined,
    ikonAktif: Icons.analytics,
    halaman: HalamanBenchmark(),
  ),
  _ItemTab(
    nama: 'Profil',
    ikon: Icons.person_outline,
    ikonAktif: Icons.person,
    halaman: HalamanProfil(),
  ),
];

class HalamanUtama extends StatelessWidget {
  const HalamanUtama({super.key});

  @override
  Widget build(BuildContext context) {
    final navigasi = context.watch<NavigasiController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Sura · ${_daftarTab[navigasi.tabAktif].nama}'),
      ),
      body: IndexedStack(
        index: navigasi.tabAktif,
        children: [for (final tab in _daftarTab) tab.halaman],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigasi.tabAktif,
        onDestinationSelected: context.read<NavigasiController>().pilihTab,
        destinations: [
          for (final tab in _daftarTab)
            NavigationDestination(
              icon: Icon(tab.ikon),
              selectedIcon: Icon(tab.ikonAktif),
              label: tab.nama,
            ),
        ],
      ),
    );
  }
}