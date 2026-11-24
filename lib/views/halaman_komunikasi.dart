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
  final _gulir = ScrollController();

  @override
  void dispose() {
    _gulir.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final k = context.watch<KomunikasiController>();
    final kosong = k.kalimat.isEmpty && k.sementara.isEmpty;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_gulir.hasClients) {
        _gulir.jumpTo(_gulir.position.maxScrollExtent);
      }
    });

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                k.mendengar ? Icons.graphic_eq : Icons.mic_none,
                color: k.mendengar ? BL.sky600 : BL.inkMuted,
              ),
              const SizedBox(width: 8),
              Text(
                k.mendengar ? 'Mendengarkan…' : 'Siap',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: k.mendengar ? BL.sky600 : BL.inkMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: glassCard(),
              child: kosong
                  ? const Text(
                      'Tekan Mulai mendengar. Ucapan lawan bicara muncul di sini.',
                      style: TextStyle(color: BL.inkMuted),
                    )
                  : SingleChildScrollView(
                      controller: _gulir,
                      child: SizedBox(
                        width: double.infinity,
                        child: Text.rich(
                          TextSpan(
                            style: const TextStyle(
                              fontSize: 22,
                              height: 1.4,
                              color: BL.ink,
                            ),
                            children: [
                              for (final kalimat in k.kalimat)
                                TextSpan(text: '$kalimat\n\n'),
                              TextSpan(
                                text: k.sementara,
                                style: const TextStyle(color: BL.inkMuted),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          ),

          if (k.pesan != null) ...[
            const SizedBox(height: 12),
            Text(
              k.pesan!,
              style: const TextStyle(fontSize: 13, color: BL.rose600),
            ),
          ],
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: k.mendengar
                      ? context.read<KomunikasiController>().berhenti
                      : context.read<KomunikasiController>().mulai,
                  icon: Icon(k.mendengar ? Icons.stop : Icons.mic),
                  label: Text(k.mendengar ? 'Berhenti' : 'Mulai mendengar'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    backgroundColor: k.mendengar ? BL.rose600 : BL.sky600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.outlined(
                onPressed: kosong
                    ? null
                    : context.read<KomunikasiController>().hapus,
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Hapus teks',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
