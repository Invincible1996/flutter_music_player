import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// @Author: kevin
/// @Date: 2024-02-11
/// @Description:
class DatabaseService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initialize();
    return _database!;
  }

  //fullPath
  Future<String> get fullPath async {
    const name = 'music_player.db';
    final directory = await getExternalStorageDirectory();
    return join(directory!.path, name);
  }

  Future<Database> _initialize() async {
    final path = await fullPath;
    var database = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      singleInstance: true,
    );

    return database;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE music_files(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        artist TEXT NOT NULL,
        album TEXT NOT NULL,
        albumArt BLOB,
        path TEXT NOT NULL,
        createAt TEXT NOT NULL,
        updateAt TEXT
      )
    ''');
  }
}
