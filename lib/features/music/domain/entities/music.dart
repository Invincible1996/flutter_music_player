/// @Author: kevin
/// @Date: 2024-02-17
/// @Description: Entity for music
import 'dart:typed_data';

class Music {
  final int id;
  final String title;
  final String artist;
  final String album;
  final Uint8List? albumArt;
  final String path;
  final String createAt;
  final String? updateAt;

  Music({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.albumArt,
    required this.path,
    required this.createAt,
    this.updateAt,
  });

  factory Music.fromJson(Map<String, dynamic> json) {
    return Music(
        title: json['title'],
        artist: json['artist'],
        album: json['album'],
        albumArt: json['albumArt'] as Uint8List?,
        path: json['path'],
        id: json['id'],
        createAt: json['createAt'],
        updateAt: json['updateAt']);
  }
}
