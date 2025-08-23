import 'package:flutter/material.dart';
import 'package:password_overload/common/utils/utils.dart';
import 'package:password_overload/common/values/values.dart';

/// 状态管理：App配置数据
class AppConfig with ChangeNotifier {

  String? userName;

  String get userFirstName => userName!= null && userName!.isNotEmpty ? userName!.substring(0, 1) : '';
  String get userLastName => userName!= null && userName!.isNotEmpty ? userName!.substring(1) : '';

  AppConfig() {
    _fetchUserNameFromLocalStorage();
  }

  Future<void> _fetchUserNameFromLocalStorage() async {
    userName = await StorageHelper().getString(userNameKey);
    notifyListeners();
  }

  void handleChangeUserName(String userName) {
    this.userName = userName;
    notifyListeners();
  }

}