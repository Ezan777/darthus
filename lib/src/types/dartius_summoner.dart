import '../dartius_riot_api.dart';
import 'rank/dartius_rank.dart';

class Summoner {
  final String _region, _summonerName;
  late String _encryptedSummonerId, _puuid;
  late int _summonerLevel, _iconId;
  Rank? _rankSoloDuo, _rankFlex;

  /// Constructor for [Summoner] class.
  ///
  /// Since http requests are impossible to be
  /// made inside the constructor, because you can't mark it as async, remember to
  /// call [Summoner.buildSummoner] function immediately after creating the object.
  ///
  /// Before creation remember to check if [summonerName] exists with the static function
  /// [summonerNameIsValid].
  Summoner(String region, String summonerName)
      : _region = region,
        _summonerName = summonerName;

  /// Build the summoner object using the [Summoner._summonerName] as starting point.
  ///
  /// Before using this function check if [summonerName] exist with static
  /// function [summonerNameIsValid].
  Future<void> buildSummoner() async {
    final Map<String, dynamic> summonerJson =
        await summonerInformation(_region, _summonerName);

    _puuid = summonerJson['puuid'];
    _encryptedSummonerId = summonerJson['id'];
    _summonerLevel = summonerJson['summonerLevel'];
    _iconId = summonerJson['profileIconId'];

    final List<dynamic> rankedJson =
        await rankedInformation(_region, _encryptedSummonerId);

    if (rankedJson.isNotEmpty) {
      for (var json in rankedJson) {
        json['queueType'] == 'RANKED_SOLO_5x5'
            ? _rankSoloDuo = Rank(json)
            : _rankFlex = Rank(json);
      }
    }
  }

  /// Returns the summoner's level
  int summonerLevel() {
    return _summonerLevel;
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

  /// Returns a string containing all information about player's solo/duo ranked
  String rankSolo() {
    if (_rankSoloDuo != null) {
      return '${_rankSoloDuo!.tier()} ${_rankSoloDuo!.rank()} ${_rankSoloDuo!.lp()} lp';
    } else {
      return 'Unranked';
    }
  }

  String puuid() {
    return _puuid;
  }
}
