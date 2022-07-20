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

  String get queueType => _queueType;

  String get tier => _tier;

  int get lp => _lp;

  String get rank => _rank;

  double get winPercentage =>
      double.parse(((_wins / (_wins + _losses)) * 100).toStringAsFixed(2));
}
