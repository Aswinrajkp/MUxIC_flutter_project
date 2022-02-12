import 'package:get/get.dart';
import 'package:music_project/widgets/playing_screen.dart';

bool play = true;

class PlayingScreenController extends GetxController {
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
}
