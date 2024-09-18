import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "kapampangan.db";
  static final _databaseVersion = 1;

  static final tableDictionary = 'dictionary';
  static final tablePhrasebook = 'phrasebook';
  static final tableHistory = 'history';

  static final columnId = '_id';
  static final columnWord = 'word';
  static final columnMeaning = 'meaning';
  static final columnPhrase = 'phrase';
  static final columnTranslation = 'translation';

  // Singleton pattern
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableDictionary (
        $columnId INTEGER PRIMARY KEY,
        $columnWord TEXT NOT NULL,
        $columnMeaning TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tablePhrasebook (
        $columnId INTEGER PRIMARY KEY,
        $columnPhrase TEXT NOT NULL,
        $columnTranslation TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableHistory (
        $columnId INTEGER PRIMARY KEY,
        $columnPhrase TEXT NOT NULL,
        $columnTranslation TEXT NOT NULL
      )
    ''');
  }

  Future<List<Map<String, dynamic>>> getDictionaryWords() async {
    Database? db = await instance.database;
    return await db!.query(tableDictionary);
  }

  Future<List<Map<String, dynamic>>> getPhrasebookPhrases() async {
    Database? db = await instance.database;
    return await db!.query(tablePhrasebook);
  }

  Future<int> insertHistory(String phrase, String translation) async {
    Database? db = await instance.database;
    Map<String, dynamic> row = {
      columnPhrase: phrase,
      columnTranslation: translation,
    };
    return await db!.insert(tableHistory, row);
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    Database? db = await instance.database;
    return await db!.query(tableHistory);
  }
}
