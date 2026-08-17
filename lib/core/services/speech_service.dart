import 'package:flutter_tts/flutter_tts.dart';

class SpeechService {
  SpeechService._();

  static final SpeechService instance =
      SpeechService._();

  final FlutterTts _tts = FlutterTts();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    await _tts.setLanguage("mr-IN");

    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);

    // Important:
    // wait until one speech finishes before
    // continuing to the next one.
    await _tts.awaitSpeakCompletion(true);

    _initialized = true;
  }

  Future<void> speak(String text) async {
    await initialize();

    await _tts.stop();

    if (text.trim().isEmpty) {
      return;
    }

    await _tts.speak(text);
  }

  Future<void> speakSequence(
    List<String> texts,
  ) async {
    await initialize();

    await _tts.stop();

    for (final text in texts) {
      if (text.trim().isEmpty) {
        continue;
      }

      await _tts.speak(text);
    }
  }

  Future<void> stop() async {
    await _tts.stop();
  }
}