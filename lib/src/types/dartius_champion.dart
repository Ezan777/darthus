class NameNotDefined implements Exception {}

class Champion {
  final int _id;
  String? _name;

  Champion({required int id, String? name})
      : _id = id,
        _name = name;

  int id() {
    return _id;
  }

  String name() {
    if (_name != null) {
      return _name!;
    } else {
      throw NameNotDefined();
    }
  }
}
