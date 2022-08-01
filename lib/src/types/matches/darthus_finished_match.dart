import 'package:darthus/darthus.dart';
import 'darthus_team.dart';
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

  int maxDamageDealtToChampions() {
    int maxBlueSide = (blueSideTeam.participants()[0] as FinishedParticipant)
        .totalDamageDealtToChampions;

    int maxRedSide = (redSideTeam.participants()[0] as FinishedParticipant)
    .totalDamageDealtToChampions;

    for (int i = 1; i < 5; ++i) {
      FinishedParticipant blueParticipant = blueSideTeam.participants()[i] as FinishedParticipant;
      FinishedParticipant redParticipant = redSideTeam.participants()[i] as FinishedParticipant;

      if (blueParticipant.totalDamageDealtToChampions > maxBlueSide) {
        maxBlueSide = blueParticipant.totalDamageDealtToChampions;
      }
      if (redParticipant.totalDamageDealtToChampions > maxBlueSide) {
        maxRedSide = redParticipant.totalDamageDealtToChampions;
      }
    }

    return maxBlueSide > maxRedSide ? maxBlueSide : maxRedSide;
  }

  int maxDamageDealtToObjectives() {
    int maxBlueSide = (blueSideTeam.participants()[0] as FinishedParticipant)
        .damageDealtToObjectives;

    int maxRedSide = (redSideTeam.participants()[0] as FinishedParticipant)
    .damageDealtToObjectives;

    for (int i = 1; i < 5; ++i) {
      FinishedParticipant blueParticipant = blueSideTeam.participants()[i] as FinishedParticipant;
      FinishedParticipant redParticipant = redSideTeam.participants()[i] as FinishedParticipant;

      if (blueParticipant.damageDealtToObjectives > maxBlueSide) {
        maxBlueSide = blueParticipant.damageDealtToObjectives;
      }
      if (redParticipant.damageDealtToObjectives > maxBlueSide) {
        maxRedSide = redParticipant.damageDealtToObjectives;
      }
    }

    return maxBlueSide > maxRedSide ? maxBlueSide : maxRedSide;
  }

  int maxDamageTaken() {
    int maxBlueSide = (blueSideTeam.participants()[0] as FinishedParticipant)
        .totalDamageTaken;

    int maxRedSide = (redSideTeam.participants()[0] as FinishedParticipant)
    .totalDamageTaken;

    for (int i = 1; i < 5; ++i) {
      FinishedParticipant blueParticipant = blueSideTeam.participants()[i] as FinishedParticipant;
      FinishedParticipant redParticipant = redSideTeam.participants()[i] as FinishedParticipant;

      if (blueParticipant.totalDamageTaken > maxBlueSide) {
        maxBlueSide = blueParticipant.totalDamageTaken;
      }
      if (redParticipant.totalDamageTaken > maxBlueSide) {
        maxRedSide = redParticipant.totalDamageTaken;
      }
    }

    return maxBlueSide > maxRedSide ? maxBlueSide : maxRedSide;
  }

  int maxDamageSelfMitigated() {
    int maxBlueSide = (blueSideTeam.participants()[0] as FinishedParticipant)
        .damageSelfMitgated;

    int maxRedSide = (redSideTeam.participants()[0] as FinishedParticipant)
    .damageSelfMitgated;

    for (int i = 1; i < 5; ++i) {
      FinishedParticipant blueParticipant = blueSideTeam.participants()[i] as FinishedParticipant;
      FinishedParticipant redParticipant = redSideTeam.participants()[i] as FinishedParticipant;

      if (blueParticipant.damageSelfMitgated > maxBlueSide) {
        maxBlueSide = blueParticipant.damageSelfMitgated;
      }
      if (redParticipant.damageSelfMitgated > maxBlueSide) {
        maxRedSide = redParticipant.damageSelfMitgated;
      }
    }

    return maxBlueSide > maxRedSide ? maxBlueSide : maxRedSide;
  }
}
