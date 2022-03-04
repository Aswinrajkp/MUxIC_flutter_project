import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_project/Controller/homeScreen_Controller.dart';
import 'package:music_project/Controller/switch_controll.dart';
import 'package:music_project/widgets/playing_screen.dart';
import 'package:music_project/widgets/playlist_Adding.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';

List<SongModel> miniPlayList = [];

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);

  final namecontroller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final OnAudioQuery audioQuery = OnAudioQuery();
  final OnAudioRoom audioRoom = OnAudioRoom();
  AssetsAudioPlayer player = AssetsAudioPlayer.withId("0");
  List<SongModel> songs = [];
  List<Audio> song = [];
  SwitchController switchController = Get.put(SwitchController());
  FavoriteController controller = Get.put(FavoriteController());

  @override
  Widget build(BuildContext context) {
    FavoriteController controller = Get.put(FavoriteController());
    return SafeArea(
      child: Container(
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
            backgroundColor: Colors.transparent,
            body: Column(children: [
              searchContainer(context),
              Expanded(
                  child: GetBuilder<FavoriteController>(builder: (controller) {
                return FutureBuilder<List<SongModel>>(
                  future: audioQuery.querySongs(sortType: null),
                  builder: (context, item) {
                    if (item.data == null) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (item.data!.isEmpty) {
                      return Center(
                        child: Text(
                          'No music found',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    List<SongModel> songDetails = item.data!;
                    miniPlayList = songDetails;

                    var result = controller.search.isEmpty
                        ? songDetails.toList()
                        : songDetails
                            .where((element) => element.title
                                .toLowerCase()
                                .contains(controller.search.toLowerCase()))
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
                                int resultInd = songDetails.indexWhere(
                                    (element) => element.title
                                        .contains(result[index].title));
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
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'patrickHand',
                                            fontSize: 23),
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
                                                    songDetails[resultInd]
                                                        .title,
                                                    "Already added to Favorite",
                                                    backgroundColor:
                                                        Colors.white);
                                              } else {
                                                Get.snackbar(
                                                    songDetails[resultInd]
                                                        .title,
                                                    "Added to Favorite",
                                                    backgroundColor:
                                                        Colors.white);
                                              }
                                            },
                                            icon: Icon(
                                              Icons.favorite,
                                              color: Colors.white,
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                Get.to(PlaylistAdding(
                                                  songDetails: songDetails,
                                                  index1: resultInd,
                                                ));
                                              },
                                              icon: Icon(Icons.playlist_add,
                                                  color: Colors.white)),
                                        ],
                                      ),
                                      onTap: () {
                                        for (var list in songDetails) {
                                          song.add(
                                              Audio.file(list.uri.toString(),
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

                                        Focus.of(context).unfocus();
                                      }),
                                );
                              });
                            },
                          );
                  },
                );
              })),
            ]),
          )),
    );
  }

  searchContainer(context) {
    return GetBuilder<FavoriteController>(
      builder: (controller) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/image/MusicLogoSplash.png',
                ),
                fit: BoxFit.fitHeight),
            color: Colors.black,
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30),
                bottomLeft: Radius.circular(30)),
          ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * .18,
          child: Padding(
            padding: EdgeInsets.fromLTRB(13, 10, 13, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'MUxIC',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
                TextField(
                    style: TextStyle(color: Colors.white),
                    onChanged: (value) => controller.searching(value),
                    textAlign: TextAlign.start,
                    autocorrect: true,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        borderSide: BorderSide(color: Colors.white, width: 1),
                      ),
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      hoverColor: Colors.white,
                      suffixIcon: Icon(Icons.search),
                      hintText: 'Search...',
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
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
