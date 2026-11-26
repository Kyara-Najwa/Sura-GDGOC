
import 'package:speech_to_text/speech_to_text.dart';

class LayananStt {
  final SpeechToText _stt = SpeechToText();

  bool get sedangMendengar => _stt.isListening;

  Future<bool> siapkan({
    required void Function(String status) saatStatus,
    required void Function(String galat) saatGalat,
  }) async {
    return await _stt.initialize(
      onStatus: saatStatus,
      onError: (e) => saatGalat(e.errorMsg),
      debugLogging: false,
    );
  }

  Future<String?> cariLocaleIndonesia() async {
    final daftar = await _stt.locales();

    for (final locale in daftar) {
      final kode = locale.localeId.toLowerCase().replaceAll('-', '_');

      if (kode == 'id_id') {
        return locale.localeId;
      }
    }

    return null;
  }

  Future<void> mulai({
    required String? localeId,
    required void Function(String teks, bool akhir) saatHasil,
  }) async {
    await _stt.listen(
      onResult: (hasil) {
        saatHasil(
          hasil.recognizedWords,
          hasil.finalResult,
        );
      },
      listenOptions: SpeechListenOptions(
        localeId: localeId,
        listenFor: const Duration(minutes: 1),
        pauseFor: const Duration(seconds: 4),
        partialResults: true,
        cancelOnError: false,
        listenMode: ListenMode.dictation,
      ),
    );
  }

  Future<void> berhenti() async {
    await _stt.stop();
  }
}
