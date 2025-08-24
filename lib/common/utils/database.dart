import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:password_overload/common/entity/entity.dart';
import 'package:password_overload/common/values/values.dart';

/// Database Helper with CRUD
class DatabaseHelper {
  // singleton 1: 私有构造函数
  DatabaseHelper._internal();
  // singleton 2: 实例化一个静态对象
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  // singleton 3: 读取类实例
  factory DatabaseHelper() => _instance;

  static Database? _db;

  /// Singleton
  Future<Database> get database async {
    if(_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  /// init SQLite Database
  Future<Database> _initDatabase() async {
    // 1. finding a location path for the database.
    // String path = p.join(await getDatabasesPath(), 'password_overload.db');
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    await appDocumentsDir.create(recursive: true);
    String path = p.join(appDocumentsDir.path, AppDatabase.databaseFileName);

    // 2. open database.
    return await openDatabase(// 默认以读写模式打开数据库
      path,
      version: 1,// 执行迁移策略
      onCreate: (Database db, int version) async {
        // 3. Preloading data.
        // method 1: Import an existing SQLite file from assets folder
        // var exists = await databaseExists(path);
        //
        // if (!exists) {
        //   // Should happen only the first time you launch your application
        //   print("Creating new copy from asset");
        //
        //   // Make sure the parent directory exists
        //   try {
        //     await Directory(dirname(path)).create(recursive: true);
        //   } catch (_) {}
        //
        //   // Copy from asset
        //   ByteData data = await rootBundle.load(url.join("assets", "example.db"));
        //   List<int> bytes =
        //   data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        //
        //   // Write and flush the bytes written
        //   await File(path).writeAsBytes(bytes, flush: true);
        //
        // } else {
        //   print("Opening existing database");
        // }

        // method 2: Populate data during onCreate (now)
        // 3.1 database is created, create the table
        await db.execute('''
        CREATE TABLE ${AppDatabase.tableName} (
          ${DBTable.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${DBTable.columnSource} TEXT NOT NULL,
          ${DBTable.columnAccount} TEXT NOT NULL,
          ${DBTable.columnPassword} TEXT NOT NULL,
          ${DBTable.columnNote} TEXT
        )
        ''');
        // 3.2 populate data
        // await db.insert(...);
      },
      onOpen: (Database db) async {
        print('Database current version: ${await db.getVersion()}');
      },
      onConfigure: (Database db) async {
        /// onConfigure是第一个可选的回调函数，会首先被调用，允许执行数据库初始化操作，例如支持级联操作
        // await db.execute("PRAGMA foreign_keys = ON");
      },
    );
  }

  /// close database
  Future close() async => _db?.close();

  /// insert a record -------------------------------------------------------
  Future<PasswordItem> insert(PasswordItem item) async {
    item.id = await _db!.insert(AppDatabase.tableName, item.toMap());
    return item;
  }

  /// delete records, return deleted counts
  Future<int> delete(int id) async {
    return await _db!.delete(
      AppDatabase.tableName,
      where: '${DBTable.columnId} = ?',
      whereArgs: [id],
    );
  }

  /// update records, return updated counts
  Future<int> update(PasswordItem item) async {
    return await _db!.update(
      AppDatabase.tableName,
      item.toMap(),
      where: '${DBTable.columnId} = ?',
      whereArgs: [item.id]
    );
  }

  /// query records
  Future<List<PasswordItem>> queryItems() async {
    List<Map<String, Object?>> maps = await _db!.query(
      AppDatabase.tableName,
      orderBy: '${DBTable.columnSource} ASC'
    );
    return List.generate(maps.length, (i) => PasswordItem.fromMap(maps[i]));
  }

  /// query records by like search
  Future<List<PasswordItem>> queryItemsByAccountOrSourceOrNote(String accountOrSourceOrNote) async {
    List<Map<String, Object?>> maps = await _db!.query(
      AppDatabase.tableName,
      where: '${DBTable.columnAccount} LIKE ? OR ${DBTable.columnSource} LIKE ? OR ${DBTable.columnNote} LIKE ?',
      whereArgs: ['%$accountOrSourceOrNote%', '%$accountOrSourceOrNote%', '%$accountOrSourceOrNote%'],
      orderBy: '${DBTable.columnSource} ASC'
    );
    return List.generate(maps.length, (i) => PasswordItem.fromMap(maps[i]));
  }

  /// query single record
  Future<PasswordItem?> queryItemById(String id) async {
    List<Map<String, Object?>> maps = await _db!.query(
        AppDatabase.tableName,
        where: '${DBTable.columnId} = ?',
        whereArgs: [id],
      orderBy: '${DBTable.columnSource} ASC'
    );
    if (maps.isNotEmpty) {
      return PasswordItem.fromMap(maps.first);
    }
    return null;
  }

}