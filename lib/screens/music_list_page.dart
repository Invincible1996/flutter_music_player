/// @Author: kevin
/// @Date: 2024-01-05 23:01:39
/// @Description:
import 'dart:io';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:text_scroll/text_scroll.dart';

import '../database/music_db.dart';
import '../extensions/string_extension.dart';
import '../models/music_file.dart';
import '../widgets/circle_avatar_rotate_animation.dart';
import '../widgets/lyrics_view.dart';

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

  List<MusicFile> fileList = [];

  int _playIndex = 0;

  final ScrollController _scrollController = ScrollController();

  double _volume = 1.0;
  final OnAudioQuery _audioQuery = OnAudioQuery();
  //
  final musicDB = MusicDb();

  @override
  void initState() {
    super.initState();
    init();
    getMusicFiles();
    // someName();
  }

  void getMusicFiles() async {
    final res = await musicDB.getMusicFiles();
    print(res);
    if (res.isEmpty) {
      someName();
    } else {
      fileList.addAll(res.map((e) => MusicFile.fromJson(e)).toList());
    }
    setState(() {});
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: const Color(0XFF252525),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('音乐列表', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0XFF303030),
        actions: const [
          // IconButton(
          //   onPressed: () async {
          //     FilePickerResult? result =
          //         await FilePicker.platform.pickFiles(allowMultiple: true);
          //     if (result != null) {
          //       List<File> files =
          //           result.paths.map((path) => File(path!)).toList();

          //       // _inserFilesToDB(files);
          //       setState(() {});
          //     } else {
          //       // User canceled the picker
          //     }
          //   },
          //   icon: const Icon(Icons.file_open, color: Colors.white),
          // )
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
                setState(() {
                  _playIndex = index;
                });
                // player.play();
                player.play(DeviceFileSource(itemModel.path));
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                // height: 60,
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
                    if (itemModel.albumArt != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.memory(
                          itemModel.albumArt!,
                          width: 40,
                        ),
                      ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            itemModel.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            itemModel.artist,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                height: 200,
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: const Text('删除'),
                                      onTap: () {
                                        // confirm delete 数据库
                                        musicDB.deleteMusicFile(itemModel.id);
                                        setState(() {});
                                        Navigator.pop(context);
                                      },
                                    ),
                                    const Divider(
                                      height: 1,
                                    ),
                                    ListTile(
                                      title: const Text('取消'),
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ),
                    )
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
                  if (fileList.isNotEmpty)
                    Expanded(
                      child: Row(
                        children: [
                          // 头像
                          if (fileList[_playIndex].albumArt != null)
                            GestureDetector(
                              onTap: () {
                                // 播放详情页 底部弹出 占满屏幕
                                showBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      color: const Color(0xff252525),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                icon: const Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const Spacer(),
                                              IconButton(
                                                onPressed: () {},
                                                icon: const Icon(
                                                  Icons.more_vert,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          // 旋转的头像动画 旋转的时候头像不变
                                          const Row(
                                            children: [
                                              InfiniteRotationAnimation(),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              // SizedBox(
                                              //   width: 400,
                                              //   height: 400,
                                              //   child: LyricsView(),
                                              // )
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(0.0),
                                        topRight: Radius.circular(0.0)),
                                  ),
                                  backgroundColor: Colors.transparent,
                                );
                              },
                              child: ClipOval(
                                child: Image.memory(
                                  fileList[_playIndex].albumArt!,
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
                                  fileList[_playIndex].title,
                                  mode: TextScrollMode.bouncing,
                                  velocity: const Velocity(
                                      pixelsPerSecond: Offset(150, 0)),
                                  delayBefore:
                                      const Duration(milliseconds: 500),
                                  numberOfReps: 5,
                                  pauseBetween:
                                      const Duration(milliseconds: 50),
                                  style: const TextStyle(color: Colors.green),
                                  textAlign: TextAlign.right,
                                  selectable: true,
                                ),
                                Text(
                                  fileList[_playIndex].artist,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Text(
                          //   fileList[_playIndex].title,
                          //   style: const TextStyle(
                          //     color: Colors.green,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  // const Spacer(),
                  // 上一曲
                  IconButton(
                    onPressed: () {
                      if (_playIndex > 0) {
                        _playIndex--;
                        player
                            .play(DeviceFileSource(fileList[_playIndex].path));
                      }
                    },
                    icon: const Icon(
                      Icons.skip_previous,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        if (player.state == PlayerState.playing) {
                          player.pause();
                        } else {
                          player.play(
                              DeviceFileSource(fileList[_playIndex].path));
                        }
                        setState(() {});
                      },
                      icon: Icon(
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
                  // const Spacer(),
                  if (!Platform.isAndroid)
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
                  if (!Platform.isAndroid)
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

  void _inserFilesToDB(List<File> files) async {
    for (var file in files) {
      await musicDB.createMusicFile(
        {
          'title': file.path.fileNameWithoutExtension,
          'artist': '未知',
          'album': '未知',
          'albumArt':
              'https://bigshot.oss-cn-shanghai.aliyuncs.com/nba/bos.png',
          'path': file.path,
          'createAt': DateTime.now().toString(),
          'updateAt': DateTime.now().toString(),
        },
      );
    }
    getMusicFiles();
  }

  someName() async {
    // request permission
    _audioQuery.permissionsStatus;
    if (await _audioQuery.permissionsStatus()) {
      // Query Audios
      List<SongModel> songs = await _audioQuery.querySongs();

      for (var song in songs) {
        // queryArtwork
        final albumArt =
            await _audioQuery.queryArtwork(song.id, ArtworkType.AUDIO);
        print(albumArt);
        // insert to db
        await musicDB.createMusicFile(
          {
            'title': song.title,
            'artist': song.artist ?? '未知',
            'album': song.album ?? '未知',
            'albumArt': albumArt,
            'path': song.data,
            'createAt': DateTime.now().toString(),
            'updateAt': DateTime.now().toString(),
          },
        );
        // fileList.add(
        //   MusicFile(
        //     id: song.id,
        //     title: song.title,
        //     artist: song.artist ?? '未知',
        //     album: song.album ?? '未知',
        //     albumArt: albumArt,
        //     path: song.data,
        //     createAt: DateTime.now().toString(),
        //   ),
        // );
      }
      getMusicFiles();
      setState(() {});
    } else {
      // request permission
      await _audioQuery.permissionsRequest();
    }
    // Query Audios
    // List<AlbumModel> audios = await _audioQuery.queryAlbums();
    // print(audios);
  }
}
