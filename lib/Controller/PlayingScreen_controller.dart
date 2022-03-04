import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';

bool play = true;

class PlayingScreenController extends GetxController {
  bool suffle = false;
  bool repeat = false;
  AssetsAudioPlayer player = AssetsAudioPlayer();

  pausing() {
    play = false;
    update();
  }

  playing() {
    play = true;
    update();
  }

  suffleChanging() {
    suffle = !suffle;
    update();
  }

  repeatChanging() {
    repeat = !repeat;
    update();
  }
}
