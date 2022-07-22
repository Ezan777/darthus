import '../darthus_champion.dart';

abstract class Participant {
  final String _summonerName;
  final int _summonerSpell1Id, _summonerSpell2Id;
  final Champion _champion;

  Participant(Map<String, dynamic> participantJson)
      : _summonerName = participantJson['summonerName'],
        _summonerSpell1Id =
            participantJson['spell1Id'] ?? participantJson['summoner1Id'],
        _summonerSpell2Id =
            participantJson['spell2Id'] ?? participantJson['summoner2Id'],
        _champion = Champion(id: participantJson['championId']);

  /// Returns a list containing the ids of the two summoner's spell used by the player
  List<int> get summonerSpells => <int>[_summonerSpell1Id, _summonerSpell2Id];

  String get summonerName => _summonerName;

  /// Returns a map with information about the champion played.
  ///
  /// The keys of the map are: [championId], [championName]
  Map<String, dynamic> get championInfo => <String, dynamic>{
        'championId': _champion.id,
      };
}
