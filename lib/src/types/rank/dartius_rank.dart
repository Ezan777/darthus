import 'tiers/dartius_tier.dart';

import '../../dartius_riot_api.dart';

abstract class Rank {
  late Tier _tier;

  Rank(Map<String, dynamic> jsonRank) {
    _tier = Tier(jsonRank);
  }
}
