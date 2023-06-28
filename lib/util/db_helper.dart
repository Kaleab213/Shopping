import "package:path/path.dart";
import "package:sqflite/sqflite.dart";
import 'package:sqflite_common/sqlite_api.dart';
import '../model/shopping_list.dart';
import '../model/list_items.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper.internal();
  DBHelper.internal();
  factory DBHelper() => _instance;

  Database? _db;
  final int version = 1;

  // Future<Database> init() async {
  //   if (_db == null) {
  //     _db = await initDb();
  //   }
  //   return _db!;
  // }

  // initDB() async {
  //   String databasesPath = await getDatabasesPath();
  //   String path = join(databasesPath, "demo.db");
  //   var ourDB = await openDatabase(path, version: 1, onCreate: _onCreate);
  //   return ourDB;
  // }

  Future<Database> openDb() async {
    if (_db != null) return _db!;
    _db = await openDatabase(
      join(await getDatabasesPath(), "shopping.db"),
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE lists(id INTEGER PRIMARY KEY, name TEXT, priority INTEGER)",
        );
        db.execute(
          "CREATE TABLE items(id INTEGER PRIMARY KEY, list_id INTEGER, name TEXT, quantity TEXT, note TEXT, FOREIGN KEY(list_id) REFERENCES lists(id))",
        );
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

  Future<int> insertList(ShoppingList list) async {
    int id = 0;
    try {
      _db = await openDb();
      id = await _db!.insert(
        "lists",
        list.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print(e);
    }
    return id;
  }

  Future<int> insertItem(ListItem item) async {
    int id = 0;
    try {
      _db = await openDb();
      id = await _db!.insert(
        "items",
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print(e);
    }
    return id;
  }

  Future<int> deleteList(ShoppingList list) async {
    int result = 0;
    try {
      _db = await openDb();
      result = await _db!.delete(
        "items",
        where: "idList = ?",
        whereArgs: [list.id],
      );
    } catch (e) {
      print(e);
    }
    return result;
  }

  Future<List<ShoppingList>> getLists() async {
    final List<Map<String, dynamic>> maps = await _db!.query("lists");

    return List.generate(
      maps.length,
      (index) {
        return ShoppingList(
          id: maps[index]["id"],
          name: maps[index]["name"],
          priority: maps[index]["priority"],
        );
      },
    );
  }

  Future<List<ListItem>> getItems(int listId) async {
    final List<Map<String, dynamic>> maps = await _db!.query(
      "items",
      where: "list_id = ?",
      whereArgs: [listId],
    );

    return List.generate(
      maps.length,
      (index) {
        return ListItem(
          id: maps[index]["id"],
          listId: maps[index]["list_id"],
          name: maps[index]["name"],
          quantity: maps[index]["quantity"],
          note: maps[index]["note"],
        );
      },
    );
  }

  Future<int> deleteItem(ListItem item) async {
    int result = 0;
    try {
      _db = await openDb();
      result = await _db!.delete(
        "items",
        where: "id = ?",
        whereArgs: [item.id],
      );
    } catch (e) {
      print(e);
    }
    return result;
  }
}

  // void _onCreate(Database db, int version) async {
  //   await db.execute(
  //       "CREATE TABLE User(id INTEGER PRIMARY KEY, username TEXT, password TEXT)");
  //   print("Table is created");
  // }

  // Future<int> saveUser(User user) async {
  //   var dbClient = await db;
  //   int res = await dbClient.insert("User", user.toMap());
  //   print("Data is inserted");
  //   return res;
  // }

  // Future<List> getAllUsers() async {
  //   var dbClient = await db;
  //   var result = await dbClient.rawQuery("SELECT * FROM User");
  //   return result.toList();
  // }

  // Future<int> getCount() async {
  //   var dbClient = await db;
  //   return Sqflite.firstIntValue(
  //       await dbClient.rawQuery("SELECT COUNT(*) FROM User"));
  // }

  // Future<User> getUser(int id) async {
  //   var dbClient = await db;
  //   var result = await dbClient.rawQuery("SELECT * FROM User WHERE id = $id");
  //   if (result.length == 0) return null;
  //   return User.fromMap(result.first);
  // }

  // Future<int> deleteUser(int id) async {
  //   var dbClient = await db;
  //   return await dbClient.delete("User", where: "id = ?", whereArgs: [id]);
  // }

  // Future<int> updateUser(User user) async {
  //   var dbClient = await db;
  //   return await dbClient
  //       .update("User", user.toMap(), where: "id = ?", whereArgs: [user.id]);
  // }

  // Future close() async {
  //   var dbClient = await db;
  //   return dbClient.close();
  // }
// }
