import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player_app/consts/color.dart';
import 'package:music_player_app/consts/text_style.dart';
import 'package:music_player_app/controllers/player_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Player extends StatelessWidget {
  final List<SongModel> data;
  const Player({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<PlayerController>();
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(
              () => Expanded(
                child: Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    height: MediaQuery.of(context).size.height * 1,
                    width: MediaQuery.of(context).size.width * 1,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: QueryArtworkWidget(
                      id: data[controller.playIndex.value].id,
                      type: ArtworkType.AUDIO,
                      artworkHeight: MediaQuery.of(context).size.height * 1,
                      artworkWidth: MediaQuery.of(context).size.width * 1,
                      nullArtworkWidget: const Icon(
                        Icons.music_note,
                        color: whiteColor,
                        size: 48,
                      ),
                    )),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  color: whiteColor,
                ),
                child: Obx(
                  () => Column(
                    children: [
                      Text(
                        data[controller.playIndex.value].displayNameWOExt,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: ourStyle(size: 24, color: bgColor),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Text(
                        data[controller.playIndex.value].artist.toString(),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: ourStyle(size: 17, color: bgColor),
                      ),
                      Obx(
                        () => Row(
                          children: [
                            Text(
                              controller.position.value,
                              style: ourStyle(color: bgColor),
                            ),
                            Expanded(
                                child: Slider(
                                    thumbColor: sliderColor,
                                    inactiveColor: bgColor,
                                    activeColor: sliderColor,
                                    min: const Duration(seconds: 0)
                                        .inSeconds
                                        .toDouble(),
                                    max: controller.max.value,
                                    value: controller.value.value,
                                    onChanged: (newValue) {
                                      controller.changeDurationToSecond(
                                          newValue.toInt());
                                      newValue = newValue;
                                    })),
                            Text(
                              controller.duration.value,
                              style: ourStyle(color: bgDarkColor),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                              onPressed: () {
                                controller.playSong(
                                    data[controller.playIndex.value - 1].uri,
                                    controller.playIndex.value - 1);
                              },
                              icon: const Icon(
                                Icons.skip_previous_rounded,
                                size: 40,
                                color: bgDarkColor,
                              )),
                          Obx(
                            () => CircleAvatar(
                              radius: 35,
                              backgroundColor: bgDarkColor,
                              child: IconButton(
                                onPressed: () {
                                  if (controller.isPlaying.value) {
                                    controller.audioPlayer.pause();
                                    controller.isPlaying(false);
                                  } else {
                                    controller.audioPlayer.play();
                                    controller.isPlaying(true);
                                  }
                                },
                                icon: Transform.scale(
                                  scale: 2.5,
                                  child: controller.isPlaying.value
                                      ? const Icon(
                                          Icons.pause,
                                          color: whiteColor,
                                        )
                                      : const Icon(
                                          Icons.play_arrow_rounded,
                                          color: whiteColor,
                                        ),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                controller.playSong(
                                    data[controller.playIndex.value + 1].uri,
                                    controller.playIndex.value + 1);
                              },
                              icon: const Icon(
                                Icons.skip_next_rounded,
                                size: 40,
                                color: bgDarkColor,
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
