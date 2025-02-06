import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:camellia_manito/hive/hive_db.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class EnrollPageViewModel {
  // image
  final ValueNotifier<dynamic> _imageData = ValueNotifier(null);
  ValueListenable get imageDataListenable => _imageData;
  dynamic get imageData => imageDataListenable.value;

  // name
  String _name = '';
  String get nameData => _name;

  final ValueNotifier<bool> _enabledEnroll = ValueNotifier(false);
  ValueListenable get enabledEnrollListenable => _enabledEnroll;
  bool get enabledEnrollment => enabledEnrollListenable.value;

  void setName(String data) {
    _name = data;
    validateEnrollment();
  }

  void setImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await File(pickedFile.path).readAsBytes();
      final base64String = base64Encode(bytes);

      _imageData.value = base64String;
    }
    validateEnrollment();
  }

  void validateEnrollment() {
    if (nameData.isNotEmpty && imageData.isNotEmpty) {
      _enabledEnroll.value = true;
    } else {
      _enabledEnroll.value = false;
    }
  }

  Future<void> save() async {
    // Hive에 저장
    // var box = Hive.box('userBox');
    var hive = HiveDB.instance;
    List grandma = await hive.getGrandma();
    int randomInt = Random().nextInt(grandma.length - 1); // 난수
    String grandmaData = grandma[randomInt];

    var data = {
      "name": nameData,
      "image": imageData,
      "grandma": grandmaData,
    };

    await hive.deleteOneGrandma(grandmaData);
    await hive.saveUser(data);
  }
}
