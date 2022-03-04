import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:music_project/Controller/PlayingScreen_controller.dart';
import 'package:music_project/Controller/switch_controll.dart';
import 'package:music_project/views/playlist_Adding.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';

List<Audio> miniPlayAudio = [];

class Music extends StatelessWidget {
  Music({Key? key, required this.count, required this.audio, this.songs})
      : super(key: key);

  final int count;
  final List<Audio> audio;
  final List<SongModel>? songs;
  PlayingScreenController controller = Get.put(PlayingScreenController());
  SwitchController switchController = Get.put(SwitchController());
  AssetsAudioPlayer player = AssetsAudioPlayer.withId("0");
  final OnAudioRoom onAudioRoom = OnAudioRoom();
  final namecontroller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    PlayingScreenController controller = PlayingScreenController();
    miniPlayAudio = audio;
    return GetBuilder<PlayingScreenController>(initState: (state) {
      player.open(Playlist(audios: audio, startIndex: count),
          showNotification: switchController.notify,
          loopMode: LoopMode.playlist,
          autoStart: true,
          notificationSettings: NotificationSettings(
              seekBarEnabled: false,
              stopEnabled: false,
              customPlayPauseAction: (player) {
                print('Entered');
                if (play == false) {
                  player.pause();
                  print(play);
                  controller.playing();
                } else {
                  player.play();
                  print(play);
                  controller.pausing();
                }
              },
              customNextAction: (player) {
                player.next();
              },
              customPrevAction: (player) {
                player.previous();
              }));
    }, builder: (controller) {
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
            appBar: appBar(),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                      child: Column(
                    children: [
                      photo(size, controller),
                      title(size),
                    ],
                  )),
                ),
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      )),
                  height: MediaQuery.of(context).size.height * .35,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      slider(),
                      controll(context),
                      favandlistAdding(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  favandlistAdding() {
    return player.builderRealtimePlayingInfos(builder: (context, realtime) {
      int index2 = songs!.indexWhere((element) =>
          element.id.toString() ==
          realtime.current!.audio.audio.metas.id.toString());

      return Padding(
          padding: const EdgeInsets.fromLTRB(30, 16, 30, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () async {
                  bool alreadyAdded = await onAudioRoom.checkIn(
                    RoomType.FAVORITES,
                    songs![index2].id,
                  );
                  print(alreadyAdded);
                  if (alreadyAdded == false) {
                    Get.snackbar(songs![index2].title, "Added to Favorite",
                        backgroundColor: Colors.white);
                  } else {
                    Get.snackbar(
                        songs![index2].title, "Already Added to Favorite",
                        backgroundColor: Colors.white);
                  }
                  onAudioRoom.addTo(
                    RoomType.FAVORITES,
                    songs![index2].getMap.toFavoritesEntity(),
                    ignoreDuplicate: false,
                  );
                },
                icon: Icon(
                  Icons.favorite,
                ),
                iconSize: 30,
                color: Colors.white,
              ),
              IconButton(
                onPressed: () {
                  controller.repeatChanging();
                  player.toggleLoop();
                },
                icon: controller.repeat
                    ? Icon(
                        Icons.repeat_rounded,
                        size: 30,
                        color: Colors.redAccent.shade700,
                      )
                    : Icon(
                        Icons.repeat_rounded,
                        size: 30,
                        color: Colors.white,
                      ),
                color: Colors.white,
              ),
              IconButton(
                onPressed: () {
                  Get.to(PlaylistAdding(songDetails: songs!, index1: index2));
                },
                icon: Icon(Icons.playlist_add),
                iconSize: 30,
                color: Colors.white,
              )
            ],
          ));
    });
  }

  controll(context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
              onPressed: () {
                player.previous();
              },
              icon: Icon(Icons.skip_previous_rounded),
              iconSize: 60,
              color: Colors.white),
          player.builderRealtimePlayingInfos(
            builder: (context, realtime) => IconButton(
              onPressed: () {
                if (realtime.isPlaying == true) {
                  player.pause();
                  controller.playing();
                } else {
                  player.play();
                  controller.pausing();
                }
              },
              icon: Icon(
                realtime.isPlaying
                    ? Icons.pause_circle_filled_rounded
                    : Icons.play_circle_filled_rounded,
                size: 60,
                color: Colors.white,
              ),
              iconSize: 60,
            ),
          ),
          IconButton(
            onPressed: () {
              player.next(keepLoopMode: true);
            },
            icon: Icon(Icons.skip_next_rounded),
            iconSize: 60,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  photo(size, controller) {
    return player.builderRealtimePlayingInfos(
        builder: (BuildContext context, RealtimePlayingInfos realTimeInfo) {
      return Container(
        height: size.height * 0.45,
        width: size.width * 0.9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(1000),
          child: QueryArtworkWidget(
            keepOldArtwork: true,
            id: int.parse(
                realTimeInfo.current!.audio.audio.metas.id.toString()),
            type: ArtworkType.AUDIO,
            nullArtworkWidget: Image(
              image: AssetImage('assets/image/default.png'),
              fit: BoxFit.fill,
            ),
          ),
        ),
      );
    });
  }

  appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios_new)),
      actions: [
        IconButton(
          onPressed: () {
            controller.suffleChanging();
            player.toggleShuffle();
          },
          icon: controller.suffle
              ? Icon(
                  Icons.shuffle_rounded,
                  color: Colors.black,
                )
              : Icon(Icons.shuffle_rounded),
          iconSize: 30,
          color: Colors.white,
        ),
      ],
    );
  }

  title(size) {
    return player.builderRealtimePlayingInfos(builder: (context, realtime) {
      return Column(
        children: [
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 25),
            child: Center(
              child: Text(
                realtime.current!.audio.audio.metas.title.toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'patrickHand'),
                maxLines: 1,
                overflow: TextOverflow.clip,
              ),
            ),
          ),
        ],
      );
    });
  }

  slider() {
    return player.builderRealtimePlayingInfos(
        builder: (BuildContext context, RealtimePlayingInfos realTimeInfo) {
      return Column(children: [
        exactSlider(realTimeInfo.currentPosition.inSeconds.toDouble(),
            realTimeInfo.duration.inSeconds.toDouble()),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            player.builderCurrentPosition(builder: (context, duration) {
              return Text(
                getTimeString(duration.inMilliseconds),
                style: TextStyle(color: Colors.white),
              );
            }),
            Text(
              getTimeString(realTimeInfo.duration.inMilliseconds),
              style: TextStyle(color: Colors.white),
            )
          ]),
        )
      ]);
    });
  }

  getTimeString(int milisec) {
    if (milisec == null) milisec = 0;
    String min =
        "${(milisec / 60000).floor() < 10 ? 0 : ''}${(milisec / 60000).floor()}";

    String sce =
        "${(milisec / 1000).floor() % 60 < 10 ? 0 : ''}${(milisec / 1000).floor() % 60}";

    return "$min:$sce";
  }

  exactSlider(double value1, double value2) {
    return Slider.adaptive(
        thumbColor: Colors.redAccent.shade700,
        activeColor: Colors.redAccent.shade700,
        inactiveColor: Colors.white,
        value: value1,
        min: 0,
        max: value2,
        onChanged: (value1) {
          seektosec(value1.toDouble());
        });
  }

  seektosec(double sec) {
    Duration pos = Duration(seconds: sec.toInt());
    player.seek(pos);
  }
}
