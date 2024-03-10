import 'package:just_audio/just_audio.dart';

final player = AudioPlayer();
Future audioPlayer(parmMp3) async {
  await player.setAsset(parmMp3);
  player.play();
}