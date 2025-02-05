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

  // set data
  Future<void> setUser() async {
    // 데이터 저장
    box.put('users', 'FlutterUser');
  }

  // read data
  Future<void> getUsers() async {
    // 데이터 불러오기
    String users = box.get('users', defaultValue: 'Unknown');
    print(users); // FlutterUser
  }

  //////////////////////
  /// 🔹 데이터 저장 (새로운 key-value 추가)
  Future<void> saveData(String key, String value) async {
    await box.put(key, value);
    print('저장 완료: $key → $value');
  }

  /// 🔹 데이터 수정 (기존 키에 대한 값 변경)
  Future<void> updateData(String key, String newValue) async {
    if (box.containsKey(key)) {
      await box.put(key, newValue); // 기존 키에 새 값 저장
      print('업데이트 완료: $key → $newValue');
    } else {
      await saveData(key, newValue);
    }
  }

  /// 🔹 데이터 삭제 (해당 key 제거)
  Future<void> deleteData(String key) async {
    var box = Hive.box('myBox');

    if (box.containsKey(key)) {
      await box.delete(key);
      print('삭제 완료: $key');
    } else {
      print('삭제 실패: $key 없음');
    }
  }

  /// 🔹 데이터 불러오기 (저장된 값 가져오기)
  Future<void> loadData(String key) async {
    String? value = box.get(key);

    if (value != null) {
      print('불러오기 완료: $key → $value');
    } else {
      print('불러오기 실패: $key 없음');
    }
  }
}
