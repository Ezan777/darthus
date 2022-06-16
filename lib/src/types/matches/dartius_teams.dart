import 'package:dartius/src/types/dartius_champion.dart';
import 'package:dartius/src/types/matches/dartius_participant.dart';

class Team {
  late List<Participant> participants;
  late List<Champion> bans;

  Team(List<dynamic> participantJsonList, List<dynamic> bansJsonList) {
    for (int i = 0; i < participantJsonList.length; ++i) {
      participants.add(Participant(participantJsonList[i]));
      bans.add(Champion(id: bansJsonList[i]['championId']));
    }
  }

  int totalKills() {
    int totalKills = 0;
    for (int i = 0; i < participants.length; ++i) {
      totalKills += participants[i].score()['kills'] ?? 0;
    }
    return totalKills;
  }

  bool isWinner() {
    return participants[0].isWinner();
  }
}
