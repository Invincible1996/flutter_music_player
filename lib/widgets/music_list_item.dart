/// @Author: kevin
/// @Date: 2024-02-12 12:54:15
/// @Description:
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_music_player/styles/colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';

class MusicListItem extends StatelessWidget {
  final void Function() onTap;
  final String title;
  final String artist;
  final Uint8List? albumArt;
  final int index;
  // 删除
  final void Function() onDelete;
  // is  playing
  final bool isPlaying;

  const MusicListItem({
    Key? key,
    required this.onTap,
    required this.title,
    required this.artist,
    this.albumArt,
    required this.index,
    required this.onDelete,
    required this.isPlaying,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        // height: 60,
        alignment: Alignment.centerLeft,
        decoration: const BoxDecoration(
          color: MColors.primary,
          boxShadow: [
            BoxShadow(
              color: Color(0XFF303030),
              offset: Offset(1, 1),
              blurRadius: 1,
              spreadRadius: 1,
            )
          ],
        ),
        child: Row(
          children: [
            if (isPlaying)
              Container(
                decoration: const BoxDecoration(),
                child: Lottie.asset(
                  'assets/play.json',
                  width: 40,
                ),
              )
            else if (albumArt != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.memory(
                  albumArt!,
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
                    title,
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
                    artist,
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
                                onDelete();
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
  }
}
