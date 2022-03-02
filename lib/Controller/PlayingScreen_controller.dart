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

  changeState() {
    play = true;
    update();
  }

  updation() {
    update();
  }

  suffleChanging(){
    suffle = !suffle;
    update();
    print(suffle);
  }
  repeatChanging(){
    repeat = !repeat;
    update();
    print(repeat);
  }


}
