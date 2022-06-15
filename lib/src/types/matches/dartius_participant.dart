import 'package:dartius/dartius.dart';
import 'package:dartius/src/types/dartius_champion.dart';

// TODO Need to implement a team class

enum Positions {
  BlueTop,
  BlueJungler,
  BlueMid,
  BlueBot,
  BlueSupport,
  RedTop,
  RedJungler,
  RedMid,
  RedBot,
  RedSupport,
}

/// Class [Participant] is made to represent players of a single match, it will
/// contains data of the players like kills, assists, deaths and others...
class Participant {
  final String _puuid, _summonerName;
  final Champion champion;
  final bool _winner, _firstBloodKill, _pentakill;
  final int _totalDamageToChampions,
      _totalCs,
      _visionScore,
      _summoner1Id,
      _summoner2Id,
      _kills,
      _deaths,
      _assists,
      _champLevel,
      _goldEarned,
      _goldSpent;
  late List<int> _itemsId;

  /// [participantJson] is the json file containing data about a single participant
  Participant(Map<String, dynamic> participantJson)
      : _puuid = participantJson['puuid'],
        champion = Champion(
            participantJson['championId'], participantJson['championName']),
        _winner = participantJson['winner'],
        _firstBloodKill = participantJson['firstBloodKill'],
        _pentakill = participantJson['pentaKills'] >= 1 ? true : false,
        _summonerName = participantJson['summonerName'],
        _totalDamageToChampions =
            participantJson['totalDamageDealtToChampions'],
        _totalCs = participantJson['totalMinionsKilled'] +
            participantJson['neutralMinionsKilled'],
        _visionScore = participantJson['visionScore'],
        _summoner1Id = participantJson['summoner1Id'],
        _summoner2Id = participantJson['summoner2Id'],
        _kills = participantJson['kills'],
        _deaths = participantJson['deaths'],
        _assists = participantJson['assists'],
        _champLevel = participantJson['champLevel'],
        _goldEarned = participantJson['goldEarned'],
        _goldSpent = participantJson['goldSpent'] {
    for (int i = 0; i < 7; ++i) {
      _itemsId.add(participantJson['item$i']);
    }
  }

  /// Returns a map containing the score of the player.
  ///
  /// The map has the following keys: kills, deaths, assists, cs, visionScore, totalDamageDealtToChampions
  Map<String, int> score() {
    return <String, int>{
      'kills': _kills,
      'deaths': _deaths,
      'assists': _assists,
      'cs': _totalCs,
      'visionScore': _visionScore,
      'totalDamageDealtToChampions': _totalDamageToChampions
    };
  }

  /// Returns a map containing how much gold the player earned and how much did he spend
  ///
  /// The keys of the map are: [goldEarned] and [goldSpent]
  Map<String, int> goldInformation() {
    return <String, int>{'goldEarned': _goldEarned, 'goldSpent': _goldSpent};
  }

  /// Returns a list containing the ids of the two summoner's spell used by the player
  List<int> summonerSpells() {
    return <int>[_summoner1Id, _summoner2Id];
  }

  String summonerName() {
    return _summonerName;
  }

  /// Returns a list containing the ids of the items bought by the player
  List<int> itemsId() {
    return _itemsId;
  }

  /// Returns a map with information about the champion played.
  /// 
  /// The keys of the map are: [championId], [championName], [championLevel]
  Map<String, dynamic> championInfo() {
    return <String, dynamic>{
      'championId': champion.id(),
      'championName': champion.name(),
      'championLevel': _champLevel
    };
  }

  /// Check if the participant is equal to [summoner]
  bool isEqualToTheSummoner(Summoner summoner) {
    if (_puuid == summoner.puuid()) {
      return true;
    } else {
      return false;
    }
  }

  bool isWinner() {
    return _winner;
  }

  bool gotPentakill() {
    return _pentakill;
  }

  bool gotFirstBlood() {
    return _firstBloodKill;
  }
}
