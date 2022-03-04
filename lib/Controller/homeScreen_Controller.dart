import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:music_project/Controller/PlayingScreen_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavoriteController extends GetxController {
  OnAudioQuery audioQuery = OnAudioQuery();
  var songs;
  String search = '';

  searching(String value) {
    search = value;
    update();
  }

  gettingSongs() async {
    try {
      if (!kIsWeb) {
        bool permissionStatus = await audioQuery.permissionsStatus();
        if (!permissionStatus) {
          await audioQuery.permissionsRequest();
          List<SongModel> gettedSongs = await audioQuery.querySongs();
          songs = gettedSongs;
          update();
        }
      }
    } catch (e) {
      print("Song Getting Failed $e");
    }
  }

  bool value = true;
  switchNotification() {
    value = !value;
    update();
  }

  @override
  void onInit() {
    gettingSongs();
    super.onInit();
  }
}
