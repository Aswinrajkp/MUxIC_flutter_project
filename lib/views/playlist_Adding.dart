import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_project/Controller/playlistAdding_Controller.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';

class PlaylistAdding extends StatelessWidget {
  PlaylistAdding({Key? key, required this.songDetails, required this.index1})
      : super(key: key);

  final List<SongModel> songDetails;
  final int index1;

  OnAudioRoom audioRoom = OnAudioRoom();
  final namecontroller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool playlistAdded = false;

  @override
  Widget build(BuildContext context) {
    PlaylistAddingController controller = Get.put(PlaylistAddingController());
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black,
          body: GetBuilder<PlaylistAddingController>(builder: (controller) {
            return Column(
              children: [
                TextButton(
                    onPressed: () async {
                      Get.defaultDialog(
                          title: 'Enter Plalist Name',
                          content: Column(
                            children: [
                              Form(
                                key: formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: namecontroller,
                                        validator: (value) {
                                          if (value!.isEmpty || value == null) {
                                            return '*required';
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          confirm: TextButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  controller.checking(
                                      namecontroller, audioRoom);
                                }
                              },
                              child: Text(
                                'Add Playlist',
                                style: TextStyle(color: Colors.green),
                              )));
                    },
                    child: Text(
                      "Add Playlist",
                      style: TextStyle(color: Colors.green, fontSize: 20),
                    )),
                FutureBuilder<List<PlaylistEntity>>(
                    future: (audioRoom.queryPlaylists()),
                    builder: (context, item) {
                      if (item.data == null)
                        return const CircularProgressIndicator();
                      if (item.data!.isEmpty)
                        return Center(
                            child: Text(
                          "No Playlist found!",
                          style: TextStyle(color: Colors.white),
                        ));
                      List<PlaylistEntity> playlistitems = item.data!;
                      return Expanded(
                        child: ListView.builder(
                          itemCount: playlistitems.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ListTile(
                                    onTap: () async {
                                      audioRoom.addTo(
                                          RoomType.PLAYLIST,
                                          songDetails[index1]
                                              .getMap
                                              .toSongEntity(),
                                          playlistKey: playlistitems[index].key,
                                          ignoreDuplicate: false);
                                      Get.back();
                                      playlistAdded = await audioRoom.checkIn(
                                          RoomType.PLAYLIST,
                                          songDetails[index1].id,
                                          playlistKey: item.data![index].key);
                                      if (playlistAdded == false) {
                                        Get.snackbar(songDetails[index1].title,
                                            "  Added to ${playlistitems[index].playlistName} Playlist",
                                            backgroundColor: Colors.white);
                                      } else if (playlistAdded == true) {
                                        Get.snackbar(songDetails[index1].title,
                                            "Added to  ${playlistitems[index].playlistName} Playlist",
                                            backgroundColor: Colors.white);
                                      }
                                    },
                                    title: Text(
                                        playlistitems[index].playlistName,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 22)),
                                  )),
                            );
                          },
                        ),
                      );
                    }),
              ],
            );
          })),
    );
  }

  addingPlaylist(context, controller) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add Playlist'),
            content: Stack(
              children: <Widget>[
                Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: namecontroller,
                          validator: (value) {
                            if (value!.isEmpty || value == null) {
                              return '*required';
                            }
                          },
                        ),
                      ),
                      Row(
                        children: [
                          TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text(
                                'Cancel',
                                style:
                                    TextStyle(color: Colors.redAccent.shade700),
                              )),
                          TextButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  controller.checking(
                                      context, namecontroller, audioRoom);
                                }
                              },
                              child: Text(
                                "Add",
                                style: TextStyle(color: Colors.black),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
