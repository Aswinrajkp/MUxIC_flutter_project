import 'package:get/get.dart';
import 'package:music_project/Controller/PlayingScreen_controller.dart';
import 'package:music_project/widgets/home.dart';

class FavoriteController extends GetxController {
  bool value = true;
  switchNotification() {
    value = !value;
    update();
  }

  changeState() {
    play = true;
    update();
  }
}
