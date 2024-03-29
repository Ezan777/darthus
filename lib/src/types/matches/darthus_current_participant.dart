import 'package:darthus/darthus.dart';
import 'package:darthus/src/types/matches/darthus_participant.dart';

class CurrentParticipant extends Participant {
  final String _encryptedSummonerId, _region;
  final int _profileIconId, _queueId;

  CurrentParticipant(
      Map<String, dynamic> participantJson, String region, int queueId)
      : _encryptedSummonerId = participantJson['summonerId'],
        _profileIconId = participantJson['profileIconId'],
        _queueId = queueId,
        _region = region,
        super(participantJson);

  /// Return the Rank object of the participant.
  ///
  /// If the game is a Ranked Flex
  /// it will return the object representing that type of rank for the player, null if unranked.
  ///
  /// In ***all*** other cases it will return Rank object for Solo/Duo, it will return
  /// null if the player is unranked in Solo/Duo
  Future<Rank?> participantRank() async {
    if (_queueId == 440) {
      return Rank(
          await ApiRequest.rankedFlexInfo(_region, _encryptedSummonerId));
    } else {
      return Rank(
          await ApiRequest.rankedSoloDuoInfo(_region, _encryptedSummonerId));
    }
  }

  String get encryptedSummonerId => _encryptedSummonerId;
  int get profileIconId => _profileIconId;
}
