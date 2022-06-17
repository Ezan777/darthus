class NameNotDefined implements Exception {}

class Champion {
  final int _id;
  String? _name;

  Champion({required int id, String? name})
      : _id = id,
        _name = name {
    if (_name != null) {
      for (int i = 1; i < _name!.length; ++i) {
        if (_name![i] == _name![i].toUpperCase()) {
          _name =
              '${_name!.substring(0, i)} ${_name!.substring(i, _name!.length)}';
          i += 1;
        }
      }
    }
  }

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
