// ignore_for_file: constant_identifier_names

enum HiveDbKey {
  USERS('users'),
  RESULT('result'),
  GRANDMA('grandma'),
  PAIRS('pairs');

  const HiveDbKey(this.key);
  final String key;
}
