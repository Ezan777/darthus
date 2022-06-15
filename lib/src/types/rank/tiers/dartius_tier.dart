import '../../../dartius_riot_api.dart';

class Tier {
  late String _name, _rank, _icon;
  late int _lp;

  Tier(Map<String, dynamic> jsonRank) {
    _name = jsonRank['tier'];
    _lp = jsonRank['leaguePoints'];
  }

  /// Return the name of the tier
  String tierName() {
    return _name;
  }

  /// Returns the player's [rank]
  String rank() {
    return _rank;
  }

  /// Returns how much lp the player has
  int lp() {
    return _lp;
  }

  /// Return the id that represent tier's icon
  String iconId() {
    return _icon;
  }
}
