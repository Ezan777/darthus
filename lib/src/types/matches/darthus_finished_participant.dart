import 'package:darthus/darthus.dart';
import 'package:darthus/src/types/darthus_champion.dart';
import 'package:darthus/src/types/matches/darthus_participant.dart';

/// Class [FinishedParticipant] is made to represent players of a single finished match, it will
/// contains data of the players like kills, assists, deaths and others...
class FinishedParticipant extends Participant {
  final String _puuid;
  final bool _winner, _firstBloodKill, _pentakill;
  final int _totalDamageToChampions,
      _totalCs,
      _visionScore,
      _kills,
      _deaths,
      _assists,
      _champLevel,
      _goldEarned,
      _goldSpent;
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
        _goldEarned = participantJson['goldEarned'],
        _goldSpent = participantJson['goldSpent'],
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

  /// Returns a list containing the ids of the items bought by the player
  List<int> get itemsId => _itemsId;

  @override

  /// Returns a map with information about the champion played.
  ///
  /// The keys of the map are: [championId], [championName], [championLevel]
  Map<String, dynamic> get championInfo => <String, dynamic>{
        'championId': super.championInfo['championId'],
        'championName': super.championInfo['championName'],
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

  bool get isWinner => _winner;

  bool get gotPentakill => _pentakill;

  bool get gotFirstBlood => _firstBloodKill;
}