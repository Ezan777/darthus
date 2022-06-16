import 'package:dartius/src/dartius_riot_api.dart';
import 'package:dartius/src/types/matches/dartius_teams.dart';

class Match {
  late List<Team> teams;
  late int _gameDuration;
  final String _matchId, _region;

  Match(String region, String matchId) : _matchId = matchId, _region = region;

  Future<void> getFromApi() async {
    final matchJson = await allMatchInfo(_region, _matchId);

    _gameDuration = matchJson['info']['gameDuration'];
  }
}
