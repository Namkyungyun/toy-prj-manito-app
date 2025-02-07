import 'dart:convert';
import 'dart:io';

import 'package:camellia_manito/hive/hive_db_key.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

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
    await clearDirectory();
    await clearUsers();
    await clearPairs();
    await setAllGrandma();
    await setResultStatus(false);
  }

  ///////////////////
  // users
  Future<List> getUsers() async {
    String data = await box.get(HiveDbKey.USERS.key, defaultValue: '[]');
    return jsonDecode(data);
  }

  Future<void> saveUser(dynamic newValue) async {
    // 이미지 파일 저장
    String imageData = newValue['image'];
    String imageName = newValue['name'];
    newValue['image'] = await writeFile(imageName, imageData);

    // 기존 데이터에 유저 넣기
    List users = await getUsers();
    users.add(newValue);

    String newUsers = jsonEncode(users);
    await box.put(HiveDbKey.USERS.key, newUsers);
  }

  Future<void> clearUsers() async {
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
  Future<void> generatePair(List users) async {
    Map<String, String> result = {};
    List alreadyPairedUsers = [];
    Map<dynamic, List> gameBoard = {};

    // 게임판 세팅 ( 유저 : 유저제외한 리스트 )
    users.shuffle();

    for (var user in users) {
      List list = [...users];
      list.remove(user);
      list.shuffle();

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
      var myPair = myBoard[0];

      // 결과 넣기
      String key = me['name'];
      String value = myPair['name'];
      result[key] = value;

      // 짝궁이된자 제외 목록에 넣기
      alreadyPairedUsers.add(myPair);
    }

    // pair 저장
    await box.put(HiveDbKey.PAIRS.key, jsonEncode(result));
    // 결과 나옴 저장
    await setResultStatus(true);
  }

  Future<void> clearPairs() async {
    await box.delete(HiveDbKey.PAIRS.key);
  }

  Future<Map<String, String>> getPairs() async {
    String pairUsers = await box.get(HiveDbKey.PAIRS.key);
    return Map<String, String>.from(jsonDecode(pairUsers));
  }

  ///////
  ///이미지 파일 저장
  Future<String> writeFile(String fileName, String content) async {
    final bytes = base64Decode(content); // Base64 디코딩
    final directory = await getApplicationDocumentsDirectory(); // 저장할 디렉토리 가져오기
    final filePath = '${directory.path}/$fileName.jpg'; // 저장할 파일 경로

    final file = File(filePath);
    await file.writeAsBytes(bytes);

    return filePath;
  }

  Future<void> clearDirectory() async {
    try {
      final directory =
          await getApplicationDocumentsDirectory(); // 저장된 디렉토리 가져오기
      final dir = Directory(directory.path); // 디렉토리 객체 생성

      if (await dir.exists()) {
        dir.listSync().forEach((file) {
          if (file is File) {
            file.deleteSync(); // 파일 삭제
          }
        });
        print("✅ 디렉토리 내 파일 전체 삭제 완료");
      } else {
        print("❌ 디렉토리가 존재하지 않습니다.");
      }
    } catch (e) {
      print("❌ 오류 발생: $e");
    }
  }
}
