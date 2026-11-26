
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
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Text(
                                  kalimat,
                                  style: const TextStyle(
                                    fontSize: 20,
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
                                  decoration: BoxDecoration(
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
                              style: const TextStyle(
                                fontSize: 25,
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
                    k.mendengar ? Icons.stop_rounded : Icons.mic_rounded,
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
              mendengar ? Icons.graphic_eq : Icons.hearing_outlined,
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
