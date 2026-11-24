import 'package:speech_to_text/speech_to_text.dart';

class LayananStt {
  final SpeechToText _stt = SpeechToText();

  bool get sedangMendengar => _stt.isListening;

  Future<bool> siapkan({
    required void Function(String status) saatStatus,
    required void Function(String galat) saatGalat,
  }) {
    return _stt.initialize(
      onStatus: saatStatus,
      onError: (e) => saatGalat(e.errorMsg),
    );
  }

  Future<String?> cariLocaleIndonesia() async {
    final daftar = await _stt.locales();
    for (final l in daftar) {
      final kode = l.localeId.toLowerCase().replaceAll('-', '_');
      if (kode == 'id_id') return l.localeId;
    }
    return null;
  }

  Future<void> mulai({
    required String? localeId,
    required void Function(String teks, bool akhir) saatHasil,
  }) {
    return _stt.listen(
      onResult: (r) => saatHasil(r.recognizedWords, r.finalResult),
      localeId: localeId,
      listenFor: const Duration(minutes: 1),
      pauseFor: const Duration(seconds: 4),
      listenOptions: SpeechListenOptions(
        partialResults: true,
        listenMode: ListenMode.dictation,
      ),
    );
  }

  Future<void> berhenti() => _stt.stop();
}
