import 'package:dartius/dartius.dart';

void main() async {

  if (await Summoner.summonerNameIsValid('zan777')) {
    Summoner summoner = Summoner('euw1', 'zan777');
    await summoner.buildSummoner();
    summoner.printRankSolo();
  } else {
    print('Invalid summoner name!');
  }
  
}
