import 'package:dartius/src/dartius_riot_api.dart';
import 'package:dartius/src/types/matches/dartius_teams.dart';

class MatchNotBuilt implements Exception {}

class Match {
  late List<Team>? _teams;
  late int? _gameDuration;
  final String _matchId, _region;

  Match(
      {required String region,
      required String matchId,
      int? gameDuration,
      List<Team>? teams})
      : _matchId = matchId,
        _region = region,
        _gameDuration = gameDuration,
        _teams = teams;

  factory Match.fromJson(Map<String, dynamic> matchJson, String region) {
    final matchId = matchJson['metadata']['matchId'];
    final gameDuration = matchJson['info']['gameDuration'];
    List<Team> teams = [
      Team((matchJson['info']['participants'] as List).sublist(0, 4)),
      Team((matchJson['info']['participants'] as List).sublist(5, 9))
    ];

    return Match(
        region: region,
        matchId: matchId,
        gameDuration: gameDuration,
        teams: teams);
  }

  /// Build the match from the json returned by riot api
  Future<void> buildFromApi() async {
    final matchJson = await allMatchInfo(_region, _matchId);

    Match.fromJson(matchJson, _region);
  }

  Team blueSideTeam() {
    if (_teams != null) {
      return _teams!.first;
    } else {
      throw MatchNotBuilt();
    }
  }

  Team redSideTeam() {
    if (_teams != null) {
      return _teams!.last;
    } else {
      throw MatchNotBuilt();
    }
  }

  /// Returns the game duration of the match in minutes with the following format
  /// : minutes:seconds
  String gameDurationInMinutes() {
    if (_gameDuration != null) {
      final int minutes = _gameDuration! ~/ 60;
      final int seconds = (minutes - (_gameDuration! / 60) * 60).toInt();
      return '$minutes:$seconds';
    } else {
      throw MatchNotBuilt();
    }
  }

  int gameDurationInSeconds() {
    return _gameDuration ?? (throw MatchNotBuilt);
  }
}
