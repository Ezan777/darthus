import 'dart:convert';
import 'dart:io';

class NameNotDefined implements Exception {}

class Champion {
  final int _id, _skin;
  String? _name;

  Champion({required int id, String? name, int? skin})
      : _id = id,
        _skin = skin ?? 0;

  Future<void> buildName() async {
    final jsonChampions = await File('json/champion.json')
        .readAsString()
        .then((fileContents) => jsonDecode(fileContents));
    jsonChampions['data'].entries.forEach((element) {
      if (element.value['key'] == _id.toString()) {
        _name = element.value['id'];
      }
    });
  }

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
