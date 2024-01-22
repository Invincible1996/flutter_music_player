/// @Author: kevin
/// @Date: 2024-01-05 23:01:39
/// @Description:
import 'dart:io';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../extensions/string_extension.dart';

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
  PlayerState playerState = PlayerState.stopped;

  List<File> fileList = [];

  int _playIndex = 0;

  final ScrollController _scrollController = ScrollController();

  double _volume = 1.0;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    // final duration = await
    // player.play(UrlSource(
    //     'https://bigshot.oss-cn-shanghai.aliyuncs.com/music/Hotel%20California%201994.mp3'));

    player.onPlayerStateChanged.listen((state) {
      setState(() {
        playerState = state;
      });
    });

    // 获取进度
    player.onDurationChanged.listen((totalDuration) {
      // print(event.inSeconds);
      duration = totalDuration;
    });

    player.onPositionChanged.listen((position) {
      setState(() {
        this.position = position;
        // 播放完开始播放下一曲
        if (position.inSeconds == duration.inSeconds) {
          if (_playIndex < fileList.length - 1) {
            _playIndex++;
            player
                .play(DeviceFileSource(fileList[_playIndex].path))
                .then((value) => setState(() {}));
          }
        }
      });
    });

    // 从缓存获取fileList
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String>? res = preferences.getStringList('fileList');
    fileList.addAll(res?.map((e) => File(e)).toList() ?? []);
    // player.setFilePath(fileList[_playIndex].path);
    // player.play();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: const Color(0XFF252525),
      appBar: AppBar(
        title: const Text('音乐列表', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0XFF303030),
        actions: [
          // 手动清除缓存
          IconButton(
            onPressed: () {
              // show dilaog to confirm

              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('清除缓存'),
                      content: const Text('确定要清除缓存吗？'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('取消'),
                        ),
                        TextButton(
                          onPressed: () async {
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            preferences.remove('fileList');
                            fileList.clear();
                            // 播放时间重置 为0 歌曲停止播放
                            position = Duration.zero;
                            player.stop();
                            setState(() {});
                            Navigator.pop(context);
                          },
                          child: const Text('确定'),
                        ),
                      ],
                    );
                  });
            },
            icon: const Icon(Icons.delete_forever, color: Colors.white),
          ),
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
      body: Container(
        color: const Color(0XFF252525),
        child: ListView.builder(
          controller: _scrollController,
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
                // final duration = await player.setFilePath(itemModel.path);
                setState(() {
                  _playIndex = index;
                });
                // player.play();
                player.play(DeviceFileSource(itemModel.path));
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    color: index.isEven
                        ? const Color(0XFF292929)
                        : const Color(0XFF252525),
                    // borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0XFF303030),
                        offset: Offset(1, 1),
                        blurRadius: 1,
                        spreadRadius: 1,
                      )
                    ]),
                // margin: const EdgeInsets.all(10),
                // height: 60,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _playIndex == index
                        ? const Icon(
                            Icons.volume_down,
                            color: Colors.red,
                          )
                        : Text(
                            '0${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      itemModel.path.fileNameWithoutExtension,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    // if (_playIndex == index)
                    //   const SpinKitWave(
                    //     color: Colors.white,
                    //     size: 30.0,
                    //   ),
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
      bottomNavigationBar: BottomAppBar(
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
            color: Colors.white,
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
                  // Text(
                  //   fileList[_playIndex].path.substring(
                  //       fileList[_playIndex].path.lastIndexOf('/') + 1),
                  //   style: const TextStyle(
                  //     color: Colors.green,
                  //   ),
                  // ),
                  const Spacer(),
                  // 上一曲
                  IconButton(
                    onPressed: () {
                      if (_playIndex > 0) {
                        _playIndex--;
                        player
                            .play(DeviceFileSource(fileList[_playIndex].path));
                        // player.play();
                        // setState(() {});
                      }
                    },
                    icon: const Icon(
                      Icons.skip_previous,
                    ),
                  ),
                  FloatingActionButton(
                      onPressed: () {
                        if (player.state == PlayerState.playing) {
                          player.pause();
                        } else {
                          player.play(
                              DeviceFileSource(fileList[_playIndex].path));
                        }
                        setState(() {});
                      },
                      child: Icon(
                        playerState != PlayerState.playing
                            ? Icons.play_arrow
                            : Icons.pause,
                      )),
                  // 下一曲
                  IconButton(
                    onPressed: () {
                      if (_playIndex < fileList.length - 1) {
                        _playIndex++;
                        player
                            .play(DeviceFileSource(fileList[_playIndex].path));
                        // player.setFilePath(fileList[_playIndex].path);
                        // player.play();
                        setState(() {});
                      }
                    },
                    icon: const Icon(
                      Icons.skip_next,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          _volume = _volume == 0 ? 1 : 0;
                        });
                        player.setVolume(_volume);
                      },
                      icon: Icon(
                        _volume == 0
                            ? Icons.volume_off
                            : Icons.volume_up_rounded,
                      )),
                  SizedBox(
                    width: 120,
                    child: Slider(
                      value: _volume,
                      onChanged: (value) {
                        setState(() {
                          _volume = value;
                        });
                        player.setVolume(_volume);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 6,
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
                timeLabelLocation: TimeLabelLocation.sides,
                onSeek: (duration) {
                  player.seek(duration);
                },
              ),
            ],
          ),
        ),
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

int add(int a, int b) {
  return a + b;
}
