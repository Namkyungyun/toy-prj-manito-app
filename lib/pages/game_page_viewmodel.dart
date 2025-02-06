import 'dart:math';

import 'package:camellia_manito/hive/hive_db.dart';
import 'package:camellia_manito/pages/game_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class GamePageViewModel {
  final ValueNotifier<List> _usersData = ValueNotifier([]);
  ValueListenable get usersDataListenable => _usersData;
  List get usersData => usersDataListenable.value;

  final ValueNotifier<List<Ball>> _balls = ValueNotifier([]);
  ValueListenable get ballsListenable => _balls;
  List<Ball> get balls => ballsListenable.value;

  final ValueNotifier<bool> _resultStatus = ValueNotifier(false);
  ValueListenable get resultStatusListenable => _resultStatus;
  bool get resultStatus => resultStatusListenable.value;

  final hive = HiveDB.instance;

  void init() async {
    await fetchUsers();
    _initializeBalls();
    await play();
  }

  Future<void> fetchUsers() async {
    _usersData.value = await hive.getUsers();
  }

  Future<void> play() async {
    await hive.generateGameResult(usersData);
    await Future.delayed(const Duration(seconds: 5));
    await getResult();
  }

  Future<void> getResult() async {
    bool resultStatus = await hive.getResultStatus();
    _resultStatus.value = resultStatus;
  }

  /// 📌 랜덤 공 초기화
  void _initializeBalls() {
    final random = Random();
    for (int i = 0; i < usersData.length; i++) {
      _balls.value.add(
        Ball(
          x: random.nextDouble() * 300,
          y: random.nextDouble() * 500,
          radius: 80, // ✅ 모든 공의 크기를 동일하게 설정 (150)
          dx: random.nextDouble() * 5 - 2.5,
          dy: random.nextDouble() * 5 - 2.5,
          base64Image: usersData[i]["image"],
          borderColor: Color.fromARGB(
              255, // ✅ 랜덤 보더 색상
              random.nextInt(256),
              random.nextInt(256),
              random.nextInt(256)),
        ),
      );
    }
  }
}
