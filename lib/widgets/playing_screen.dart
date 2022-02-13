import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:music_project/Controller/PlayingScreen_controller.dart';
import 'package:music_project/Controller/setting_Screen.dart';
import 'package:music_project/Controller/switch_controll.dart';
import 'package:music_project/widgets/playlist_Adding.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';

List<Audio> miniPlayAudio = [];

class Music extends StatefulWidget {
  final int count;
  final List<Audio> audio;
  final List<SongModel>? songs;

  const Music({Key? key, required this.count,required this.audio, this.songs})
      : super(key: key);

  @override
  State<Music> createState() => _MusicState();
}

class _MusicState extends State<Music> {
  AssetsAudioPlayer player = AssetsAudioPlayer.withId("0");
  final OnAudioRoom onAudioRoom = OnAudioRoom();
  final namecontroller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  PlayingScreenController controller = Get.put(PlayingScreenController());
  SwitchController swichControll = Get.put(SwitchController());
  @override
  void initState() {
    super.initState();
    player.open(
      Playlist(audios: widget.audio, startIndex: widget.count),
      showNotification: swichControll.notify,
      loopMode: LoopMode.playlist,
      autoStart: true,
      notificationSettings: NotificationSettings(
        seekBarEnabled: false,
        stopEnabled: false,
        customPlayPauseAction: (player) {
          if (play == true) {
            player.pause();
            controller.pausing();
          } else {
            player.play();
            controller.playing();
          }
        },
        customNextAction: (player) => controller.changeState(),
        customPrevAction: (player) => controller.changeState(),
      ),
    );
  }

  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }

  @override
  Widget build(BuildContext context) {
    miniPlayAudio = widget.audio!;
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
          body: GetBuilder<PlayingScreenController>(builder: (controller) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                      child: Column(
                    children: [
                      photo(),
                      title(),
                    ],
                  )),
                ),
                GetBuilder<PlayingScreenController>(builder: (controller) {
                  return Container(
                    decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        )),
                    height: MediaQuery.of(context).size.height * .30,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        slider(),
                        controll(),
                        favandlistAdding(),
                      ],
                    ),
                  );
                })
              ],
            );
          }),
        ),
      ),
    );
  }

  favandlistAdding() {
    return player.builderRealtimePlayingInfos(builder: (context, realtime) {
      int index2 = widget.songs!.indexWhere((element) =>
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
                    widget.songs![index2].id,
                  );
                  if (alreadyAdded == true) {
                    Get.snackbar(widget.songs![index2].title,
                        "Already added to Favorite",
                        backgroundColor: Colors.white);
                  } else {
                    Get.snackbar(
                        widget.songs![index2].title, "Added to Favorite",
                        backgroundColor: Colors.white);
                  }
                  onAudioRoom.addTo(
                    RoomType.FAVORITES,
                    widget.songs![index2].getMap.toFavoritesEntity(),
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
                  Get.to(PlaylistAdding(
                      songDetails: widget.songs!, index: index2));
                },
                icon: Icon(Icons.playlist_add),
                iconSize: 30,
                color: Colors.white,
              )
            ],
          ));
    });
  }

  controll() {
    return GetBuilder<PlayingScreenController>(
      builder: (controller) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: () {
                    player.previous();
                    controller.changeState();
                  },
                  icon: Icon(Icons.skip_previous_rounded),
                  iconSize: 60,
                  color: Colors.white),
              IconButton(
                onPressed: () {
                  if (play == true) {
                    player.pause();
                    controller.pausing();
                  } else {
                    player.play();
                    controller.playing();
                  }
                },
                icon: Icon(
                  play == false
                      ? Icons.play_circle_filled_rounded
                      : Icons.pause_circle_filled_rounded,
                  size: 60,
                  color: Colors.white,
                ),
                iconSize: 60,
              ),
              IconButton(
                onPressed: () {
                  player.next(keepLoopMode: true);
                  controller.changeState();
                },
                icon: Icon(Icons.skip_next_rounded),
                iconSize: 60,
                color: Colors.white,
              ),
            ],
          ),
        );
      },
    );
  }

  photo() {
    return player.builderRealtimePlayingInfos(
        builder: (BuildContext context, RealtimePlayingInfos realTimeInfo) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.45,
        width: MediaQuery.of(context).size.width * 0.9,
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
    );
  }

  title() {
    return player.builderRealtimePlayingInfos(builder: (context, realtime) {
      return Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 25),
            child: Center(
              child: Text(
                realtime.current!.audio.audio.metas.title.toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic),
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
