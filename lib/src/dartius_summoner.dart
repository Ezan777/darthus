import 'dartius_riot_api.dart';

class Summoner {
  late String _region,
      _summonerName,
      _encryptedSummonerId,
      _puuid,
      _rankSoloDuo;

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
    final List<dynamic> rankedJson =
        await rankedInformation(_region, _encryptedSummonerId);

    _puuid = summonerJson['puuid'];
    _encryptedSummonerId = summonerJson['id'];
  }

  /// Checks if the given [summonerName] is valid
  static Future<bool> summonerNameIsValid(String summonerName) async {
    try {
      await makeRequest(
          'https://euw1.api.riotgames.com/lol/summoner/v4/summoners/'
          'by-name/$summonerName?api_key=');
    } catch (e) {
      return false;
    }

    return true;
  }
}
