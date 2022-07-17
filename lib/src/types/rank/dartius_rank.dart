import 'dart:convert';

import '../../dartius_riot_api.dart';

class Rank {
  final String _tier;
  final String _queueType;
  final int _lp, _wins, _losses;
  final String _rank;

  Rank(Map<String, dynamic> jsonRank)
      : _tier =
            '${jsonRank['tier'].toString()[0].toUpperCase()}${jsonRank['tier'].toString().substring(1).toLowerCase()}',
        _queueType = jsonRank['queueType'] == 'RANKED_SOLO_5x5'
            ? 'Ranked solo/duo'
            : 'Ranked flex',
        _lp = jsonRank['leaguePoints'],
        _rank = jsonRank['rank'],
        _wins = jsonRank['wins'],
        _losses = jsonRank['losses'];

  String queueType() {
    return _queueType;
  }

  String tier() {
    return _tier;
  }

  int lp() {
    return _lp;
  }

  String rank() {
    return _rank;
  }
}
