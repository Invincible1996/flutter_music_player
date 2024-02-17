/// @Author: kevins
/// @Date: 2024-01-05 23:01:39
/// @Description:
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_player/styles/colors.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../database/music_db.dart';
import '../models/music_file.dart';
import '../widgets/custom_bottom_app_bar.dart';
import '../widgets/music_list_item.dart';

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

  int playIndex = 0;

  final ScrollController _scrollController = ScrollController();

  final OnAudioQuery _audioQuery = OnAudioQuery();
  //
  final musicDB = MusicDb();

  // 音乐扫描状态
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    init();
    getMusicFiles();
    // someName();
  }

  void getMusicFiles() async {
    final res = await musicDB.getMusicFiles();
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
          if (playIndex < fileList.length - 1) {
            playIndex++;
            player
                .play(DeviceFileSource(fileList[playIndex].path))
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
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('音乐列表', style: TextStyle(color: Colors.white)),
        backgroundColor: MColors.primary,
        actions: const [
          // search
          IconButton(
            onPressed: null,
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: isScanning
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              color: const Color(0XFF252525),
              child: fileList.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: fileList.length,
                      itemBuilder: (_, index) {
                        final itemModel = fileList[index];
                        return MusicListItem(
                          isPlaying: playIndex == index,
                          index: index,
                          onTap: () {
                            setState(() {
                              playIndex = index;
                            });
                            player.play(DeviceFileSource(itemModel.path));
                          },
                          title: itemModel.title,
                          artist: itemModel.artist,
                          albumArt: itemModel.albumArt,
                          onDelete: () {
                            musicDB.deleteMusicFile(itemModel.id);
                            setState(() {});
                          },
                        );
                      },
                    ),
            ),
      bottomNavigationBar: fileList.isEmpty
          ? Container()
          : CustomBottomAppBar(
              currentPlayingMusic: fileList[playIndex],
              onPrevious: () {
                if (playIndex > 0) {
                  playIndex--;
                  player
                      .play(DeviceFileSource(fileList[playIndex].path))
                      .then((value) => setState(() {}));
                }
              },
              onPlayOrPause: () {
                if (playerState == PlayerState.playing) {
                  player.pause();
                } else {
                  player.resume();
                }
              },
              onNext: () {
                if (playIndex < fileList.length - 1) {
                  playIndex++;
                  player
                      .play(DeviceFileSource(fileList[playIndex].path))
                      .then((value) => setState(() {}));
                }
              },
              playerState: playerState,
              position: position,
              duration: duration,
              player: player,
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

  // void _inserFilesToDB(List<File> files) async {
  //   for (var file in files) {
  //     await musicDB.createMusicFile(
  //       {
  //         'title': file.path.fileNameWithoutExtension,
  //         'artist': '未知',
  //         'album': '未知',
  //         'albumArt':
  //             'https://bigshot.oss-cn-shanghai.aliyuncs.com/nba/bos.png',
  //         'path': file.path,
  //         'createAt': DateTime.now().toString(),
  //         'updateAt': DateTime.now().toString(),
  //       },
  //     );
  //   }
  //   getMusicFiles();
  // }

  someName() async {
    // request permission
    // _audioQuery.permissionsStatus;
    if (await _audioQuery.permissionsStatus()) {
      // Query Audios
      List<SongModel> songs = await _audioQuery.querySongs();

      if (songs.isEmpty) {
        return;
      }

      isScanning = true;

      for (var song in songs) {
        // queryArtwork
        final albumArt =
            await _audioQuery.queryArtwork(song.id, ArtworkType.AUDIO);
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
      }
      isScanning = false;
      getMusicFiles();
      setState(() {});
    } else {
      // request permission
      await _audioQuery.permissionsRequest();
      if (await _audioQuery.permissionsStatus()) {
        // Query Audios
        List<SongModel> songs = await _audioQuery.querySongs();

        if (songs.isEmpty) {
          return;
        }
        // 音乐扫描中
        isScanning = true;
        for (var song in songs) {
          // queryArtwork
          final albumArt =
              await _audioQuery.queryArtwork(song.id, ArtworkType.AUDIO);
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
        }
        // 音乐扫描结束
        isScanning = false;
        getMusicFiles();
        setState(() {});
      }
    }
  }
}
