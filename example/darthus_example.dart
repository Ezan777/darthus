import 'package:darthus/darthus.dart';
import 'package:darthus/src/types/matches/darthus_current_participant.dart';

// This file is needed if you want to store the api key in another place so it
// wont be uploaded to github.
import 'api_key.dart';

void main() async {
  ApiRequest.setApiKey(key: myApiKey);
  final String summonerName = 'zan777', summoner2Name = 'secco groni';
  // Check if the summoner name is valid, in order to avoid connection errors
  if (await Summoner.summonerNameIsValid(summonerName)) {
    // Create the summoner object that at the moment it's empty
    Summoner summoner = Summoner('euw1', summonerName);
    Summoner summoner2 = Summoner('euw1', summoner2Name);
    // Retrieve all data about the summoner from Riot API
    await summoner.buildSummoner(); // Now summoner is ready for use
    await summoner2.buildSummoner();

    await summoner2.buildMatchAt(0);
    await summoner2.buildMatchAt(1);
    await summoner2.buildMatchAt(2);
    await summoner2.buildMatchAt(3);
    await summoner2.buildMatchAt(4);

    print((summoner2.participantOfMatch(2)!.championInfo)['championName']);
    print((summoner2.participantOfMatch(2) as FinishedParticipant)
        .itemsId
        .toString());
    print(summoner2.encryptedSummonerId);
    String summoner2Tier = "";
    try {
      // In this case I am sure that the participant is not unranked, in other cases check for null value
      summoner2Tier = (await ((await summoner2.currentMatch())
                  .redSideTeam
                  .participants()[3] as CurrentParticipant)
              .participantRank())!
          .tier;
    } on DataNotFound {
      print("Player is not playing");
    }
    print(summoner2Tier);
    print(
        '$summonerName is ${summoner.rankSoloDuo == null ? "Unranked" : summoner.rankSoloDuo!.tier}');
    print(
        '$summoner2Name is ${summoner2.rankSoloDuo == null ? "Unranked" : summoner2.rankSoloDuo!.tier}');
  } else {
    print('Invalid summoner name!');
  }
}
