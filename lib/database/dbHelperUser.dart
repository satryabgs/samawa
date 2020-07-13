import 'package:sqflite/sqflite.dart';
import 'dart:async';
//mendukug pemrograman asinkron
import 'dart:io';
//bekerja pada file dan directory
import 'package:path_provider/path_provider.dart';
import '../models/user.dart';
//pubspec.yml
//kelass Dbhelper
class DbHelperUser {
  static DbHelperUser _dbHelperUser;
  static Database _database;  
  DbHelperUser._createObject();
  factory DbHelperUser() {
    if (_dbHelperUser == null) {
      _dbHelperUser = DbHelperUser._createObject();
    }
    return _dbHelperUser;
  }
  Future<Database> initDbUser() async {
  //untuk menentukan nama database dan lokasi yg dibuat
    Directory directory = await getApplicationDocumentsDirectory();
    String pathUser = directory.path + 'user.db';
   //create, read databases
    var todoDatabase = openDatabase(pathUser, version: 1, onCreate: _createDbUser);
    //mengembalikan nilai object sebagai hasil dari fungsinya
    return todoDatabase;
  }
    //buat tabel baru dengan nama contact
  void _createDbUser(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        gender INTEGER,
        name TEXT
      )
    ''');
  }
  Future<Database> get database async {
    if (_database == null) {
      _database = await initDbUser();
    }
    return _database;
  }
  Future<List<Map<String, dynamic>>> select() async {
    Database db = await this.database;
    var mapList = await db.query('user', orderBy: 'name');
    return mapList;
  }
//create databases
  Future<int> insert(User object) async {
    Database db = await this.database;
    int count = await db.insert('user', object.toMap());
    return count;
  }
//update databases
  Future<int> update(User object) async {
    Database db = await this.database;
    int count = await db.update('user', object.toMap(), 
                                where: 'id=?',
                                whereArgs: [object.id]);
    return count;
  }
//delete databases
  Future<int> delete(int id) async {
    Database db = await this.database;
    int count = await db.delete('user', 
                                where: 'id=?', 
                                whereArgs: [id]);
    return count;
  }
  Future<List<User>> getUserList() async {
    var userMapList = await select();
    int count = userMapList.length;
    List<User> userList = List<User>();
    for (int i=0; i<count; i++) {
      userList.add(User.fromMap(userMapList[i]));
    }
    return userList;
  }
  
}