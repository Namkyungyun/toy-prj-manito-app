import 'package:camellia_manito/hive/hive_db.dart';
import 'package:flutter/foundation.dart';

class ResultPageViewModel {
  final ValueNotifier<List> _users = ValueNotifier([]);
  ValueListenable get usersListenable => _users;
  List get users => usersListenable.value;

  final ValueNotifier<List<ValueNotifier<bool>>> _showResult =
      ValueNotifier([]);
  ValueListenable get showResultListenable => _showResult;
  List<ValueNotifier<bool>> get showResult => showResultListenable.value;

  ////////
  /// data
  Map<String, String> _pairUsers = {};
  List resultUsers = [];

  final hive = HiveDB.instance;

  void init() async {
    await fetchUsers();
    await fetchPairUsers();
    await fetchResultData();
  }

  Future<void> fetchUsers() async {
    _users.value = await hive.getUsers();
    setAllShowResult(false);
  }

  Future<void> fetchPairUsers() async {
    _pairUsers = await hive.getPairs();
  }

  Future<void> fetchResultData() async {
    for (var user in users) {
      String name = user['name'];
      String pairName = _pairUsers[name]!;

      var pair = users.where((el) {
        if (el['name'] == pairName) {
          return true;
        }
        return false;
      }).first;

      resultUsers.add(pair);
    }
  }

  void setAllShowResult(bool status) {
    _showResult.value =
        List.generate(users.length, (_) => ValueNotifier(status));
  }

  void setShowResult(int index, bool show) async {
    _showResult.value[index].value = show;
  }
}
