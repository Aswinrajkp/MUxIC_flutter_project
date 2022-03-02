import 'package:get/get.dart';
import 'package:music_project/Controller/PlayingScreen_controller.dart';
import 'package:on_audio_room/on_audio_room.dart';

class PlaylistController extends GetxController {
  playlistDelete(onAudioRoom, playlistitems) async {
    onAudioRoom.deletePlaylist(playlistitems.key);
    Get.back();
    update();
  }

  checking(namecontroller, audioRoom) {
    final name = namecontroller.text.trim();
    if (name.isEmpty) {
      return;
    } else {
      audioRoom.createPlaylist(name);
      
      Get.back();
      update();
    }
  }

  favoriteDelete(audioRoom, favorites) async {
    await audioRoom.deleteFrom(RoomType.FAVORITES, favorites);
    Get.back();
    update();
  }

  changeState() {
    play = true;
    update();
  }
}
