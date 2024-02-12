import 'package:flutter_music_player/database/database_service.dart';

class MusicDb {
  final tableName = 'music_files';

  Future<void> createTable() async {
    final database = await DatabaseService().database;
    await database.execute("""
      CREATE TABLE $tableName IF NOT EXISTS $tableName (
        "id" INTEGER PRIMARY KEY AUTOINCREMENT,
        "title" TEXT NOT NULL,
        "artist" TEXT NOT NULL,
        "album" TEXT NOT NULL,
        "albumArt" TEXT NOT NULL,
        "path" TEXT NOT NULL,
        "createAt" TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
        "updateAt" TEXT
       )
""");
  }

  Future<int> createMusicFile(Map<String, dynamic> musicFile) async {
    final database = await DatabaseService().database;
    return await database.rawInsert("""
INSERT INTO $tableName (title, artist, album, albumArt, path, createAt, updateAt) VALUES (?, ?, ?, ?, ?, ?, ?)
""", [
      musicFile['title'],
      musicFile['artist'],
      musicFile['album'],
      musicFile['albumArt'],
      musicFile['path'],
      musicFile['createAt'],
      musicFile['updateAt']
    ]);
  }

  // 添加多个文件到数据 不使用循环 先拼接好sql语句 然后一次性添加
  Future<void> createMusicFiles(List<Map<String, dynamic>> musicFiles) async {
    final database = await DatabaseService().database;
    final batch = database.batch();
    for (var musicFile in musicFiles) {
      batch.rawInsert("""
INSERT INTO $tableName (title, artist, album, albumArt, path, createAt, updateAt) VALUES (?, ?, ?, ?, ?, ?, ?)
""", [
        musicFile['title'],
        musicFile['artist'],
        musicFile['album'],
        musicFile['albumArt'],
        musicFile['path'],
        musicFile['createAt'],
        musicFile['updateAt']
      ]);
    }
    await batch.commit(noResult: true);
  }

  Future<List<Map<String, dynamic>>> getMusicFiles() async {
    final database = await DatabaseService().database;
    return await database.query(tableName);
  }

  Future<int> updateMusicFile(Map<String, dynamic> musicFile) async {
    final database = await DatabaseService().database;
    return await database.rawUpdate("""
""");
  }

  Future<int> deleteMusicFile(int id) async {
    final database = await DatabaseService().database;
    return await database.rawDelete("""
DELETE FROM $tableName WHERE id = ?
""", [id]);
  }
}
