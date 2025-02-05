import 'package:camellia_manito/app.dart';
import 'package:camellia_manito/app_logic.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appLogic = AppLogic();
  await appLogic.bootStrap();

  runApp(
    MultiProvider(
      providers: [
        Provider(
          create: (context) => appLogic,
        ),
      ],
      child: const App(),
    ),
  );
}
