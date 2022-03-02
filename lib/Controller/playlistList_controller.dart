import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_room/on_audio_room.dart';

class PlaylistListController extends GetxController {
  delete(audioRoom, id, play) async {
    await audioRoom.deleteFrom(RoomType.PLAYLIST, id, playlistKey: play);
    Get.back();
    update();
  }


adding(audioRoom,songs,playlistkey,play,song)async {
                              audioRoom.addTo(RoomType.PLAYLIST,
                                  songs,
                                  playlistKey: playlistkey,
                                  ignoreDuplicate: false);
                              bool playlistAdded = await audioRoom.checkIn(
                                  RoomType.PLAYLIST, song.id,
                                  playlistKey: play);
                              if (playlistAdded == true) {
                                Get.snackbar(
                                    songs.title, " Added to Playlist",
                                    backgroundColor: Colors.white);
                              } else {
                                Get.snackbar(
                                    songs.title, "Added to Playlist",
                                    backgroundColor: Colors.white);
                              }
                              update();
                            }
}
