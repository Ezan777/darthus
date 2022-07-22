import 'package:darthus/src/types/matches/darthus_current_participant.dart';
import 'package:darthus/src/types/matches/darthus_participant.dart';

import '../darthus_champion.dart';
import 'darthus_finished_participant.dart';
import '../darthus_summoner.dart';

class Team {
  late List<Participant> _participants;
  List<Champion>? _bans;
  final bool _isLiveGame;
  final String _region;

  Team(List<dynamic> participantJsonList, List<dynamic> bansJsonList,
      bool isLiveGame, String region)
      : _isLiveGame = isLiveGame,
        _region = region {
    if (!_isLiveGame) {
      _participants = [FinishedParticipant(participantJsonList[0])];
      if (bansJsonList.isNotEmpty) {
        _bans = [Champion(id: bansJsonList[0]['championId'])];
        for (int i = 1; i < participantJsonList.length; ++i) {
          _participants.add(FinishedParticipant(participantJsonList[i]));
          _bans!.add(Champion(id: bansJsonList[i]['championId']));
        }
      } else {
        for (int i = 1; i < participantJsonList.length; ++i) {
          _participants.add(FinishedParticipant(participantJsonList[i]));
        }
      }
    } else {
      _participants = [CurrentParticipant(participantJsonList[0], _region)];
      if (bansJsonList.isNotEmpty) {
        _bans = [Champion(id: bansJsonList[0]['championId'])];
        for (int i = 1; i < participantJsonList.length; ++i) {
          _participants.add(CurrentParticipant(participantJsonList[i], region));
          _bans!.add(Champion(id: bansJsonList[i]['championId']));
        }
      } else {
        for (int i = 1; i < participantJsonList.length; ++i) {
          _participants
              .add(CurrentParticipant(participantJsonList[i], _region));
        }
      }
    }
  }

  List<Participant> participants() {
    return _participants;
  }

  /// Searches for the given [summoner] in the participants, if the summoners
  /// played in this team it returns the corresponding participant otherwise it returns null.
  ///
  /// It will return null also if it is a live game.
  Participant? findSummoner(Summoner summoner) {
    bool found = false;
    if (_isLiveGame) {
      return null;
    }

    for (int i = 0; i < _participants.length && !found; ++i) {
      if ((_participants[i] as FinishedParticipant)
          .isEqualToTheSummoner(summoner)) {
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

  /// Returns null if it is a live game, otherwise it will return all the kills 
  /// of the team.
  int? totalKills() {
    if(!_isLiveGame){
      int totalKills = 0;
    for (int i = 0; i < _participants.length; ++i) {
      totalKills += (_participants[i] as FinishedParticipant).score()['kills'] ?? 0;
    }
    return totalKills;
    } else {
      return null;
    }
  }

  /// Returns null if it is a live game
  bool? isWinner() {
    if (!_isLiveGame) {
      return (_participants[0] as FinishedParticipant).isWinner;
    } else {
      return null;
    }
  }
}
