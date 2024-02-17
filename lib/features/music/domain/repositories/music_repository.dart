/// @Author: kevin
/// @Date: 2024-02-17
/// @Description: This file is responsible for creating the MusicRepository interface.
import '../entities/music.dart';

abstract class MusicRepository {
  /// getMusics method is used to get all music from the local storage
  Future<List<Music>> getMusics();

  /// addMusic method is used to add music to the local storage
  Future<void> addMusic(Music music);

  /// deleteMusic method is used to delete music from the local storage
  Future<void> deleteMusic(int id);
}
