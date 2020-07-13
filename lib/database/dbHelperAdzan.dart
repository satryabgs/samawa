import 'package:samawa/models/adzanNotification.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
//mendukug pemrograman asinkron
import 'dart:io';
//bekerja pada file dan directory
import 'package:path_provider/path_provider.dart';
//pubspec.yml
//kelass Dbhelper
class DbHelperAdzan {
  static DbHelperAdzan _dbHelperAdzan;
  static Database _database1;  
  DbHelperAdzan._createObject();
  factory DbHelperAdzan() {
    if (_dbHelperAdzan == null) {
      _dbHelperAdzan = DbHelperAdzan._createObject();
    }
    return _dbHelperAdzan;
  }
  Future<Database> initDbAdzan() async {
  //untuk menentukan nama database dan lokasi yg dibuat
    Directory directory = await getApplicationDocumentsDirectory();
    String pathAdzan = directory.path + 'adzan.db';
   //create, read databases
    var todoDatabase1 = openDatabase(pathAdzan, version: 1, onCreate: _createDbAdzan);
    //mengembalikan nilai object sebagai hasil dari fungsinya
    return todoDatabase1;
  }
    //buat tabel baru dengan nama contact
  void _createDbAdzan(Database db, int version) async {
    await db.execute('''
      CREATE TABLE adzan (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        time TEXT,
        date TEXT,
        location TEXT
      )
    ''');
  }
  Future<Database> get database async {
    if (_database1 == null) {
      _database1 = await initDbAdzan();
    }
    return _database1;
  }
  Future<List<Map<String, dynamic>>> select() async {
    Database db = await this.database;
    var mapList = await db.query('adzan', orderBy: 'id');
    return mapList;
  }
//create databases
  Future<int> insert(AdzanNotification object) async {
    Database db = await this.database;
    int count = await db.insert('adzan', object.toMap());
    return count;
  }
//update databases
  Future<int> update(AdzanNotification object) async {
    Database db = await this.database;
    int count = await db.update('adzan', object.toMap(), 
                                where: 'id=?',
                                whereArgs: [object.id]);
    return count;
  }
//delete databases
  Future<int> delete(int id) async {
    Database db = await this.database;
    int count = await db.delete('adzan', 
                                where: 'id=?', 
                                whereArgs: [id]);
    return count;
  }
  Future<List<AdzanNotification>> getAdzanList() async {
    var adzanMapList = await select();
    int count = adzanMapList.length;
    List<AdzanNotification> adzanList = List<AdzanNotification>();
    for (int i=0; i<count; i++) {
      adzanList.add(AdzanNotification.fromMap(adzanMapList[i]));
    }
    return adzanList;
  }
  
}