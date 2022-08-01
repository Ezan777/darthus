import 'package:darthus/darthus.dart';
import 'package:darthus/src/types/matches/darthus_team.dart';

class FinishedTeam extends Team {
  FinishedTeam(List<dynamic> participantJsonList, List<dynamic> bansJsonList,
      bool isLiveGame, String region, int queueId)
      : super(participantJsonList, bansJsonList, isLiveGame, region, queueId);

  int maxDamageDealtToChampions() {
    int max =
        (participants()[0] as FinishedParticipant).totalDamageDealtToChampions;

    for (var participant in participants()) {
      participant = participant as FinishedParticipant;
      if (participant.totalDamageDealtToChampions > max) {
        max = participant.totalDamageDealtToChampions;
      }
    }

    return max;
  }

  int maxDamageDealtToObjectives() {
    int max =
        (participants()[0] as FinishedParticipant).damageDealtToObjectives;

    for (var participant in participants()) {
      participant = participant as FinishedParticipant;
      if (participant.damageDealtToObjectives > max) {
        max = participant.damageDealtToObjectives;
      }
    }

    return max;
  }

  int maxDamageTaken() {
    int max =
        (participants()[0] as FinishedParticipant).totalDamageTaken;

    for (var participant in participants()) {
      participant = participant as FinishedParticipant;
      if (participant.totalDamageTaken > max) {
        max = participant.totalDamageTaken;
      }
    }

    return max;
  }

  int maxDamageSelfMitigated() {
    int max =
        (participants()[0] as FinishedParticipant).damageSelfMitgated;

    for (var participant in participants()) {
      participant = participant as FinishedParticipant;
      if (participant.damageSelfMitgated > max) {
        max = participant.damageSelfMitgated;
      }
    }

    return max;
  }
}
