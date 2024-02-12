/// @Author: kevin
/// @Date: 2024-02-12 13:07:13
/// @Description:

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_player/models/music_file.dart';
import 'package:flutter_music_player/styles/colors.dart';
import 'package:flutter_music_player/widgets/circle_avatar_rotate_animation.dart';
import 'package:text_scroll/text_scroll.dart';

class CustomBottomAppBar extends StatelessWidget {
  final MusicFile currentPlayingMusic;

  // 上一曲
  final void Function() onPrevious;
  // 播放/暂停
  final void Function() onPlayOrPause;
  // 下一曲
  final void Function() onNext;
  // 播放状态
  final PlayerState playerState;
  // player
  final AudioPlayer player;

  // 当前播放的时间
  final Duration position;
  // 总时间
  final Duration duration;

  const CustomBottomAppBar({
    Key? key,
    required this.currentPlayingMusic,
    required this.onPrevious,
    required this.onPlayOrPause,
    required this.onNext,
    required this.playerState,
    required this.player,
    required this.position,
    required this.duration,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      padding: EdgeInsets.zero,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
          // vertical: 1,
        ),
        height: 100,
        width: MediaQuery.of(context).size.width * .95,
        decoration: BoxDecoration(
          color: MColors.primary,
          // borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              offset: const Offset(1, 1),
              blurRadius: 10,
              spreadRadius: 1,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //当前歌曲的名称
                Expanded(
                  child: Row(
                    children: [
                      // 头像
                      if (currentPlayingMusic.albumArt != null)
                        GestureDetector(
                          onTap: () {},
                          child: ClipOval(
                            child: Image.memory(
                              currentPlayingMusic.albumArt!,
                              width: 40,
                            ),
                          ),
                        ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextScroll(
                              currentPlayingMusic.title,
                              mode: TextScrollMode.bouncing,
                              velocity: const Velocity(
                                  pixelsPerSecond: Offset(150, 0)),
                              delayBefore: const Duration(milliseconds: 500),
                              numberOfReps: 5,
                              pauseBetween: const Duration(milliseconds: 50),
                              style: const TextStyle(color: Colors.green),
                              textAlign: TextAlign.right,
                              selectable: true,
                            ),
                            Text(
                              currentPlayingMusic.artist,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // const Spacer(),
                // 上一曲
                IconButton(
                  onPressed: () {
                    onPrevious();
                  },
                  icon: const Icon(
                    Icons.skip_previous,
                  ),
                  color: Colors.white,
                ),
                IconButton(
                  onPressed: () {
                    onPlayOrPause();
                  },
                  icon: Icon(
                    playerState != PlayerState.playing
                        ? Icons.play_arrow
                        : Icons.pause,
                  ),
                  color: Colors.white,
                ),
                // 下一曲
                IconButton(
                  onPressed: () {
                    onNext();
                  },
                  icon: const Icon(
                    Icons.skip_next,
                  ),
                  color: Colors.white,
                ),
              ],
            ),
            const SizedBox(
              height: 6,
            ),
            ProgressBar(
              progress: position,
              total: duration,
              progressBarColor: Colors.white,
              baseBarColor: Colors.pink.withOpacity(0.24),
              bufferedBarColor: Colors.white.withOpacity(0.24),
              thumbColor: Colors.indigo,
              barHeight: 3.0,
              thumbRadius: 5.0,
              timeLabelLocation: TimeLabelLocation.sides,
              onSeek: (duration) {
                player.seek(duration);
              },
              timeLabelTextStyle: const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
