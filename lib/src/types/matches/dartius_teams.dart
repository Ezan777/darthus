import '../dartius_champion.dart';
import 'dartius_teams.dart';
import 'dartius_participant.dart';
import '../dartius_summoner.dart';

class Team {
  late List<Participant> _participants;
  List<Champion>? _bans;

  Team(List<dynamic> participantJsonList, List<dynamic> bansJsonList) {
    _participants = [Participant(participantJsonList[0])];
    if(bansJsonList.isNotEmpty) {
      _bans = [Champion(id: bansJsonList[0]['championId'])];
      for (int i = 0; i < participantJsonList.length; ++i) {
        _participants.add(Participant(participantJsonList[i]));
        _bans!.add(Champion(id: bansJsonList[i]['championId']));
      }
    }
  }

  List<Participant> participants() {
    return _participants;
  }

  /// Searches for the given [summoner] in the participants, if the summoners
  /// played in this team it returns the corresponding participant otherwise it returns null.
  Participant? findSummoner(Summoner summoner) {
    bool found = false;
    for (int i = 0; i < _participants.length && !found; ++i) {
      if (_participants[i].isEqualToTheSummoner(summoner)) {
        return _participants[i];
      }
    }

    if (!found) {
      return null;
    }
  }

  /// Returns null if the game didn't have bans
  List<Champion>? bans() {
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
