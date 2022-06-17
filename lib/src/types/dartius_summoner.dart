import '../dartius_riot_api.dart';
import 'rank/dartius_rank.dart';
import 'matches/dartius_match.dart';
import 'matches/dartius_participant.dart';

class MatchDoesNotExists implements Exception {}

class Summoner {
  final String _region, _summonerName;
  late String _encryptedSummonerId, _puuid, _worldWideRegion;
  late int _summonerLevel, _iconId;
  late List<dynamic> _matchHistory;
  List<Match> _allMatches;
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
        _summonerName = summonerName,
        _allMatches = <Match>[] {
    if (_region == 'euw1' || _region == 'eun1' || _region == 'ru') {
      _worldWideRegion = 'europe';
    } else {
      if (_region == 'na' ||
          _region == 'la1' ||
          _region == 'la2' ||
          region == 'br1') {
        _worldWideRegion = 'americas';
      } else {
        _worldWideRegion = 'asia';
      }
    }
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

    Future.delayed(Duration(milliseconds: 500));

    _matchHistory = await listOfMatches(_worldWideRegion, _puuid);
  }

  /// Builds the match located at the position [index] in the match history
  Future<void> buildMatchAt(int index) async {
    _allMatches.add(Match.fromJson(
        await allMatchInfo(_worldWideRegion, _matchHistory[index]),
        _worldWideRegion));
  }

  /// Returns the participant that corresponds to the summoner in the match located
  /// at the given [index]. Returns null if the summoner didn't play in this match.
  Participant? participantOfMatch(int index) {
    if (index > _allMatches.length - 1 || index < 0) {
      throw MatchDoesNotExists();
    } else {
      return _allMatches[index].participantFromSummoner(this);
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

  /// Returns a string containing all information about player's solo/duo ranked
  String rankSolo() {
    if (_rankSoloDuo != null) {
      return '${_rankSoloDuo!.tier()} ${_rankSoloDuo!.rank()} ${_rankSoloDuo!.lp()} lp';
    } else {
      return 'Unranked';
    }
  }

  String rankFlex() {
    if (_rankFlex != null) {
      return '${_rankFlex!.tier()} ${_rankFlex!.rank()} ${_rankFlex!.lp()} lp';
    } else {
      return 'Unranked';
    }
  }

  /// Returns the summoner's level
  int summonerLevel() {
    return _summonerLevel;
  }

  int iconId() {
    return _iconId;
  }

  String puuid() {
    return _puuid;
  }
}
