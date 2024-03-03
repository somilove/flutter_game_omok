import 'package:just_audio/just_audio.dart';

final player = AudioPlayer();
Future audioPlayer(parm_mp3) async {
  await player.setAsset(parm_mp3);
  player.play();
}