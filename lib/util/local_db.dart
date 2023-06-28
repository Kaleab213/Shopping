import "package:path/path.dart";
import "package:sqflite/sqflite.dart";
import 'package:sqflite6/util/progress.dart';
import 'package:sqflite6/util/vocabulary.dart';
import 'package:sqflite6/util/word_of_day.dart';
import 'package:sqflite_common/sqlite_api.dart';
import '../model/shopping_list.dart';
import '../model/list_items.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper.internal();
  DBHelper.internal();
  factory DBHelper() => _instance;

  Database? _db;
  final int version = 1;

  Future<Database> openDb() async {
    if (_db != null) return _db!;
    _db = await openDatabase(
      join(await getDatabasesPath(), "shopping.db"),
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE Progress(id INTEGER PRIMARY KEY, userId TEXT,alphabet INTEGER, sound INTEGER,word INTEGER, sentece INTEGER,paragraph INTEGER)",
        );
        db.execute(
            "CREATE TABLE Vocabulary(id INTEGER PRIMARY KEY, word TEXT, category TEXT, meaning TEXT, description TEXT,)");
        db.execute(
            "CREATE TABLE WordOfTD(id INTEGER PRIMARY KEY, word TEXT, category TEXT, meaning TEXT)");
      },
      version: version,
    );
    return _db!;
  }

  Future testDb() async {
    try {
      _db = await openDb();
      await _db!.execute("INSERT INTO lists VALUES(0,'fruits',1)");
      await _db!.execute(
          "INSERT INTO items VALUES(0,0,'Apples','2 kg','Better if they are green')");

      List lists = await _db!.rawQuery("SELECT * FROM lists");
      List items = await _db!.rawQuery("SELECT * FROM items");
      print(lists[0].toString());
      print(items[0].toString());
    } catch (e) {
      print(e);
    }
  }

  Future<int> insertWordOfDay(WordofDay word) async {
    int id = 0;
    try {
      _db = await openDb();
      id = await _db!.insert(
        "WordOfTD",
        word.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print(e);
    }
    return id;
  }

  Future<int> insertProgress(Progress progress) async {
    int id = 0;
    try {
      _db = await openDb();
      id = await _db!.insert(
        "Progress",
        progress.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print(e);
    }
    return id;
  }

  Future<int> insertVocabulary(Vocabulary vocab) async {
    int id = 0;
    try {
      _db = await openDb();
      id = await _db!.insert(
        "Vocabulary",
        vocab.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print(e);
    }
    return id;
  }

  Future<int> deleteProgress(Progress progress) async {
    int result = 0;
    try {
      _db = await openDb();
      result = await _db!.delete(
        "Progress",
        where: "id = ?",
        whereArgs: [progress.id],
      );
    } catch (e) {
      print(e);
    }
    return result;
  }

  Future<int> deleteVocabulary(Progress progress) async {
    int result = 0;
    try {
      _db = await openDb();
      result = await _db!.delete(
        "Vocabulary",
        where: "id = ?",
        whereArgs: [progress.id],
      );
    } catch (e) {
      print(e);
    }
    return result;
  }

  Future<int> deleteWordOfDay(WordofDay word) async {
    int result = 0;
    try {
      _db = await openDb();
      result = await _db!.delete(
        "WordOfTD",
        where: "id = ?",
        whereArgs: [word.id],
      );
    } catch (e) {
      print(e);
    }
    return result;
  }
}
