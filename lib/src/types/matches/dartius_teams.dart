import 'package:dartius/src/types/dartius_champion.dart';
import 'package:dartius/src/types/matches/dartius_participant.dart';

class Team {
  late List<Participant> _participants;
  late List<Champion> _bans;

  Team(List<dynamic> participantJsonList, List<dynamic> bansJsonList) {
    _participants = [Participant(participantJsonList[0])];
    _bans = [Champion(id: bansJsonList[0]['championId'])];
    for (int i = 1; i < participantJsonList.length; ++i) {
      _participants.add(Participant(participantJsonList[i]));
      _bans.add(Champion(id: bansJsonList[i]['championId']));
    }
  }

  List<Participant> participants() {
    return _participants;
  }

  List<Champion> bans() {
    return _bans;
  }

  int totalKills() {
    int totalKills = 0;
    for (int i = 0; i < _participants.length; ++i) {
      totalKills += _participants[i].score()['kills'] ?? 0;
    }
    return totalKills;
  }

  bool isWinner() {
    return _participants[0].isWinner();
  }
}
