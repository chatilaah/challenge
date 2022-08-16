import 'package:audioplayers/audioplayers.dart';

class FavDing {
  final _audioSource = AssetSource('sounds/ding.wav');
  final _player = AudioPlayer();

  FavDing() {
    _player.setVolume(1);
  }

  /// Cleans up resources.
  void dispose() => _player.dispose();

  /// Plays the ding sound.
  Future<void> play() {
    _player.seek(const Duration(seconds: 0));
    return _player.play(_audioSource);
  }
}
