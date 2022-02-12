import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_project/Controller/PlayingScreen_controller.dart';
import 'package:music_project/Controller/homeScreen_Controller.dart';
import 'package:music_project/Controller/playlist_Screen_Controller.dart';
import 'package:music_project/widgets/miniPlayer.dart';
import 'package:music_project/widgets/playing_screen.dart';
import 'package:music_project/widgets/playlist_Adding.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:on_audio_room/on_audio_room.dart';

List<SongModel> miniPlayList = [];

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  static const List<Widget> widgetOptions = <Widget>[BottomPlaying()];

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final namecontroller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final OnAudioQuery audioQuery = OnAudioQuery();
  final OnAudioRoom audioRoom = OnAudioRoom();
  AssetsAudioPlayer player = AssetsAudioPlayer.withId("0");
  List<SongModel> songs = [];
  List<Audio> song = [];

  @override
  void initState() {
    super.initState();
    gettingSongs();
  }

  gettingSongs() async {
    if (!kIsWeb) {
      bool permissionStatus = await audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await audioQuery.permissionsRequest();
        List<SongModel> gettedSongs = await audioQuery.querySongs();
        songs = gettedSongs;
        setState(() {});
      }
    }
  }

  String search = '';

  @override
  Widget build(BuildContext context) {
    FavoriteController controller = Get.put(FavoriteController());
    PlayListController playListController = Get.put(PlayListController());
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.redAccent.shade700,
            Colors.black,
          ],
        )),
        child: Scaffold(
          extendBodyBehindAppBar: false,
          backgroundColor: Colors.transparent,
          // appBar: appBar(),

          body: Column(children: [
            searchContainer(context),
            Expanded(
                child: FutureBuilder<List<SongModel>>(
              future: audioQuery.querySongs(sortType: null),
              builder: (context, item) {
                if (item.data == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (item.data!.isEmpty) {
                  return Center(
                    child: Text('No music found'),
                  );
                }
                List<SongModel> songDetails = item.data!;
                miniPlayList = songDetails;

                var result = search.isEmpty
                    ? songDetails.toList()
                    : songDetails
                        .where((element) => element.title
                            .toLowerCase()
                            .contains(search.toLowerCase()))
                        .toList();

                return result.isEmpty
                    ? Center(
                        child: Text(
                          'no result found',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : ListView.builder(
                        itemCount: result.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GetBuilder<FavoriteController>(
                              builder: (controller) {
                            int resultInd = songDetails.indexWhere((element) =>
                                element.title.contains(result[index].title));
                            return Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: ListTile(
                                  leading: QueryArtworkWidget(
                                      id: result[index].id,
                                      type: ArtworkType.AUDIO,
                                      nullArtworkWidget: CircleAvatar(
                                        radius: 27,
                                        backgroundImage: AssetImage(
                                          'assets/image/default.png',
                                        ),
                                      )),
                                  title: Text(
                                    result[index].title,
                                    style: TextStyle(color: Colors.white),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: Wrap(
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          controller.switchNotification();
                                          if (controller.value) {
                                            audioRoom.addTo(
                                              RoomType.FAVORITES,
                                              songDetails[resultInd]
                                                  .getMap
                                                  .toFavoritesEntity(),
                                              ignoreDuplicate: false,
                                            );
                                          }
                                          bool alreadyAdded =
                                              await audioRoom.checkIn(
                                            RoomType.FAVORITES,
                                            songDetails[resultInd].id,
                                          );
                                          if (alreadyAdded == true) {
                                            Get.snackbar(
                                                songDetails[resultInd].title,
                                                "Already added to Favorite",
                                                backgroundColor: Colors.white);
                                          } else {
                                            Get.snackbar(
                                                songDetails[resultInd].title,
                                                "Added to Favorite",
                                                backgroundColor: Colors.white);
                                          }
                                        },
                                        icon: Icon(
                                          Icons.favorite,
                                          color: Colors.white,
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            // bottomAdding(
                                            //     songDetails, resultInd);
                                            Get.to(PlaylistAdding(
                                              songDetails: songDetails,
                                              index: resultInd,
                                            ));
                                          },
                                          icon: Icon(Icons.playlist_add,
                                              color: Colors.white)),
                                    ],
                                  ),
                                  onTap: () {
                                    for (var list in songDetails) {
                                      song.add(Audio.file(list.uri.toString(),
                                          metas: Metas(
                                            title: list.title,
                                            id: list.id.toString(),
                                          )));
                                    }
                                    Get.to(Music(
                                      audio: song,
                                      count: resultInd,
                                      songs: songDetails,
                                    ));
                                    // Navigator.of(context)
                                    //     .push(MaterialPageRoute(
                                    //         builder: (context) => Music(
                                    //               count: resultInd,
                                    //               audio: song,
                                    //               songs: songDetails,
                                    //             )));
                                    controller.changeState();
                                    print(index);
                                    print(resultInd);
                                  }),
                            );
                          });
                        },
                      );
              },
            )),
          ]),
          bottomNavigationBar: BottomPlaying(),
        ));
  }

  bool fav = false;

  Icon red = Icon(
    Icons.favorite,
    color: Colors.red,
  );

  Icon white = Icon(
    Icons.favorite,
    color: Colors.white,
  );

  appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: const Text(
        'Music',
        style: TextStyle(
            color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
      ),
    );
  }

  searchContainer(context) {
    return GetBuilder<FavoriteController>(
      builder: (controller) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/image/head.jpg',
                ),
                fit: BoxFit.fitHeight),
            color: Colors.black,
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(50),
                bottomLeft: Radius.circular(50)),
          ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * .18,
          child: Padding(
            padding: EdgeInsets.fromLTRB(13, 25, 13, 0),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'MUxIC',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                  ],
                ),
                TextField(
                    style: TextStyle(color: Colors.white),
                    onChanged: (value) {
                      setState(() {
                        search = value;
                      });
                    },
                    textAlign: TextAlign.start,
                    autocorrect: true,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        borderSide: BorderSide(color: Colors.white, width: 4),
                      ),
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      hoverColor: Colors.white,
                      suffixIcon: Icon(Icons.search),
                      hintText: 'Search...',
                      hintStyle: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w900),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(
                            Radius.circular(50),
                          )),
                    )),
              ],
            ),
          ),
        );
      },
    );
  }
}
