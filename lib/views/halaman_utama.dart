
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../controllers/navigasi_controller.dart';
import '../theme.dart';
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
    ikon: LucideIcons.messageCircle,
    ikonAktif: LucideIcons.messageCircle,
    halaman: HalamanKomunikasi(),
  ),
  _ItemTab(
    nama: 'HUD',
    ikon: LucideIcons.glasses,
    ikonAktif: LucideIcons.glasses,
    halaman: HalamanHud(),
  ),
  _ItemTab(
    nama: 'Benchmark',
    ikon: LucideIcons.chartNoAxesCombined,
    ikonAktif: LucideIcons.chartNoAxesCombined,
    halaman: HalamanBenchmark(),
  ),
  _ItemTab(
    nama: 'Profil',
    ikon: LucideIcons.userRound,
    ikonAktif: LucideIcons.userRound,
    halaman: HalamanProfil(),
  ),
];

class HalamanUtama extends StatelessWidget {
  const HalamanUtama({super.key});

  @override
  Widget build(BuildContext context) {
    final navigasi = context.watch<NavigasiController>();

    return Scaffold(
      backgroundColor: Colors.transparent,

      appBar: AppBar(
        title: Text(
          'Sura · ${_daftarTab[navigasi.tabAktif].nama}',
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: BL.ink,
          ),
        ),
        centerTitle: false,
      ),

      body: IndexedStack(
        index: navigasi.tabAktif,
        children: [
          for (final tab in _daftarTab) tab.halaman,
        ],
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: navigasi.tabAktif,
        onDestinationSelected:
            context.read<NavigasiController>().pilihTab,
        backgroundColor: BL.glass,
        indicatorColor: BL.sky600.withValues(alpha: 0.15),
        elevation: 0,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          for (final tab in _daftarTab)
            NavigationDestination(
              icon: Icon(
                tab.ikon,
                size: 21,
                color: BL.inkMuted,
              ),
              selectedIcon: Icon(
                tab.ikonAktif,
                size: 22,
                color: BL.sky700,
              ),
              label: tab.nama,
            ),
        ],
      ),
    );
  }
}
