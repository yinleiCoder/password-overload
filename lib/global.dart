
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:password_overload/common/utils/utils.dart';
import 'package:password_overload/common/values/values.dart';

/// 全局配置
class Global {

  static bool isFirstOpen = true;

  static DatabaseHelper databaseHelper = DatabaseHelper();

  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Database SQLite
    if(!kIsWeb) {
      // Initialize FFI
      sqfliteFfiInit();
    }
    // Change the default factory. On iOS/Android, if not using sqlite_flutter_lib
    // you can forget this step, it will use the sqlite version avaiable on the system.
    databaseFactory = databaseFactoryFfi;
    // SQLite version: https://github.com/tekartik/sqflite/blob/master/sqflite/doc/version.md
    // my Oppo Phone's SQLite: 3.50.4
    print((await (await databaseHelper.database).rawQuery('SELECT sqlite_version()')).first.values.first);

    await ScreenUtil.ensureScreenSize();
    await StorageHelper().init();

    isFirstOpen = await StorageHelper().getBool(firstOpenKey) ?? true;
    if(isFirstOpen) {
      await StorageHelper().setBool(firstOpenKey, !isFirstOpen);
    }

    if(Platform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  }
}