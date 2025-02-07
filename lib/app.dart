import 'package:camellia_manito/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_logic.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late AppLogic _appLogic;

  @override
  void initState() {
    super.initState();
    _appLogic = context.read<AppLogic>();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        textTheme: GoogleFonts.nanumPenScriptTextTheme(),
      ),
      routerConfig: router,
    );
  }
}
