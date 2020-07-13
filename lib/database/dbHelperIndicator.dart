import 'package:sqflite/sqflite.dart';
import 'dart:async';
//mendukug pemrograman asinkron
import 'dart:io';
//bekerja pada file dan directory
import 'package:path_provider/path_provider.dart';
import '../models/adzanIndicator.dart';

//kelass Dbhelper
class DbHelperIndicator {
  static DbHelperIndicator _dbHelperIndicator;
  static Database _database;  
  DbHelperIndicator._createObject();
  factory DbHelperIndicator() {
    if (_dbHelperIndicator == null) {
      _dbHelperIndicator = DbHelperIndicator._createObject();
    }
    return _dbHelperIndicator;
  }
  Future<Database> initDbIndicator() async {
  //untuk menentukan nama database dan lokasi yg dibuat
    Directory directory = await getApplicationDocumentsDirectory();
    String pathIndicator= directory.path + 'indicator.db';
   //create, read databases
    var todoDatabase = openDatabase(pathIndicator, version: 1, onCreate: _createDbIndicator);
    //mengembalikan nilai object sebagai hasil dari fungsinya
    return todoDatabase;
  }
    //buat tabel baru dengan nama contact
  void _createDbIndicator(Database db, int version) async {
    await db.execute('''
      CREATE TABLE indicator (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        indicator INTEGER
      )
    ''');
  }
  Future<Database> get database async {
    if (_database == null) {
      _database = await initDbIndicator();
    }
    return _database;
  }
  Future<List<Map<String, dynamic>>> select() async {
    Database db = await this.database;
    var mapList = await db.query('indicator', orderBy: 'id');
    return mapList;
  }
//create databases
  Future<int> insert(AdzanIndicator object) async {
    Database db = await this.database;
    int count = await db.insert('indicator', object.toMap());
    return count;
  }
//update databases
  Future<int> update(AdzanIndicator object) async {
    Database db = await this.database;
    int count = await db.update('indicator', object.toMap(), 
                                where: 'id=?',
                                whereArgs: [object.id]);
    return count;
  }
//delete databases
  Future<int> delete(int id) async {
    Database db = await this.database;
    int count = await db.delete('indicator', 
                                where: 'id=?', 
                                whereArgs: [id]);
    return count;
  }
  Future<List<AdzanIndicator>> getIndicatorList() async {
    var indicatorMapList = await select();
    int count = indicatorMapList.length;
    List<AdzanIndicator> indicatorList = List<AdzanIndicator>();
    for (int i=0; i<count; i++) {
      indicatorList.add(AdzanIndicator.fromMap(indicatorMapList[i]));
    }
    return indicatorList;
  }
  
}