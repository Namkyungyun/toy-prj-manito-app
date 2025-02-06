import 'package:camellia_manito/app.dart';
import 'package:camellia_manito/pages/enroll_page%20_viewmodel.dart';
import 'package:camellia_manito/pages/enroll_page.dart';
import 'package:camellia_manito/pages/game_page_viewmodel.dart';
import 'package:camellia_manito/pages/home_page.dart';
import 'package:camellia_manito/pages/game_page.dart';
import 'package:camellia_manito/pages/home_page_viewmodel.dart';
import 'package:camellia_manito/pages/result_page.dart';
import 'package:camellia_manito/pages/result_page_viewmodel.dart';
import 'package:camellia_manito/routes/route_info.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: RouteInfo.home.path,
      name: RouteInfo.home.name,
      builder: (context, state) => Provider(
        create: (_) => HomePageViewModel(),
        child: const HomePage(), // 기존 저장 확인하는 파트
      ),
    ),
    GoRoute(
      path: RouteInfo.enroll.path,
      name: RouteInfo.enroll.name,
      builder: (context, state) => Provider(
        create: (_) => EnrollPageViewModel(),
        child: const EnrollPage(), // 기존 저장 확인하는 파트
      ),
    ),
    GoRoute(
      path: RouteInfo.game.path,
      name: RouteInfo.game.name,
      builder: (context, state) => Provider(
        create: (_) => GamePageViewModel(),
        child: const GamePage(), // 기존 저장 확인하는 파트
      ),
    ),
    GoRoute(
      path: RouteInfo.result.path,
      name: RouteInfo.result.name,
      builder: (context, state) => Provider(
        create: (_) => ResultPageViewModel(),
        child: const ResultPage(), // 기존 저장 확인하는 파트
      ),
    ),
  ],
  initialLocation: RouteInfo.home.path,
  navigatorKey: App.navigatorKey,
);
