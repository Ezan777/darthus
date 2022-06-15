import 'package:dartius/src/types/dartius_champion.dart';

import '../../dartius_riot_api.dart';

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
  String _puuid, _summonerName;
  Champion _champion;
  bool _winner, _firstBloodKill, _pentakill;
  int _totalDamageToChampions,
      _totalCs,
      _visionScore,
      _summoner1Id,
      _summoner2Id,
      _kills,
      _deaths,
      _assists,
      _champLevel,
      _goldEarned;

  Participant(Map<String, dynamic> participantJson)
      : _puuid = participantJson['puuid'],
        _champion = Champion(
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
        _goldEarned = participantJson['goldEarned'];
}
