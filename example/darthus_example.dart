import 'package:darthus/darthus.dart';
import 'package:darthus/src/darthus_riot_api.dart';
// This file is needed if you want to store the api key in another place so it 
// wont be uploaded to github.
import 'api_key.dart';

void main() async {
  ApiRequest.setApiKey(key: myApiKey);
  final String summonerName = 'zan777', summoner2Name = 'bondighidighi';
  // Check if the summoner name is valid, in order to avoid connection errors
  if (await Summoner.summonerNameIsValid(summonerName)) {
    // Create the summoner object that at the moment it's empty
    Summoner summoner = Summoner('euw1', summonerName);
    Summoner summoner2 = Summoner('euw1', summoner2Name);
    // Retrieve all data about the summoner from Riot API
    await summoner.buildSummoner(); // Now summoner is ready for use
    await summoner2.buildSummoner();

    /*final match = await Match(region: 'europe', matchId: 'EUW1_5877600674')
        .buildFromApi();

    print('Game duration: ${match.gameDurationInMinutes()}');*/

    await summoner2.buildMatchAt(0);
    await summoner2.buildMatchAt(1);
    await summoner2.buildMatchAt(2);
    await summoner2.buildMatchAt(3);
    await summoner2.buildMatchAt(4);
    print((summoner2.participantOfMatch(2)!.championInfo())['championName']);
    print(summoner2.puuid);
    print('$summonerName is ${summoner.rankSolo()}');
    print('$summoner2Name is ${summoner2.rankSolo()}');
  } else {
    print('Invalid summoner name!');
  }
}
