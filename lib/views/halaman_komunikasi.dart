
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/komunikasi_controller.dart';
import '../theme.dart';

class HalamanKomunikasi extends StatefulWidget {
  const HalamanKomunikasi({super.key});

  @override
  State<HalamanKomunikasi> createState() => _HalamanKomunikasiState();
}

class _HalamanKomunikasiState extends State<HalamanKomunikasi> {
  final ScrollController _gulir = ScrollController();

  double _ukuranTeks = 24;

  @override
  void dispose() {
    _gulir.dispose();
    super.dispose();
  }

  void _gulirKeBawah() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_gulir.hasClients) return;

      _gulir.animateTo(
        _gulir.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void _bukaLayarPenuh() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => HalamanSubtitlePenuh(
          ukuranTeks: _ukuranTeks,
          saatUkuranBerubah: (nilai) {
            if (!mounted) return;

            setState(() {
              _ukuranTeks = nilai;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final k = context.watch<KomunikasiController>();
    final kosong = k.kalimat.isEmpty && k.sementara.isEmpty;

    if (k.mendengar || !kosong) {
      _gulirKeBawah();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Status Live
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 13,
            ),
            decoration: BoxDecoration(
              color: k.mendengar
                  ? BL.sky600.withValues(alpha: 0.10)
                  : Colors.white.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: k.mendengar
                    ? BL.sky600.withValues(alpha: 0.25)
                    : BL.inkMuted.withValues(alpha: 0.12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  k.mendengar ? Icons.graphic_eq : Icons.mic_none,
                  color: k.mendengar ? BL.sky600 : BL.inkMuted,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        k.mendengar
                            ? 'Mendengarkan percakapan'
                            : 'Siap untuk mendengarkan',
                        style: TextStyle(
                          color: k.mendengar ? BL.sky700 : BL.ink,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        k.mendengar
                            ? 'Ucapan akan ditampilkan secara langsung'
                            : 'Aktifkan mikrofon untuk memulai',
                        style: const TextStyle(
                          color: BL.inkMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                if (k.mendengar)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: BL.sky600,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'LIVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Area subtitle
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: glassCard(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header area subtitle
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Subtitle Percakapan',
                          style: TextStyle(
                            color: BL.ink,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      IconButton.outlined(
                        onPressed: _bukaLayarPenuh,
                        tooltip: 'Buka layar penuh',
                        icon: const Icon(
                          Icons.fullscreen_rounded,
                          color: BL.sky600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Tampilan percakapan
                  Expanded(
                    child: kosong
                        ? _tampilanKosong(k.mendengar)
                        : SingleChildScrollView(
                            controller: _gulir,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (k.kalimat.isNotEmpty) ...[
                                  const Text(
                                    'HASIL PERCAKAPAN',
                                    style: TextStyle(
                                      color: BL.inkMuted,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  for (final kalimat in k.kalimat)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 16,
                                      ),
                                      child: Text(
                                        kalimat,
                                        style: TextStyle(
                                          fontSize: _ukuranTeks,
                                          height: 1.5,
                                          color: BL.ink,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                ],

                                if (k.sementara.isNotEmpty) ...[
                                  if (k.kalimat.isNotEmpty)
                                    const Divider(height: 24),
                                  Row(
                                    children: [
                                      Container(
                                        width: 7,
                                        height: 7,
                                        decoration: const BoxDecoration(
                                          color: BL.sky600,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'SEDANG DIUCAPKAN',
                                        style: TextStyle(
                                          color: BL.sky700,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    k.sementara,
                                    style: TextStyle(
                                      fontSize: _ukuranTeks,
                                      height: 1.5,
                                      color: BL.ink,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                  ),

                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),

                  // Pengaturan ukuran teks
                  Row(
                    children: [
                      const Icon(
                        Icons.format_size_rounded,
                        color: BL.sky600,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Ukuran teks',
                          style: TextStyle(
                            color: BL.ink,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      _labelUkuran(_ukuranTeks),
                    ],
                  ),

                  const SizedBox(height: 4),

                  _sliderUkuran(
                    nilai: _ukuranTeks,
                    saatBerubah: (nilai) {
                      setState(() {
                        _ukuranTeks = nilai;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          // Pesan error
          if (k.pesan != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: BL.rose600.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                k.pesan!,
                style: const TextStyle(
                  fontSize: 12,
                  color: BL.rose600,
                ),
              ),
            ),
          ],

          const SizedBox(height: 14),

          // Tombol kontrol
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: k.mendengar
                      ? context.read<KomunikasiController>().berhenti
                      : context.read<KomunikasiController>().mulai,
                  icon: Icon(
                    k.mendengar
                        ? Icons.stop_rounded
                        : Icons.mic_rounded,
                  ),
                  label: Text(
                    k.mendengar
                        ? 'Berhenti'
                        : 'Mulai Live Subtitle',
                  ),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                    backgroundColor:
                        k.mendengar ? BL.rose600 : BL.sky600,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton.outlined(
                onPressed: kosong
                    ? null
                    : context.read<KomunikasiController>().hapus,
                icon: const Icon(Icons.delete_outline_rounded),
                tooltip: 'Hapus percakapan',
                style: IconButton.styleFrom(
                  minimumSize: const Size(54, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _labelUkuran(double ukuran) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: BL.sky600.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '${ukuran.round()} px',
        style: const TextStyle(
          color: BL.sky700,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _sliderUkuran({
    required double nilai,
    required ValueChanged<double> saatBerubah,
  }) {
    return Row(
      children: [
        const Text(
          'A',
          style: TextStyle(
            fontSize: 12,
            color: BL.inkMuted,
          ),
        ),
        Expanded(
          child: Slider(
            value: nilai,
            min: 16,
            max: 40,
            divisions: 24,
            label: '${nilai.round()} px',
            activeColor: BL.sky600,
            inactiveColor: BL.sky600.withValues(alpha: 0.15),
            onChanged: saatBerubah,
          ),
        ),
        const Text(
          'A',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: BL.inkMuted,
          ),
        ),
      ],
    );
  }

  Widget _tampilanKosong(bool mendengar) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: BL.sky600.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              mendengar
                  ? Icons.graphic_eq
                  : Icons.hearing_outlined,
              size: 36,
              color: BL.sky600,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            mendengar
                ? 'Menunggu seseorang berbicara...'
                : 'Percakapan akan muncul di sini',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: BL.ink,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Suara lawan bicara akan diubah menjadi teks secara langsung.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: BL.inkMuted,
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================
// HALAMAN SUBTITLE LAYAR PENUH
// ======================================================

class HalamanSubtitlePenuh extends StatefulWidget {
  const HalamanSubtitlePenuh({
    super.key,
    required this.ukuranTeks,
    required this.saatUkuranBerubah,
  });

  final double ukuranTeks;
  final ValueChanged<double> saatUkuranBerubah;

  @override
  State<HalamanSubtitlePenuh> createState() =>
      _HalamanSubtitlePenuhState();
}

class _HalamanSubtitlePenuhState extends State<HalamanSubtitlePenuh> {
  final ScrollController _gulir = ScrollController();

  bool _perluGulir = false;

  @override
  void dispose() {
    _gulir.dispose();
    super.dispose();
  }

  void _jadwalkanGulir() {
    if (_perluGulir) return;

    _perluGulir = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _perluGulir = false;

      if (!mounted || !_gulir.hasClients) return;

      _gulir.animateTo(
        _gulir.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final k = context.watch<KomunikasiController>();
    final kosong = k.kalimat.isEmpty && k.sementara.isEmpty;

    if (!kosong) {
      _jadwalkanGulir();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF101827),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 16,
          ),
          child: Column(
            children: [
              // Header layar penuh
              Row(
                children: [
                  const Icon(
                    Icons.graphic_eq_rounded,
                    color: Color(0xFF7DD3FC),
                    size: 25,
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Sura Subtitle',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (k.mendengar)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF164E63),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.circle,
                            color: Color(0xFF7DD3FC),
                            size: 8,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'LIVE',
                            style: TextStyle(
                              color: Color(0xFFBAE6FD),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    tooltip: 'Keluar dari layar penuh',
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 27,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              Divider(
                color: Colors.white.withValues(alpha: 0.15),
                height: 1,
              ),

              // Isi subtitle
              Expanded(
                child: kosong
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              k.mendengar
                                  ? Icons.graphic_eq_rounded
                                  : Icons.hearing_outlined,
                              color: const Color(0xFF7DD3FC),
                              size: 54,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              k.mendengar
                                  ? 'Menunggu seseorang berbicara...'
                                  : 'Belum ada percakapan',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Subtitle akan muncul di sini',
                              style: TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        controller: _gulir,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height *
                                0.35,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              for (final kalimat in k.kalimat)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 22,
                                  ),
                                  child: Text(
                                    kalimat,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: widget.ukuranTeks,
                                      height: 1.5,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              if (k.sementara.isNotEmpty)
                                Text(
                                  k.sementara,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(0xFF7DD3FC),
                                    fontSize: widget.ukuranTeks,
                                    height: 1.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
              ),

              const SizedBox(height: 12),

              // Panel pengaturan ukuran
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.10),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.format_size_rounded,
                          color: Color(0xFF7DD3FC),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Ukuran teks',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          '${widget.ukuranTeks.round()} px',
                          style: const TextStyle(
                            color: Color(0xFF7DD3FC),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'A',
                          style: TextStyle(
                            color: Color(0xFFCBD5E1),
                            fontSize: 12,
                          ),
                        ),
                        Expanded(
                          child: Slider(
                            value: widget.ukuranTeks,
                            min: 16,
                            max: 40,
                            divisions: 24,
                            label: '${widget.ukuranTeks.round()} px',
                            activeColor: const Color(0xFF38BDF8),
                            inactiveColor: const Color(0xFF475569),
                            onChanged: widget.saatUkuranBerubah,
                          ),
                        ),
                        const Text(
                          'A',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Status dan tombol keluar
              Row(
                children: [
                  Expanded(
                    child: Text(
                      k.mendengar
                          ? 'Subtitle sedang berjalan'
                          : 'Mode layar penuh',
                      style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 12,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.fullscreen_exit_rounded),
                    label: const Text('Kembali'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF7DD3FC),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
