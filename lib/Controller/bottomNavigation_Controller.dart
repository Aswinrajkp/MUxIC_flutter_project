import 'package:get/get.dart';
import 'package:music_project/main.dart';

class BottomController extends GetxController {
  void changeTabIndex(int index) {
    selectedIndex = index;
    update();
  }
}
