import 'package:get/get.dart';

class PlaylistAddingController extends GetxController{


  


  checking(namecontroller,audioRoom) {
    final name = namecontroller.text.trim();
    if (name.isEmpty) {
      return;
    } else {
      audioRoom.createPlaylist(name);
      Get.back();
      update();
    }
  }
}