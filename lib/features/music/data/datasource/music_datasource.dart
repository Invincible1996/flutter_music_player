/// @Author: kevin
/// @Date: 2024-02-16
/// @Description: Abstract class for music data source
import 'package:flutter_music_player/features/music/data/models/music_model.dart';

abstract class MusicDataSource {
  List<MusicModel> getMusics();
  MusicModel getMusic(int id);
  Future<void> addMusic(MusicModel music);
  Future<void> deleteMusic(int id);
}
