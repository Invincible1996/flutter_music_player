/// @Author: kevin
/// @Date: 2024-01-04 19:39:27
/// @Description:
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_music_player/screens/user_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/music_list_page.dart';
import 'screens/setting_page.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({Key? key}) : super(key: key);
  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  // final player = AudioPlayer(); // Create a player

  double duration = 0.0;
  double position = 0.0;

  /// 播放状态
  // ProcessingState playerState = ProcessingState.idle;

  List<File> fileList = [];

  final int _playIndex = -1;

  final int _itemIndex = 0;

  final _pageController = PageController();

  final List<Widget> _pages = [
    const MusicListPage(),
    const SettingPage(),
    const UserPage(),
  ];
  @override
  void initState() {
    super.initState();
    // init();
  }

  // void init() async {
  //   // final duration = await player.setUrl(
  //   //     'https://bigshot.oss-cn-shanghai.aliyuncs.com/music/Hotel%20California%201994.mp3');
  //   // setState(() {
  //   //   this.duration = duration!;
  //   // });
  //   player.durationStream.listen((newDuration) {
  //     if (newDuration != null) {
  //       setState(() {
  //         duration = newDuration.inSeconds.toDouble();
  //       });
  //     }
  //   });
  //   // 监听播放进度
  //   player.positionStream.listen((position) {
  //     // 在这里处理播放进度更新
  //     setState(() {
  //       this.position = position.inSeconds.toDouble();
  //     });
  //   });
  //   // 监听播放状态
  //   player.playerStateStream.listen((state) {
  //     // 如果当前的播放完了，就切换下一首
  //     if (state.processingState == ProcessingState.completed) {
  //       if (_playIndex < fileList.length - 1) {
  //         _playIndex++;
  //         player.setFilePath(fileList[_playIndex].path);
  //         player.play();
  //       }
  //     }
  //     // 在这里处理播放状态更新
  //     setState(() {
  //       playerState = state.processingState;
  //     });
  //   });
  //   // 从缓存获取fileList
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   List<String>? res = preferences.getStringList('fileList');
  //   fileList.addAll(res?.map((e) => File(e)).toList() ?? []);
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF173e66),
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   title: const Text('音乐播放器'),
      //   actions: [
      //     IconButton(
      //       onPressed: () async {
      //         FilePickerResult? result =
      //             await FilePicker.platform.pickFiles(allowMultiple: true);

      //         if (result != null) {
      //           List<File> files =
      //               result.paths.map((path) => File(path!)).toList();
      //           fileList.addAll(files);
      //           // 路径存储到缓存中
      //           SharedPreferences preferences =
      //               await SharedPreferences.getInstance();
      //           preferences.setStringList(
      //               'fileList', fileList.map((e) => e.path).toList());
      //           setState(() {});
      //         } else {
      //           // User canceled the picker
      //         }
      //       },
      //       icon: const Icon(
      //         Icons.upload_file,
      //       ),
      //     )
      //   ],
      // ),
      body: PageView.builder(
        itemCount: _pages.length,
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        itemBuilder: (_, index) {
          return _pages[index];
        },
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _itemIndex,
      //   onTap: (index) {
      //     setState(() {
      //       _itemIndex = index;
      //     });
      //     _pageController.jumpToPage(index);
      //   },
      //   type: BottomNavigationBarType.fixed,
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.music_video), label: '播放列表'),
      //     BottomNavigationBarItem(icon: Icon(Icons.settings), label: '设置'),
      //     BottomNavigationBarItem(icon: Icon(Icons.info), label: '关于'),
      //   ],
      // ),
      // body: ListView.builder(
      //     itemCount: fileList.length,
      //     itemBuilder: (_, index) {
      //       final itemModel = fileList[index];
      //       return GestureDetector(
      //         onDoubleTap: () async {
      //           final duration = await player.setFilePath(itemModel.path);
      //           setState(() {
      //             _playIndex = index;
      //             this.duration = duration!.inSeconds.toDouble();
      //           });
      //           player.play();
      //         },
      //         child: Container(
      //           margin: const EdgeInsets.only(
      //             top: 10,
      //             left: 10,
      //             right: 10,
      //           ),
      //           padding: const EdgeInsets.all(10),
      //           height: 60,
      //           alignment: Alignment.centerLeft,
      //           decoration: BoxDecoration(
      //             color: _playIndex == index ? Colors.indigo : Colors.white,
      //             borderRadius: BorderRadius.circular(10),
      //             boxShadow: const [
      //               BoxShadow(
      //                 color: Colors.white,
      //                 offset: Offset(1, 1),
      //                 blurRadius: 1,
      //                 spreadRadius: 1,
      //               ),
      //             ],
      //           ),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               Text(
      //                 itemModel.path
      //                     .substring(itemModel.path.lastIndexOf('/') + 1),
      //                 style: TextStyle(
      //                   color:
      //                       _playIndex == index ? Colors.white : Colors.black,
      //                 ),
      //               ),
      //               if (_playIndex == index)
      //                 const SpinKitWave(
      //                   color: Colors.white,
      //                   size: 30.0,
      //                 ),
      //             ],
      //           ),
      //         ),
      //       );
      //     }),
      // bottomNavigationBar: BottomAppBar(
      //   padding: EdgeInsets.zero,
      //   child: Container(
      //     // width: double.infinity,
      //     alignment: Alignment.center,
      //     width: MediaQuery.of(context).size.width,
      //     padding: const EdgeInsets.symmetric(
      //       horizontal: 10,
      //     ),
      //     decoration: BoxDecoration(
      //       color: Colors.indigo.shade100,
      //       borderRadius: BorderRadius.circular(10),
      //     ),
      //     child: Column(
      //       children: [
      //         Row(
      //           // mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             IconButton(
      //               onPressed: () {
      //                 // player.play();
      //                 if (!player.playing) {
      //                   player.play();
      //                 } else {
      //                   player.pause();
      //                 }
      //               },
      //               icon: Icon(
      //                 !player.playing ? Icons.play_arrow : Icons.pause,
      //               ),
      //             ),
      //             if (duration > 0.0)
      //               Expanded(
      //                 child: Slider(
      //                   activeColor: Colors.indigo,
      //                   // max: duration.toDouble(),
      //                   value: calculateProgress(position, duration),
      //                   onChanged: (value) {
      //                     position = value * duration;
      //                     // value 0.0 - 1.0 百分比
      //                     player.seek(Duration(seconds: position.toInt()));
      //                     // setState(() {});
      //                     // player.seek(Duration(seconds: value.toInt()));
      //                   },
      //                 ),
      //               ),
      //             if (duration > 0)
      //               Text(
      //                   '${DateFormat('mm:ss').format(DateTime(0).add(Duration(seconds: position.toInt())))}/ ${DateFormat('mm:ss').format(
      //                 DateTime(0).add(Duration(seconds: duration.toInt())),
      //               )}'),
      //           ],
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }

  double calculateProgress(double position, double duration) {
    if (duration > 0) {
      return position / duration;
    } else {
      return 0.0;
    }
  }
}
