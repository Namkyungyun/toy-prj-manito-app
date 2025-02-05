import 'package:camellia_manito/hive/hive_db.dart';
import 'package:flutter/foundation.dart';

class HomePageViewModel {
  // user list
  final ValueNotifier<List> _users = ValueNotifier([]);
  ValueListenable get userListenable => _users;
  List get user => userListenable.value;

  // game prepare
  final ValueNotifier<bool> _enabledResult = ValueNotifier(false);
  ValueListenable get enabledResultListenable => _enabledResult;
  bool get enabledResult => enabledResultListenable.value;

  //
  void init() {
    // HiveDB.instance.setUser();
    HiveDB.instance.getUsers();
  }

  // get hive user data

  // get enabledResult type
}
