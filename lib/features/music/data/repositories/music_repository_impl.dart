/// @Author: kevin
/// @Date: 2024-02-14
/// @Description: This file is responsible for implementing the MusicRepository interface.
import 'package:flutter_music_player/features/music/data/models/music_model.dart';
import 'package:flutter_music_player/features/music/domain/entities/music.dart';

import '../../domain/repositories/music_repository.dart';
import '../datasource/music_local_datasource.dart';

class MusicRepositoryIpml implements MusicRepository {
  final MusicLocalDatasource localDataSource;

  MusicRepositoryIpml({
    required this.localDataSource,
  });

  @override
  Future<void> addMusic(Music music) {
    return localDataSource.addMusic(
      MusicModel.fromEntity(music),
    );
  }

  @override
  Future<void> deleteMusic(int id) {
    return localDataSource.deleteMusic(id);
  }

  @override
  Future<List<Music>> getMusics() async {
    final res = localDataSource.getMusics();
    return res.map((e) => e.toEntity()).toList();
  }
}
