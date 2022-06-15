import 'package:dartius/dartius.dart';

void main() async {
  final String summonerName = 'zan777';
  // Check if the summoner name is valid, in order to avoid connection errors
  if (await Summoner.summonerNameIsValid(summonerName)) {
    // Create the summoner object that at the moment it's empty
    Summoner summoner = Summoner('euw1', summonerName);
    // Retrieve all data about the summoner from Riot API
    await summoner.buildSummoner(); // Now summoner is ready for use

    print('$summonerName is ${summoner.rankSolo()}');
  } else {
    print('Invalid summoner name!');
  }
}
