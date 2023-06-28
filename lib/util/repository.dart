import 'package:connectivity/connectivity.dart';
import 'package:sqflite6/util/progress.dart';
import 'package:sqflite6/util/vocabulary.dart';
import "./local_db.dart";
import 'dart:convert';
import 'package:http/http.dart' as http;

//general pupose function for checking internet connection
Future<bool> isConnected() async {
  ConnectivityResult connectivityResult =
      await Connectivity().checkConnectivity();

  return connectivityResult != ConnectivityResult.none;
}

// a repository class that will be used to save and fetch data from local and backend
class Repository {
  Repository._privateConstructor();
  static final Repository instance = Repository._privateConstructor();
  factory Repository() => instance;
  final DBHelper _dbHelper = DBHelper();

  Future<Map<String, dynamic>>? fetchDataFromLocal() {
    return null;
  }

  Future<int> saveProgressToLocal(Map<String, dynamic> data) async {
    Progress progress = Progress.fromMap(data);
    int id = await _dbHelper.insertProgress(progress);
    return id;
  }

  Future<int> saveProgressToBackend(Map<String, dynamic> data) async {
    // try {
    //   List<dynamic> courseDto) async {
    Progress progress = Progress.fromMap(data);
    try {
      http.Response res = await http.patch(
        Uri.parse("http://10.0.2.2:3000/course-progress/course"),
        body: jsonEncode(progress.toMap()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      //print("plrase say something " + jsonDecode(res.body)["progress"]);
      return res.statusCode;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  Future<Map<String, dynamic>?> fetchProgressFromBackend() async {
    try {
      http.Response res = await http
          .get(Uri.parse("http://10.0.2.2:3000/course-progress/course"));

      if (res.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(res.body);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> saveProgress(Map<String, dynamic> data) async {
    if (await isConnected()) {
      await saveProgressToBackend(data);
    } else {
      await saveProgressToLocal(data);
    }
  }

  Future<int?> saveVocabularyToBackend(Map<String, dynamic> data) async {
    Vocabulary vocabulary = Vocabulary.fromJson(data);
    try {
      http.Response res = await http.post(
        Uri.parse("http://10.0.2.2:3000/course-progress/course"),
        body: jsonEncode(vocabulary.toMap()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      return res.statusCode;
    } catch (e) {}
  }

  Future<int> saveVocabularyToLocal(Map<String, dynamic> data) async {
    Vocabulary vocabulary = Vocabulary.fromJson(data);
    int id = await _dbHelper.insertVocabulary(vocabulary);
    return id;
  }

  Future<void> syncData() async {
    if (await isConnected()) {
      Map<String, dynamic>? data = await fetchDataFromLocal();
      if (data != null) {
        await saveProgressToBackend(data);
      }
      data = await fetchProgressFromBackend();
      if (data != null) {
        await saveProgressToLocal(data);
      }
    }
  }

  Future<void> saveData(Map<String, dynamic> data) async {
    if (await isConnected()) {
      await saveDataToBackend(data);
    } else {
      await saveDataToLocal(data);
    }
  }

  Future<Map<String, dynamic>> fetchData() async {
    if (await isConnected()) {
      return await fetchDataFromBackend() ?? {};
    } else {
      return await fetchDataFromLocal() ?? {};
    }
  }

  Future<void> deleteData() async {
    if (await isConnected()) {
      await saveDataToBackend({});
    } else {
      await saveDataToLocal({});
    }
  }

  Future<void> deleteDataFromBackend() async {
    await saveDataToBackend({});
  }

  Future<void> deleteDataFromLocal() async {
    await saveDataToLocal({});
  }

  Future<void> deleteDataFromBoth() async {
    await deleteDataFromBackend();
    await deleteDataFromLocal();
  }

  Future<void> deleteDataFromBothAndSync() async {
    await deleteDataFromBoth();
    await syncData();
  }

  Future<void> deleteDataFromBackendAndSync() async {
    await deleteDataFromBackend();
    await syncData();
  }
}
