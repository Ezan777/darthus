import 'package:darthus/darthus.dart';
import 'package:darthus/src/types/matches/darthus_participant.dart';
import 'package:darthus/src/types/matches/darthus_team.dart';

class MatchNotBuilt implements Exception {}

abstract class Match {
  late List<Team>? teams;
  final String region;

  Match({required this.region, this.teams});

  /// A method that will build match from data obtained from API
  Future<Match> buildFromApi();

  /// Returns the participant corresponding to the given [summoner].
  /// If the summoner didn't play in this game or it's a live game it will return null.
  Participant? participantFromSummoner(Summoner summoner) {
    if (teams != null) {
      bool found = false;
      Participant? participant;
      for (int i = 0; i < teams!.length && !found; ++i) {
        participant = teams![i].findSummoner(summoner);
        if (participant != null) {
          found = true;
        }
      }

      return participant;
    } else {
      throw MatchNotBuilt;
    }
  }

  Team get blueSideTeam =>
      (teams != null ? teams!.first : throw MatchNotBuilt());
  Team get redSideTeam => (teams != null ? teams!.last : throw MatchNotBuilt());
}
