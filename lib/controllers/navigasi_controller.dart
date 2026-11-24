import 'package:flutter/foundation.dart';

class NavigasiController extends ChangeNotifier {
  int _tabAktif = 0;
  int get tabAktif => _tabAktif;

  void pilihTab(int nomor) {
    if (nomor == _tabAktif) return;
    _tabAktif = nomor;
    notifyListeners();
  }
}