
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:password_overload/common/utils/utils.dart';
import 'package:password_overload/common/values/values.dart';

/// 全局配置
class Global {

  static bool isFirstOpen = true;

  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();

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