enum RouteInfo {
  home(name: 'home', path: '/home'),
  enroll(name: 'enroll', path: '/enroll'),
  game(name: 'game', path: '/game'),
  result(name: 'result', path: '/result');

  const RouteInfo({
    required this.name,
    required this.path,
  });

  final String name;
  final String path;
}
