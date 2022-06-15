class Champion {
  final int _id;
  final String _name;

  Champion(int id, String name)
      : _id = id,
        _name = name;

  int id() {
    return _id;
  }

  String name() {
    return _name;
  }
}
