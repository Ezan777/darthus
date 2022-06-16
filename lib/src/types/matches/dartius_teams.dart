import 'package:dartius/src/types/matches/dartius_participant.dart';

class Team {
  late List<Participant> participants;

  Team(List<dynamic> participantJsonList) {
    for (int i = 0; i < participantJsonList.length; ++i) {
      participants.add(Participant(participantJsonList[i]));
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
