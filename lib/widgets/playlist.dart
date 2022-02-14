import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_project/widgets/miniPlayer.dart';
import 'package:music_project/widgets/playlistList.dart';
import 'package:on_audio_room/on_audio_room.dart';

class Playlist extends StatefulWidget {
  const Playlist({Key? key}) : super(key: key);

  @override
  State<Playlist> createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  final namecontroller = TextEditingController();
  OnAudioRoom onAudioRoom = OnAudioRoom();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: addingButton(),
      appBar: appBar(),
      body: Column(
        children: [
          favorite(),
          SizedBox(
            height: 30,
          ),
          FutureBuilder<List<PlaylistEntity>>(
              future: (onAudioRoom.queryPlaylists()),
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
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20),
                    itemCount: playlistitems.length,
                    itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => PlaylistList(
                                          play: playlistitems[index].key,
                                          name: playlistitems[index]
                                              .playlistName,
                                        )));
                              },
                              onLongPress: () {
                                Get.defaultDialog(
                                  title: 'Do you want to delete',
                                  middleText: 'Are you sure',
                                  confirm: TextButton(
                                      onPressed: () async {
                                        onAudioRoom.deletePlaylist(
                                            playlistitems[index].key);
                                        Get.back();
                                        setState(() {});
                                      },
                                      child: Text('Confirm')),
                                  cancel: TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Text('Cancel')),
                                );
                              },
                              child: GestureDetector(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/image/playlist.jpg'),
                                          fit: BoxFit.cover)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '${playlistitems[index].playlistName}',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ));
                    },
                  ),
                );
              }),
        ],
      ),
      // bottomNavigationBar: BottomPlaying(),
    );
  }

  playlistAdding(context) {
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
                                  checking();
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

  addingButton() {
    return IconButton(
        onPressed: () {
          playlistAdding(context);
        },
        icon: Icon(
          Icons.playlist_add,
          color: Colors.white,
          size: 40,
        ));
  }

  appBar() {
    return AppBar(
      backgroundColor: Colors.black,
      title: const Text(
        'Playlist',
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: true,
      elevation: 0,
    );
  }

  favorite() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          height: 150,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'assets/image/favorites1.jpeg',
                  ),
                  fit: BoxFit.fill),
              color: Colors.black54,
              borderRadius: BorderRadius.circular(20)),
          child: ListTile(
            title: Text(
              'Favorites',
              style: TextStyle(fontSize: 25),
            ),
            onTap: () {
              Get.toNamed("Favorites");
            },
          )),
    );
  }

  Future<void> checking() async {
    final name = namecontroller.text.trim();
    if (name.isEmpty) {
      return;
    } else {
      onAudioRoom.createPlaylist(name);
      Navigator.pop(context);
      setState(() {});
    }
  }
}
