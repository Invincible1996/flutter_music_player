/// @Author: kevin
/// @Date: 2024-01-23 19:41:17
/// @Description:
import 'dart:io';

import 'package:flutter/material.dart';

class LyricsView extends StatefulWidget {
  const LyricsView({Key? key}) : super(key: key);
  @override
  State<LyricsView> createState() => _LyricsViewState();
}

class _LyricsViewState extends State<LyricsView> {
  List<String> lyrics = [];

  List<(String, String)> lyricsList = [];

  @override
  void initState() {
    super.initState();
    // 读取歌词文件
    File file = File('/Users/kevin/Downloads/17岁-MusicEnc.lrc');
    lyrics = file.readAsStringSync().split('\n');
    // print(file.path);
    // print(lyrics);
    // print(file.readAsStringSync());
    for (var element in lyrics) {
      if (element.contains(']')) {
        var time = element.split(']').first.replaceAll('[', '');
        var content = element.split(']').last;
        lyricsList.add((time, content));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            lyricsList[index].$2,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        );
      },
      itemCount: lyricsList.length,
    );
  }
}
