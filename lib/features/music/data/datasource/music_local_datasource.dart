/// @Author: kevin
/// @Date: 2024-02-16
/// @Description: Local data source for music
import 'package:flutter_music_player/features/music/data/models/music_model.dart';
import 'package:hive/hive.dart';

import 'music_datasource.dart';

class MusicLocalDatasource extends MusicDataSource {
  final Box<MusicModel> musicBox;

  MusicLocalDatasource({
    required this.musicBox,
  });

  @override
  Future<void> addMusic(MusicModel music) {
    return musicBox.add(music);
  }

  @override
  Future<void> deleteMusic(int id) {
    return musicBox.deleteAt(id);
  }

  @override
  MusicModel getMusic(int id) {
    return musicBox.get(id)!;
  }

  @override
  List<MusicModel> getMusics() {
    return musicBox.values.toList();
  }
}
