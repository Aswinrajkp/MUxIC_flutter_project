import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_project/Controller/playlist_Controller.dart';
import 'package:music_project/views/playlistList.dart';
import 'package:on_audio_room/on_audio_room.dart';

PlaylistController controller = Get.put(PlaylistController());

class Playlist extends StatelessWidget {
  Playlist({Key? key}) : super(key: key);

  final namecontroller = TextEditingController();
  OnAudioRoom onAudioRoom = OnAudioRoom();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    PlaylistController controller = Get.put(PlaylistController());
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: addingButton(),
      appBar: appBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Column(
          children: [
            favorite(),
            SizedBox(
              height: 30,
            ),
            GetBuilder<PlaylistController>(builder: (controller) {
              return FutureBuilder<List<PlaylistEntity>>(
                  future: (onAudioRoom.queryPlaylists()),
                  builder: (context, item) {
                    if (item.data == null)
                      return Center(child: const CircularProgressIndicator());
                    if (item.data!.isEmpty)
                      return Center(
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
                                          name:
                                              playlistitems[index].playlistName,
                                        )));
                              },
                              onLongPress: () {
                                Get.defaultDialog(
                                  title: 'Do you want to delete',
                                  middleText: 'Are you sure',
                                  confirm: TextButton(
                                      onPressed: () =>
                                          controller.playlistDelete(onAudioRoom,
                                              playlistitems[index]),
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
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text(
                                      '${playlistitems[index].playlistName}',
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'patrickHand'),
                                    ),
                                  ),
                                ),
                              ));
                        },
                      ),
                    );
                  });
            }),
          ],
        ),
      ),
    );
  }

  addingButton() {
    return IconButton(
        onPressed: () {
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
                      controller.checking(namecontroller, onAudioRoom);
                      namecontroller.clear();
                    }
                  },
                  child: Text(
                    'Add Playlist',
                    style: TextStyle(color: Colors.green),
                  )));
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
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
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
              style: TextStyle(fontSize: 30),
            ),
            onTap: () {
              Get.toNamed("Favorites");
            },
          )),
    );
  }
}
