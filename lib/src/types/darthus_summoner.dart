import '../darthus_riot_api.dart';
import 'rank/darthus_rank.dart';
import 'matches/darthus_match.dart';
import 'matches/darthus_participant.dart';

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
    if (_region == 'euw1' ||
        _region == 'eun1' ||
        _region == 'ru' ||
        _region == 'tr') {
      _worldWideRegion = 'europe';
    } else {
      if (_region == 'na' ||
          _region == 'la1' ||
          _region == 'la2' ||
          region == 'br1') {
        _worldWideRegion = 'americas';
      } else {
        if (_region == 'oc1') {
          _worldWideRegion = 'sea';
        } else {
          _worldWideRegion = 'asia';
        }
      }
    }
  }

  /// Build the summoner object using the [Summoner._summonerName] as starting point.
  ///
  /// Before using this function check if [summonerName] exist with static
  /// function [summonerNameIsValid].
  Future<void> buildSummoner() async {
    final Map<String, dynamic> summonerJson =
        await ApiRequest.summonerInformation(_region, _summonerName);

    _puuid = summonerJson['puuid'];
    _encryptedSummonerId = summonerJson['id'];
    _summonerLevel = summonerJson['summonerLevel'];
    _iconId = summonerJson['profileIconId'];

    final List<dynamic> rankedJson =
        await ApiRequest.rankedInformation(_region, _encryptedSummonerId);

    if (rankedJson.isNotEmpty) {
      for (var json in rankedJson) {
        json['queueType'] == 'RANKED_SOLO_5x5'
            ? _rankSoloDuo = Rank(json)
            : _rankFlex = Rank(json);
      }
    }

    Future.delayed(Duration(milliseconds: 500));

    _matchHistory =
        await ApiRequest.listOfMatches(region: _worldWideRegion, puuid: _puuid);
  }

  /// This function build all the matches in the match history. Be sure to have
  /// enough API request rate before calling this function.
  Future<void> buildAllMatches() async {
    for (int i = 0; i < _matchHistory.length; ++i) {
      buildMatchAt(i);
    }
  }

  Future<void> getMatches({required int numberOfMatches, matchType? type}) async {
    _matchHistory = await ApiRequest.listOfMatches(
        region: _worldWideRegion,
        puuid: _puuid,
        numberOfMatches: numberOfMatches,
        type: type);
  }

  List<dynamic> matchHistory() {
    return _matchHistory;
  }

  List<Match> allMatches() {
    return _allMatches;
  }

  /// Builds the match located at the position [index] in the match history
  Future<void> buildMatchAt(int index) async {
    _allMatches.add(Match.fromJson(
        await ApiRequest.allMatchInfo(_worldWideRegion, _matchHistory[index]),
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
      await ApiRequest.makeRequest(
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
      return '${_rankSoloDuo!.tier()} ${_rankSoloDuo!.rank()} ${_rankSoloDuo!.lp()} lp and ${_rankSoloDuo!.winPercentage()}% win rate';
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

  String summonerName() {
    return _summonerName;
  }

  int iconId() {
    return _iconId;
  }

  String puuid() {
    return _puuid;
  }
}
