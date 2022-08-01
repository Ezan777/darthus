import 'package:darthus/darthus.dart';
import 'package:darthus/src/types/matches/darthus_participant.dart';

/// Class [FinishedParticipant] is made to represent players of a single finished match, it will
/// contains data of the players like kills, assists, deaths and others...
class FinishedParticipant extends Participant {
  final String _puuid, _champName;
  final bool _winner, _firstBloodKill, _pentakill;
  final int _totalDamageToChampions,
      _totalCs,
      _visionScore,
      _kills,
      _deaths,
      _assists,
      _champLevel,
      _goldEarned,
      _goldSpent,
      _damageDealtToObjectives,
      _magicDamageDealtToChampions,
      _magicDamageTaken,
      _physicalDamageDealtToChampions,
      _physicalDamageTaken,
      _trueDamageDealtToChampions,
      _trueDamageTaken,
      _damageSelfMitgated;
  late List<int> _itemsId;

  /// [participantJson] is the json file containing data about a single participant
  FinishedParticipant(Map<String, dynamic> participantJson)
      : _puuid = participantJson['puuid'],
        _winner = participantJson['win'],
        _firstBloodKill = participantJson['firstBloodKill'],
        _pentakill = participantJson['pentaKills'] >= 1 ? true : false,
        _totalDamageToChampions =
            participantJson['totalDamageDealtToChampions'],
        _totalCs = participantJson['totalMinionsKilled'] +
            participantJson['neutralMinionsKilled'],
        _visionScore = participantJson['visionScore'],
        _kills = participantJson['kills'],
        _deaths = participantJson['deaths'],
        _assists = participantJson['assists'],
        _champLevel = participantJson['champLevel'],
        _champName = participantJson['championName'],
        _goldEarned = participantJson['goldEarned'],
        _goldSpent = participantJson['goldSpent'],
        _damageDealtToObjectives = participantJson["damageDealtToObjectives"],
        _magicDamageDealtToChampions =
            participantJson["magicDamageDealtToChampions"],
        _magicDamageTaken = participantJson["magicDamageTaken"],
        _physicalDamageDealtToChampions =
            participantJson["physicalDamageDealtToChampions"],
        _physicalDamageTaken = participantJson["physicalDamageTaken"],
        _trueDamageDealtToChampions =
            participantJson["trueDamageDealtToChampions"],
        _trueDamageTaken = participantJson["trueDamageTaken"],
        _damageSelfMitgated = participantJson["damageSelfMitigated"],
        super(participantJson) {
    _itemsId = [participantJson['item0']];
    for (int i = 1; i < 7; ++i) {
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

  /// Returns a list containing the ids of the items bought by the player, the
  /// last item in the list it's the trinket. If an id is equal to 0 it means that
  /// the item's slot was empty.
  List<int> get itemsId => _itemsId;

  @override

  /// Returns a map with information about the champion played.
  ///
  /// The keys of the map are: [championId], [championName], [championLevel]
  Map<String, dynamic> get championInfo => <String, dynamic>{
        'championId': super.championInfo['championId'],
        'championName': _champName,
        'championLevel': _champLevel,
      };

  /// Check if the participant is equal to [summoner]
  bool isEqualToTheSummoner(Summoner summoner) {
    if (_puuid == summoner.puuid) {
      return true;
    } else {
      return false;
    }
  }

  int get kills => _kills;

  int get deaths => _deaths;

  int get assists => _assists;

  int get goldEarned => _goldEarned;

  int get minons => _totalCs;

  bool get isWinner => _winner;

  bool get gotPentakill => _pentakill;

  bool get gotFirstBlood => _firstBloodKill;

  int get damageDealtToObjectives => _damageDealtToObjectives;

  int get magicDamageDealtToChampions => _magicDamageDealtToChampions;

  int get magicDamageTaken => _magicDamageTaken;

  int get physicalDamageDealtToChampions => _physicalDamageDealtToChampions;

  int get physicalDamageTaken => _physicalDamageTaken;

  int get trueDamageDelatToChampions => _trueDamageDealtToChampions;

  int get trueDamageTaken => _trueDamageTaken;

  int get totalDamageDealtToChampions => (_magicDamageDealtToChampions +
      _physicalDamageDealtToChampions +
      _trueDamageDealtToChampions);

  int get totalDamageTaken =>
      (_magicDamageTaken + _physicalDamageTaken + _trueDamageTaken);

  int get damageSelfMitgated => _damageSelfMitgated;
}
