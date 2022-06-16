import 'package:dartius/dartius.dart';
import 'package:dartius/src/dartius_riot_api.dart';

void main() async {
  final String summonerName = 'zan777', summoner2Name = 'bondighidighi';
  // Check if the summoner name is valid, in order to avoid connection errors
  if (await Summoner.summonerNameIsValid(summonerName)) {
    // Create the summoner object that at the moment it's empty
    Summoner summoner = Summoner('euw1', summonerName);
    Summoner summoner2 = Summoner('euw1', summoner2Name);
    // Retrieve all data about the summoner from Riot API
    await summoner.buildSummoner(); // Now summoner is ready for use
    await summoner2.buildSummoner();

    final int gameDuration =
        (await allMatchInfo('europe', 'EUW1_5877600674'))['info']
            ['gameDuration'] as int;
    print(
        'Game duration: ${gameDuration~/60}:${((gameDuration / 60 - gameDuration ~/ 60) * 60).toInt()} minutes');
    print('$summonerName is ${summoner.rankSolo()}');
    print('$summoner2Name is ${summoner2.rankSolo()}');
  } else {
    print('Invalid summoner name!');
  }
}
