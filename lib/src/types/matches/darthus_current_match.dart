import 'package:darthus/darthus.dart';

import 'darthus_match.dart';
import 'darthus_teams.dart';

class CurrentMatch extends Match {
  final String? _gameId;
  late int? _queueId;

  CurrentMatch(
      {required String region, List<Team>? teams, String? gameId, int? queueId})
      : _gameId = gameId,
        _queueId = queueId,
        super(region: region, teams: teams);

  factory CurrentMatch.fromJson(
      {required Map<String, dynamic> jsonFile, required String region}) {
    final gameId = jsonFile['gameId'];
    final queueId = jsonFile['gameQueueConfigId'];
    List<Team> teams = [
      Team((jsonFile['participants'] as List).sublist(0, 5),
          jsonFile['bannedChampions'], true, region, queueId),
      Team((jsonFile['participants'] as List).sublist(5, 10),
          jsonFile['bannedChampions'], true, region, queueId),
    ];

    return CurrentMatch(region: region, teams: teams, gameId: gameId.toString(), queueId: queueId);
  }

  @override
  Future<CurrentMatch> buildFromApi() async {
    final jsonFile = await ApiRequest.allMatchInfo(super.region, _gameId ?? "");

    return CurrentMatch.fromJson(jsonFile: jsonFile, region: super.region);
  }
}
