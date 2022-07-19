import '../darthus_summoner.dart';
import '../../darthus_riot_api.dart';
import 'darthus_teams.dart';
import 'darthus_participant.dart';

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
      Team((matchJson['info']['participants'] as List).sublist(0, 5),
          matchJson['info']['teams'][0]['bans']),
      Team((matchJson['info']['participants'] as List).sublist(5, 10),
          matchJson['info']['teams'][1]['bans']),
    ];

    return Match(
        region: region,
        matchId: matchId,
        gameDuration: gameDuration,
        teams: teams);
  }

  /// Build the match from the json returned by riot api
  Future<Match> buildFromApi() async {
    final matchJson = await ApiRequest.allMatchInfo(_region, _matchId);

    return Match.fromJson(matchJson, _region);
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
      final int seconds = (((_gameDuration! / 60) - minutes) * 60).toInt();
      return '$minutes:$seconds';
    } else {
      throw MatchNotBuilt();
    }
  }

  /// Returns the participant corresponding to the given [summoner]. If the summoner
  /// didn't play in this game it will return null.
  Participant? participantFromSummoner(Summoner summoner) {
    if (_teams != null) {
      bool found = false;
      Participant? participant;
      for (int i = 0; i < _teams!.length && !found; ++i) {
        participant = _teams![i].findSummoner(summoner);
        if (participant != null) {
          found = true;
        }
      }

      return participant;
    } else {
      throw MatchNotBuilt;
    }
  }

  int gameDurationInSeconds() {
    return _gameDuration ?? (throw MatchNotBuilt);
  }
}
