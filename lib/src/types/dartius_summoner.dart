import '../dartius_riot_api.dart';

class Summoner {
  late String _region, _summonerName, _encryptedSummonerId, _puuid;
  Map<String, dynamic>? _rankedSoloDuo, _rankedFlex;

  /// Constructor for [Summoner] class.
  ///
  /// Since http requests are impossible to be
  /// made inside the constructor, because you can't mark it as async, remember to
  /// call [Summoner.buildSummoner] function immediately after creating the object.
  ///
  /// Before creation remember to check if [summonerName] exists with the static function
  /// [summonerNameIsValid].
  Summoner(String region, String summonerName) {
    _region = region;
    _summonerName = summonerName;
  }

  /// Build the summoner object using the [Summoner._summonerName] as starting point.
  ///
  /// Before using this function check if [summonerName] exist with static
  /// function [summonerNameIsValid].
  Future<void> buildSummoner() async {
    final Map<String, dynamic> summonerJson =
        await summonerInformation(_region, _summonerName);

    _puuid = summonerJson['puuid'];
    _encryptedSummonerId = summonerJson['id'];

    final List<dynamic> rankedJson =
        await rankedInformation(_region, _encryptedSummonerId);

    if (rankedJson.isNotEmpty) {
      for (int i = 0; i < rankedJson.length; ++i) {
        if (rankedJson[i]['queueType'] == 'RANKED_SOLO_5x5') {
          _rankedSoloDuo = rankedJson[i];
        } else {
          if (rankedJson[i]['queueType'] == 'RANKED_FLEX_SR') {
            _rankedFlex = rankedJson[i];
          }
        }
      }
    }
  }

  /// Checks if the given [summonerName] is valid
  static Future<bool> summonerNameIsValid(String summonerName) async {
    try {
      await makeRequest(
          'https://euw1.api.riotgames.com/lol/summoner/v4/summoners/'
          'by-name/$summonerName?api_key=');
    } on DataNotFound {
      return false;
    }

    return true;
  }

  void printRankSolo() {
    if (_rankedSoloDuo == null) {
      print('$_summonerName is unranked');
    } else {
      String tier = _rankedSoloDuo!['tier'].toString();
      tier = tier[0].toUpperCase() + tier.substring(1).toLowerCase();
      String rank = _rankedSoloDuo!['rank'];
      int leaguePoints = _rankedSoloDuo!['leaguePoints'];

      print('$_summonerName is $tier $rank with $leaguePoints lp');
    }
  }
}
