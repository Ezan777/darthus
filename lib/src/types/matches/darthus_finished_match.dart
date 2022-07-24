import '../../darthus_riot_api.dart';
import 'darthus_teams.dart';
import 'darthus_match.dart';

class FinishedMatch extends Match {
  late int? _gameDuration;
  final String _matchId;
  String? _matchType;

  FinishedMatch(
      {required String region,
      required String matchId,
      int? gameDuration,
      List<Team>? teams,
      String? matchType})
      : _matchId = matchId,
        _gameDuration = gameDuration,
        _matchType = matchType,
        super(region: region, teams: teams);

  /// This constructor build the match from the json file obtained from Riot servers.
  factory FinishedMatch.fromJson(
      Map<String, dynamic> matchJson, String region) {
    final matchId = matchJson['metadata']['matchId'];
    final gameDuration = matchJson['info']['gameDuration'];
    final queueId = matchJson['info']['queueId'];
    List<Team> teams = [
      Team((matchJson['info']['participants'] as List).sublist(0, 5),
          matchJson['info']['teams'][0]['bans'], false, region, queueId),
      Team((matchJson['info']['participants'] as List).sublist(5, 10),
          matchJson['info']['teams'][1]['bans'], false, region, queueId),
    ];
    final String? matchType;
    switch (queueId) {
      case (400):
        matchType = "Draft";
        break;
      case (420):
        matchType = "Solo/Duo";
        break;
      case (430):
        matchType = "Blind pick";
        break;
      case (440):
        matchType = "Flex";
        break;
      case (450):
        matchType = "Aram";
        break;
      default:
        matchType = null;
        break;
    }

    return FinishedMatch(
      region: region,
      matchId: matchId,
      gameDuration: gameDuration,
      teams: teams,
      matchType: matchType,
    );
  }

  @override

  /// Build the match from the json returned by riot api
  Future<FinishedMatch> buildFromApi() async {
    final matchJson = await ApiRequest.allMatchInfo(super.region, _matchId);

    return FinishedMatch.fromJson(matchJson, super.region);
  }

  /// Returns the game duration of the match in minutes with the following format
  /// m:s
  String gameDurationInMinutes() {
    if (_gameDuration != null) {
      final int minutes = _gameDuration! ~/ 60;
      final int seconds = (((_gameDuration! / 60) - minutes) * 60).toInt();
      return '$minutes:$seconds';
    } else {
      throw MatchNotBuilt();
    }
  }

  int gameDurationInSeconds() {
    return _gameDuration ?? (throw MatchNotBuilt);
  }
  
  /// Returns the matchType as a String. It works with normal matches like Ranked
  /// Solo/Duo, Flex, blind pick, draft and Aram, if it returns null it means that the match
  /// was of a special and unsual type
  String? get matchType => _matchType;
}
