class NameNotDefined implements Exception {}

class Champion {
  final int _id, _skin;
  final String? _name;

  Champion({required int id, String? name, int? skin})
      : _id = id,
        _name = name,
        _skin = skin ?? 0;

  int get id => _id;

  int get skin => _skin;

  String name() {
    if (_name != null) {
      return _name!;
    } else {
      throw NameNotDefined();
    }
  }
}
