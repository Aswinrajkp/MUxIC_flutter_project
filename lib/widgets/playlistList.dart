import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_project/widgets/home.dart';
import 'package:music_project/widgets/playing_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';

class PlaylistList extends StatefulWidget {
  final play;
  final name;
  const PlaylistList({Key? key, required this.play, required this.name})
      : super(key: key);

  @override
  _PlaylistListState createState() => _PlaylistListState();
}

class _PlaylistListState extends State<PlaylistList> {
  OnAudioRoom audioRoom = OnAudioRoom();
  OnAudioQuery audioQuery = OnAudioQuery();
  List<Audio> playableList = [];
  List<SongModel> song = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.redAccent.shade700,
          title: Text('${widget.name}'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  songAdding(widget.play);
                },
                icon: Icon(Icons.add))
          ],
        ),
        body: FutureBuilder<List<SongEntity>>(
          future: OnAudioRoom().queryAllFromPlaylist(widget.play),
          builder: (context, item) {
            List<SongEntity>? playlist = item.data;
            if (playlist == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (playlist.isEmpty) {
              return Center(
                child: Text(
                  'no song found',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            return ListView.builder(
              itemCount: playlist.length,
              itemBuilder: (BuildContext context, int index) {
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
                      playlist[index].title,
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: TextButton(
                        onPressed: () async {
                          Get.defaultDialog(
                            title: 'Do you want to delete',
                            middleText: 'Are you sure',
                            confirm: TextButton(
                                onPressed: () async {
                                  await audioRoom.deleteFrom(
                                      RoomType.PLAYLIST, playlist[index].id,
                                      playlistKey: widget.play);
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
                        child: Text(
                          'Remove',
                          style: TextStyle(color: Colors.white),
                        )),
                    onTap: () {
                      for (var item in playlist) {
                        playableList.add(Audio.file(item.lastData,
                            metas: Metas(
                              id: item.id.toString(),
                              title: item.title,
                            )));
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                Music(count: index, audio: playableList,songs: miniPlayList,)));
                      }
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  songAdding(playlistkey) {
    return Get.bottomSheet(BottomSheet(
        onClosing: () {
          // setState(() {});
        },
        backgroundColor: Colors.black,
        builder: (context) {
          return FutureBuilder<List<SongModel>>(
              future: audioQuery.querySongs(
                sortType: null,
                orderType: OrderType.ASC_OR_SMALLER,
                uriType: UriType.EXTERNAL,
                ignoreCase: true,
              ),
              builder: (context, item) {
                if (item.data == null)
                  return Center(child: CircularProgressIndicator());
                List<SongModel> songs = item.data!;

                if (item.data!.isEmpty)
                  return Center(
                    child: const Text(
                      "No music found",
                      style: TextStyle(color: Colors.white),
                    ),
                  );

                return ListView.builder(
                  itemCount: item.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(6.0),
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
                          item.data![index].title,
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: IconButton(
                            onPressed: () async {
                              audioRoom.addTo(RoomType.PLAYLIST,
                                  songs[index].getMap.toSongEntity(),
                                  playlistKey: playlistkey,
                                  ignoreDuplicate: false);
                              bool playlistAdded = await audioRoom.checkIn(
                                  RoomType.PLAYLIST, songs[index].id,
                                  playlistKey: widget.play);
                              if (playlistAdded == true) {
                                Get.snackbar(
                                    songs[index].title, " Added to Favorite",
                                    backgroundColor: Colors.white);
                              } else {
                                Get.snackbar(
                                    songs[index].title, "Added to Favorite",
                                    backgroundColor: Colors.white);
                              }
                              setState(() {});
                            },
                            icon:
                                Icon(Icons.playlist_add, color: Colors.white)),
                      ),
                    );
                  },
                );
              });
        }));
  }
}
