 import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';


class PlaylistAdding extends StatefulWidget {

 final List<SongModel> songDetails;
 final int index;
  const PlaylistAdding({ Key? key ,required this.songDetails,required this.index}) : super(key: key);

  @override
  State<PlaylistAdding> createState() => _PlaylistAddingState();
}

class _PlaylistAddingState extends State<PlaylistAdding> {

OnAudioRoom audioRoom = OnAudioRoom();
final namecontroller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(backgroundColor: Colors.black,
      body: Column(
            children: [
              TextButton(
                  onPressed: () async{
                   await addingPlaylist(context);
                   setState(() {
                     
                   });
                  },
                  child: Text("Add Playlist")),
              FutureBuilder<List<PlaylistEntity>>(
                  future: (audioRoom.queryPlaylists()),
                  builder: (context, item) {
                    if (item.data == null)
                      return const CircularProgressIndicator();
                    if (item.data!.isEmpty)
                      return const Center(
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
                                        widget.songDetails[widget.index]
                                            .getMap
                                            .toSongEntity(),
                                        playlistKey: playlistitems[index].key,
                                        ignoreDuplicate: false);
                                    Get.back();
                                    bool playlistAdded =
                                        await audioRoom.checkIn(
                                            RoomType.PLAYLIST,
                                           widget.songDetails[widget.index].id,
                                            playlistKey: item.data![index].key);
                                    if (playlistAdded == true) {
                                      Get.snackbar(widget.songDetails[widget.index].title,
                                          "Added to ${playlistitems[index].playlistName} PlaylistS",
                                          backgroundColor: Colors.white);
                                    } else {
                                      Get.snackbar(widget.songDetails[widget.index].title,
                                          "Added to  ${playlistitems[index].playlistName} Playlist",
                                          backgroundColor: Colors.white);
                                    }
                                  },
                                  title: Text(playlistitems[index].playlistName,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                )),
                          );
                        },
                      ),
                    );
                  }),
            ],
          )
      ),
    );
  }

  addingPlaylist(context) {
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
                                  style: TextStyle(
                                      color: Colors.redAccent.shade700),
                                )),
                            TextButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    checking(context);
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

  checking(context) {
    final name = namecontroller.text.trim();
    if (name.isEmpty) {
      return;
    } else {
      audioRoom.createPlaylist(name);
      Navigator.pop(context);
      setState(() {});
    }
  }
}


