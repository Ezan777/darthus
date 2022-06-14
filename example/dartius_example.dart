import 'package:dartius/dartius.dart';

void main() async {
  const region = 'euw1';
  bool goodConnection;
  String?
      encryptedSummonerId; //= await getSummonerIdFromSummonerName(region, 'zan777');
  try {
    encryptedSummonerId = await summonerIdFromSummonerName(region, 'zan777');
    goodConnection = true;
  } on BadRequest {
    print('Bad request!');
    goodConnection = false;
  } on DataNotFound {
    print('Data not found!');
    goodConnection = false;
  }

  print("Started");
  if (goodConnection && encryptedSummonerId != null) {
    print(encryptedSummonerId);
    try {
      print((await rankedSoloDuoInfo(region, encryptedSummonerId))['tier']);
    } on BadRequest {
      print('Bad request!');
      goodConnection = false;
    } on DataNotFound {
      print('Data not found!');
      goodConnection = false;
    }
  }
  print(await Summoner.summonerNameIsValid('zan777'));
  print("Finished");
}
