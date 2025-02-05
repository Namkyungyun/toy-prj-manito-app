import 'package:camellia_manito/hive/hive_db.dart';

class AppLogic {
  Future<void> bootStrap() async {
    await HiveDB.instance.init();
  }
}
