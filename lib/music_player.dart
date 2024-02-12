/// @Author: kevin
/// @Date: 2024-01-04 19:39:27
/// @Description:
import 'package:flutter/material.dart';
import 'package:flutter_music_player/screens/user_page.dart';

import 'screens/music_list_page.dart';
import 'screens/setting_page.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({Key? key}) : super(key: key);
  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  final _pageController = PageController();

  final List<Widget> _pages = [
    const MusicListPage(),
    const SettingPage(),
    const UserPage(),
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF173e66),
      body: PageView.builder(
        itemCount: _pages.length,
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        itemBuilder: (_, index) {
          return _pages[index];
        },
      ),
    );
  }
}
