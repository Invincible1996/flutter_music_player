/// @Author: kevin
/// @Date: 2024-01-05 23:01:39
/// @Description:
import 'dart:io';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'player_page.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MusicListPage extends StatefulWidget {
  const MusicListPage({Key? key}) : super(key: key);
  @override
  State<MusicListPage> createState() => _MusicListPageState();
}

class _MusicListPageState extends State<MusicListPage>
    with AutomaticKeepAliveClientMixin {
  final player = AudioPlayer(); // Create a player
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  /// 播放状态
  ProcessingState playerState = ProcessingState.idle;

  List<File> fileList = [];

  int _playIndex = 0;
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    // final duration = await
    // player.setUrl(
    //     'https://bigshot.oss-cn-shanghai.aliyuncs.com/music/Hotel%20California%201994.mp3');
    // player.play();
    // setState(() {
    //   this.duration = duration!;
    // });
    // 从fileList中获取第一首歌曲

    player.durationStream.listen((newDuration) {
      if (newDuration != null) {
        setState(() {
          duration = newDuration;
        });
      }
    });
    // 监听播放进度
    player.positionStream.listen((position) {
      // 在这里处理播放进度更新
      setState(() {
        this.position = position;
      });
    });
    // 监听播放状态
    player.playerStateStream.listen((state) {
      // 如果当前的播放完了，就切换下一首
      if (state.processingState == ProcessingState.completed) {
        if (_playIndex < fileList.length - 1) {
          _playIndex++;
          player.setFilePath(fileList[_playIndex].path);
          player.play();
        }
      }
      // 在这里处理播放状态更新
      setState(() {
        playerState = state.processingState;
      });
    });
    // 从缓存获取fileList
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String>? res = preferences.getStringList('fileList');
    fileList.addAll(res?.map((e) => File(e)).toList() ?? []);
    player.setFilePath(fileList[_playIndex].path);
    player.play();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('音乐列表', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0XFF303030),
        actions: [
          IconButton(
            onPressed: () async {
              FilePickerResult? result =
                  await FilePicker.platform.pickFiles(allowMultiple: true);

              if (result != null) {
                List<File> files =
                    result.paths.map((path) => File(path!)).toList();
                fileList.addAll(files);
                // 路径存储到缓存中
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                preferences.setStringList(
                    'fileList', fileList.map((e) => e.path).toList());
                setState(() {});
              } else {
                // User canceled the picker
              }
            },
            icon: const Icon(Icons.file_open, color: Colors.white),
          )
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            color: Colors.white,
            child: ListView.builder(
              itemCount: fileList.length,
              itemBuilder: (_, index) {
                final itemModel = fileList[index];
                return GestureDetector(
                  onTap: () async {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (_) => const PlayerPage(),
                    //     ));
                    final duration = await player.setFilePath(itemModel.path);
                    setState(() {
                      _playIndex = index;
                      this.duration = duration!;
                    });
                    player.play();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        color: const Color(0XFF303030),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0XFF303030),
                            offset: Offset(1, 1),
                            blurRadius: 1,
                            spreadRadius: 1,
                          )
                        ]),
                    margin: const EdgeInsets.all(10),
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          itemModel.path
                              .substring(itemModel.path.lastIndexOf('/') + 1),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        if (_playIndex == index)
                          const SpinKitWave(
                            color: Colors.white,
                            size: 30.0,
                          ),
                        // const Icon(
                        //   Icons.more_vert,
                        //   color: Colors.white,
                        // ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 12,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              // height: 50,
              width: MediaQuery.of(context).size.width * .95,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      offset: const Offset(1, 1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    )
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // IconButton(
                  //   onPressed: () {
                  //     // player.play();
                  //     if (!player.playing) {
                  //       player.play();
                  //     } else {
                  //       player.pause();
                  //     }
                  //   },
                  //   icon: Icon(
                  //     !player.playing ? Icons.play_arrow : Icons.pause,
                  //     size: 20,
                  //   ),
                  // ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 上一曲
                      IconButton(
                        onPressed: () {
                          if (_playIndex > 0) {
                            _playIndex--;
                            player.setFilePath(fileList[_playIndex].path);
                            player.play();
                            setState(() {});
                          }
                        },
                        icon: const Icon(
                          Icons.skip_previous,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (!player.playing) {
                            player.play();
                          } else {
                            player.pause();
                          }
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            !player.playing ? Icons.play_arrow : Icons.pause,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // 下一曲
                      IconButton(
                        onPressed: () {
                          if (_playIndex < fileList.length - 1) {
                            _playIndex++;
                            player.setFilePath(fileList[_playIndex].path);
                            player.play();
                            setState(() {});
                          }
                        },
                        icon: const Icon(
                          Icons.skip_next,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ProgressBar(
                    progress: position,
                    // buffered: const Duration(milliseconds: 2000),
                    total: duration,
                    progressBarColor: Colors.red,
                    baseBarColor: Colors.pink.withOpacity(0.24),
                    bufferedBarColor: Colors.white.withOpacity(0.24),
                    thumbColor: Colors.indigo,
                    barHeight: 3.0,
                    thumbRadius: 5.0,
                    onSeek: (duration) {
                      print('User selected a new time: $duration');
                      player.seek(duration);
                    },
                  ),
                  // if (duration > 0)
                  //   Text(
                  //       '${DateFormat('mm:ss').format(DateTime(0).add(Duration(seconds: position.toInt())))}/ ${DateFormat('mm:ss').format(
                  //     DateTime(0).add(Duration(seconds: duration.toInt())),
                  //   )}'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double calculateProgress(double position, double duration) {
    if (duration > 0) {
      return position / duration;
    } else {
      return 0.0;
    }
  }

  @override
  bool get wantKeepAlive => true;
}
