import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Ses efektlerini yöneten sınıf
class SoundManager {
  static final SoundManager _instance = SoundManager._();
  factory SoundManager() => _instance;
  SoundManager._();

  static const String _muteKey = 'sound_muted';

  // Her ses için bağımsız player — birbirini kesmez
  final AudioPlayer _tickPlayer = AudioPlayer();
  final AudioPlayer _correctPlayer = AudioPlayer();
  final AudioPlayer _wrongPlayer = AudioPlayer();
  final AudioPlayer _completePlayer = AudioPlayer();
  final AudioPlayer _timeupPlayer = AudioPlayer();

  bool _muted = false;
  bool get isMuted => _muted;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _muted = prefs.getBool(_muteKey) ?? false;

    await _correctPlayer.setSource(AssetSource('sounds/correct.wav'));
    await _wrongPlayer.setSource(AssetSource('sounds/wrong.wav'));
    await _tickPlayer.setSource(AssetSource('sounds/tick.wav'));
    await _completePlayer.setSource(AssetSource('sounds/complete.wav'));
    await _timeupPlayer.setSource(AssetSource('sounds/timeup.wav'));
  }

  Future<void> toggleMute() async {
    _muted = !_muted;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_muteKey, _muted);
  }

  Future<void> playCorrect() async {
    if (_muted) return;
    await _correctPlayer.stop();
    await _correctPlayer.play(AssetSource('sounds/correct.wav'));
  }

  Future<void> playWrong() async {
    if (_muted) return;
    await _wrongPlayer.stop();
    await _wrongPlayer.play(AssetSource('sounds/wrong.wav'));
  }

  /// Tick sesi — stop çağırmadan çal, üst üste binebilir
  Future<void> playTick() async {
    if (_muted) return;
    await _tickPlayer.play(AssetSource('sounds/tick.wav'));
  }

  Future<void> playComplete() async {
    if (_muted) return;
    await _completePlayer.stop();
    await _completePlayer.play(AssetSource('sounds/complete.wav'));
  }

  Future<void> playTimeUp() async {
    if (_muted) return;
    await _timeupPlayer.stop();
    await _timeupPlayer.play(AssetSource('sounds/timeup.wav'));
  }

  void dispose() {
    _correctPlayer.dispose();
    _wrongPlayer.dispose();
    _tickPlayer.dispose();
    _completePlayer.dispose();
    _timeupPlayer.dispose();
  }
}