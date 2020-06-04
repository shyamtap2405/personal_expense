import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DbHelper{
static Future<Database> database() async{
 final dbPath= await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath,'Shyam.db'),
    onCreate: (db,version){
     return db.execute('CREATE TABLE Shyam(id TEXT PRIMARY KEY,title TEXT,amount REAL,dateTime TEXT)');
    },version: 1
    );
}

  static Future<void> insert(String table,Map<String,Object> data)async{
   
    
     final db= await DbHelper.database();
    db.insert(table,
    data,
    conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String,dynamic>>> getData(String table) async{
    final db =await DbHelper.database();
    return db.query(table);
  }

  static Future<void> deleteColumn(String table,String id) async{
    final db=await DbHelper.database();
    return db.delete(table,where: 'id=?',whereArgs: [id]);
  }

  
}