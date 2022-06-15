import 'package:dartius/src/types/dartius_champion.dart';

import '../../dartius_riot_api.dart';

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
  String _puuid;
  Positions _position;
  late Champion _champion;
  late bool _winner, _firstBloodKill, _pentakill;
  late String _summonerName;
  late int _totalDamageToChampion, _totalCs, _visionScore,
   _summoner1Id, _summoner2Id, _kills, _deaths, _assists, _champLevel, _goldEarned;

  Participant(Positions position, String puuid)
      : _puuid = puuid,
        _position = position;

}
