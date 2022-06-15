import 'package:dartius/dartius.dart';

void main() async {
  // Check if the summoner name is valid, in order to avoid connection errors
  if (await Summoner.summonerNameIsValid('zan777')) {
    // Create the summoner object that at the moment it's empty
    Summoner summoner = Summoner('euw1', 'zan777');
    // Retrieve all data about the summoner from Riot API
    await summoner.buildSummoner(); // Now summoner is ready for use

    summoner.printRankSolo();
  } else {
    print('Invalid summoner name!');
  }
}
