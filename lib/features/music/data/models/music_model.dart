/// @Author: kevin
/// @Date: 2024-02-16
/// @Description: Model for music
import 'dart:typed_data';

import 'package:flutter_music_player/features/music/domain/entities/music.dart';
import 'package:hive/hive.dart';

part 'music_model.g.dart';

@HiveType(typeId: 0)
class MusicModel {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String artist;
  @HiveField(3)
  final String album;
  @HiveField(4)
  final Uint8List? albumArt;
  @HiveField(5)
  final String path;
  @HiveField(6)
  final String createAt;
  @HiveField(7)
  final String? updateAt;

  MusicModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.albumArt,
    required this.path,
    required this.createAt,
    this.updateAt,
  });

  factory MusicModel.fromJson(Map<String, dynamic> json) {
    return MusicModel(
        title: json['title'],
        artist: json['artist'],
        album: json['album'],
        albumArt: json['albumArt'],
        path: json['path'],
        id: json['id'],
        createAt: json['createAt'],
        updateAt: json['updateAt']);
  }

  // convert from Entity to Model
  factory MusicModel.fromEntity(Music music) {
    return MusicModel(
      id: music.id,
      title: music.title,
      artist: music.artist,
      album: music.album,
      albumArt: music.albumArt!,
      path: music.path,
      createAt: music.createAt,
      updateAt: music.updateAt,
    );
  }

  // convert from Model to Entity
  Music toEntity() {
    return Music(
      id: id,
      title: title,
      artist: artist,
      album: album,
      albumArt: albumArt,
      path: path,
      createAt: createAt,
      updateAt: updateAt,
    );
  }
}
