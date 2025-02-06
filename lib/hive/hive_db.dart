import 'dart:convert';
import 'dart:math';

import 'package:camellia_manito/hive/hive_db_key.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDB {
  HiveDB._();

  /// Singleton instance of MemoryCache.
  static final HiveDB instance = HiveDB._();

  /// Public Constructor
  HiveDB();

  late Box<dynamic> box;

  Future<void> init() async {
    await Hive.initFlutter();
    box = await Hive.openBox('myBox');
  }

  Future<void> reset() async {
    await deleteUsers();
    await setAllGrandma();
    await setResultStatus(false);
    await deletePairs();
  }

  ///////////////////
  // users
  Future<List> getUsers() async {
    String data = await box.get(HiveDbKey.USERS.key, defaultValue: '[]');
    return jsonDecode(data);
  }

  Future<void> saveUser(dynamic newValue) async {
    List users = await getUsers();
    users.add(newValue);

    String newUsers = jsonEncode(users);
    await box.put(HiveDbKey.USERS.key, newUsers);
  }

  Future<void> deleteUsers() async {
    await box.delete(HiveDbKey.USERS.key);
  }

  ///////////////////
  // gradma character
  Future<List> getGrandma() async {
    String data = await box.get(HiveDbKey.GRANDMA.key, defaultValue: '[]');
    return jsonDecode(data);
  }

  Future<void> setAllGrandma() async {
    var data = [];
    for (var i = 0; i < 8; i++) {
      data.add('grandma$i.png');
    }

    await box.put(HiveDbKey.GRANDMA.key, jsonEncode(data));
  }

  Future<void> deleteOneGrandma(String value) async {
    List grandma = await getGrandma();

    if (grandma.contains(value)) {
      grandma.remove(value);
      String remainGrandma = jsonEncode(grandma);

      await box.put(HiveDbKey.GRANDMA.key, remainGrandma);
    }
  }

  ///////////////////
  /// enabled result
  Future<bool> getResultStatus() async {
    String data = await box.get(HiveDbKey.RESULT.key, defaultValue: 'false');
    return jsonDecode(data);
  }

  Future<void> setResultStatus(bool result) async {
    await box.put(HiveDbKey.RESULT.key, '$result');
  }

  //////////////////
  /// game play
  Future<void> generateGameResult(List users) async {
    List result = [];
    List alreadyPairedUsers = [];
    Map<dynamic, List> gameBoard = {};

    // 게임판 세팅 ( 유저 : 유저제외한 리스트 )
    for (var user in users) {
      List list = [...users];
      list.remove(user);

      gameBoard[user] = list;
    }

    // 짝꿍 만들기
    dynamic players = gameBoard.keys;
    for (var me in players) {
      List myBoard = gameBoard[me]!;

      // 이미 짝궁이된 유저는 제외하기
      for (var user in alreadyPairedUsers) {
        if (myBoard.contains(user)) {
          myBoard.remove(user);
        }
      }

      // 랜덤 추출
      int randomInt =
          (myBoard.length > 1) ? Random().nextInt(myBoard.length) : 0;
      var myPair = myBoard[randomInt];

      // 결과 넣기
      var myResult = {me['name']: myPair['name']};
      result.add(myResult);

      // 짝궁이된자 제외 목록에 넣기
      alreadyPairedUsers.add(myPair);
    }

    // pair 저장
    await box.put(HiveDbKey.PAIRS.key, jsonEncode(result));
    // 결과 나옴 저장
    await setResultStatus(true);
  }

  Future<void> deletePairs() async {
    await box.delete(HiveDbKey.PAIRS.key);
  }
}
