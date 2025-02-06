import 'package:camellia_manito/hive/hive_db.dart';
import 'package:flutter/foundation.dart';

class HomePageViewModel {
  // user list
  final ValueNotifier<List> _users = ValueNotifier([]);
  ValueListenable get userListenable => _users;
  List get users => userListenable.value;

  // game prepare
  final ValueNotifier<bool> _enabledResult = ValueNotifier(false);
  ValueListenable get enabledResultListenable => _enabledResult;
  bool get enabledResult => enabledResultListenable.value;

  final hive = HiveDB.instance;
  //
  Future<void> init() async {
    await checkCharacter();
    await fetchUsers();
    await fetchResult();
  }

  Future<void> checkCharacter() async {
    List grandma = await hive.getGrandma();
    if (grandma.isEmpty) {
      await hive.setAllGrandma();
    }
  }

  // get hive user data
  Future<void> fetchUsers() async {
    _users.value = await hive.getUsers();
  }

  // get enabledResult type
  Future<void> fetchResult() async {
    _enabledResult.value = await hive.getResultStatus();
  }

  Future<void> fetchReset() async {
    await hive.reset();
    await init();
  }
}
