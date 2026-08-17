import 'package:audioplayers/audioplayers.dart';

class AudioService {
  AudioService._();

  static final AudioPlayer _player =
      AudioPlayer();

  static Future<void> play(
    String fileName,
  ) async {
    await _player.stop();

    await _player.play(
      AssetSource(
        'audio/$fileName',
      ),
    );
  }

  static Future<void> stop() async {
    await _player.stop();
  }

  static Future<void> pause() async {
    await _player.pause();
  }
}