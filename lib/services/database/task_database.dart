import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_list_app_offline/models/task_model.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT';
    const intType = 'INTEGER';

    await db.execute('''
      CREATE TABLE ${OfflineTaskModel.tableName} (
        ${OfflineTaskModel.columnId} $idType,
        ${OfflineTaskModel.columnTitle} $textType NOT NULL,
        ${OfflineTaskModel.columnDescription} $textType,
        ${OfflineTaskModel.columnDueDate} $intType,
        ${OfflineTaskModel.columnIsCompleted} $intType NOT NULL
      )
    ''');
  }
}
