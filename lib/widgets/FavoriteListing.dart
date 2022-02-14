import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_project/widgets/home.dart';
import 'package:music_project/widgets/playing_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';

class Favorite extends StatefulWidget {
  const Favorite({Key? key}) : super(key: key);

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  final OnAudioRoom audioRoom = OnAudioRoom();
  List<Audio> fav = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.redAccent.shade700,
          elevation: 0,
          title: Text('Favorites'),
          centerTitle: true,
        ),
        body: FutureBuilder<List<FavoritesEntity>>(
          future: OnAudioRoom()
              .queryFavorites(limit: 50, reverse: false, sortType: null),
          builder: (context, item) {
            if (item.data == null)
              return Center(child: const CircularProgressIndicator());
            if (item.data!.isEmpty)
              return Center(
                  child: const Text(
                "No favorites found",
                style: TextStyle(color: Colors.white),
              ));
            List<FavoritesEntity> favorites = item.data!;
            return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                      leading: QueryArtworkWidget(
                          id: item.data![index].id,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: CircleAvatar(
                            radius: 27,
                            backgroundImage: AssetImage(
                              'assets/image/default.png',
                            ),
                          )),
                      title: Text(
                        favorites[index].title,
                        style: TextStyle(color: Colors.white),
                        maxLines: 2,
                      ),
                      trailing: TextButton(
                        child: Text(
                          'Remove',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          Get.defaultDialog(
                            title: 'Do you want to delete',
                            middleText: 'Are you sure',
                            confirm: TextButton(
                                onPressed: () async {
                                  await audioRoom.deleteFrom(
                                    RoomType.FAVORITES,
                                    favorites[index].key,
                                  );
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
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Music(
                                  count: index,
                                  audio: fav,
                                  songs: [],
                                )));
                        for (var list in favorites) {
                          fav.add(Audio.file(list.lastData.toString(),
                              metas: Metas(
                                  title: list.title, id: list.id.toString())));
                        }
                      }),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
