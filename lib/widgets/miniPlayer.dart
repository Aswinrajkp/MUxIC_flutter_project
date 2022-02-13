import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_project/Controller/PlayingScreen_controller.dart';
import 'package:music_project/widgets/home.dart';
import 'package:music_project/widgets/playing_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

class BottomPlaying extends StatefulWidget {
  const BottomPlaying({Key? key}) : super(key: key);

  static PlayingScreenController controller =
      Get.put(PlayingScreenController());

  @override
  State<BottomPlaying> createState() => _BottomPlayingState();
}

class _BottomPlayingState extends State<BottomPlaying> {
  AssetsAudioPlayer player = AssetsAudioPlayer.withId('0');

  @override
  Widget build(BuildContext context) {
    return player.builderRealtimePlayingInfos(builder: (context, realtime) {
      int index2 = miniPlayList.indexWhere((element) =>
          element.id.toString() ==
          realtime.current!.audio.audio.metas.id.toString());
      return Container(
        child: ListTile(
          leading: miniLeading(),
          title: miniTitle(),
          trailing: miniTrailing(),
          onTap: () {
            // print(miniPlayAudio[index2].metas.title);
            print(index2);
            Get.to(Music(
              audio: [],
              count: index2,
              songs: miniPlayList,
            ));
          },
        ),
        color: Colors.transparent,
        height: 70,
      );
    });
  }

  miniTitle() {
    return player.builderRealtimePlayingInfos(builder: (context, realtime) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 16, 0),
        child: Text(
          realtime.current!.audio.audio.metas.title.toString(),
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    });
  }

  miniLeading() {
    return player.builderRealtimePlayingInfos(
        builder: (BuildContext context, RealtimePlayingInfos realTimeInfo) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(1000),
        child: QueryArtworkWidget(
          keepOldArtwork: true,
          id: int.parse(realTimeInfo.current!.audio.audio.metas.id.toString()),
          type: ArtworkType.AUDIO,
          nullArtworkWidget: Image(image: AssetImage('assets/image/default.png')),
        ),
      );
    });
  }

  miniTrailing() {
    return GetBuilder<PlayingScreenController>(
      builder: (controller) => Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Wrap(
          children: [
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
                size: 35,
                color: Colors.white,
              ),
              iconSize: 35,
            ),
            IconButton(
                onPressed: () {
                  player.next();
                  controller.changeState();
                },
                icon: Icon(
                  Icons.skip_next_rounded,
                  color: Colors.white,
                  size: 30,
                ))
          ],
        ),
      ),
    );
  }
}
