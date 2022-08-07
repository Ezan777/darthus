import 'dart:async';
import 'dart:convert';
import 'dart:io';

String? apiKey;

/// If you want to make your request to a personal server that after redirect
/// the request to riot's servers use this. It's useful if you don't wanna
/// reveal riot's api key.
///
/// If redirectUrl is not null the apiKey will be ignored.
String? redirectUrl;

Function(String riotRequestUrl)? httpCallable;

enum MatchType { ranked, normal }

class DataNotFound implements Exception {}

class BadRequest implements Exception {}

class RateLimitExceeded implements Exception {}

class ApiRequest {
  static void setRedirectUrl({required String url}) {
    redirectUrl = url;
  }

  /// Set the api key for requests
  static void setApiKey({required String key}) {
    apiKey = key;
  }

  static void setHttpCallable(
      {required Function(String riotRequestUrl) callFunction}) {
    httpCallable = callFunction;
  }

  /// Returns a decoded json file containing the result of the http request
  /// made to the given url; the riot api key is added automatically so don't
  /// insert it in the url. Throws exceptions for bad requests and data not found in
  /// other cases of http errors the program print the error code and automatically
  /// crash.
  static Future<dynamic> makeRequest(String url) async {
    try {
      if (redirectUrl == null && httpCallable == null) {
        assert(apiKey != null);
        final HttpClientRequest request =
            await HttpClient().getUrl(Uri.parse(url + apiKey!));
        final HttpClientResponse response = await request.close();
        if (response.statusCode != 200) {
          throw response.statusCode;
        } else {
          final jsonFiles =
              await response.transform(const Utf8Decoder()).toList();
          String jsonString = '';
          for (int i = 0; i < jsonFiles.length; ++i) {
            jsonString += jsonFiles[i];
          }
          final values = jsonDecode(jsonString);
          return values;
        }
      } else {
        if (redirectUrl != null && httpCallable == null) {
          final HttpClientRequest request =
              await HttpClient().getUrl(Uri.parse(redirectUrl! + url));
          final HttpClientResponse response = await request.close();
          if (response.statusCode != 200) {
            throw response.statusCode;
          } else {
            final jsonFiles =
                await response.transform(const Utf8Decoder()).toList();
            String jsonString = '';
            for (int i = 0; i < jsonFiles.length; ++i) {
              jsonString += jsonFiles[i];
            }
            final values = jsonDecode(jsonString);
            return values;
          }
        } else {
          return httpCallable!(url);
        }
      }
    } on SocketException {
      print("Socket exception!");
      rethrow;
    } on FormatException {
      print("Format exception!");
      rethrow;
    } catch (e) {
      switch (e as int) {
        case 400:
          throw BadRequest();
        case 404:
          throw DataNotFound();
        case 429:
          throw RateLimitExceeded();
        default:
          // Serious errors
          print('Serious error occurred with the http request, error code: $e');
          exit(1);
      }
    }
  }

  /// Returns the json file containing all summoner info
  static Future<Map<String, dynamic>> summonerInformation(
      String region, String summonerName) async {
    return await makeRequest('https://'
        '$region.api.riotgames.com/lol/summoner/v4/summoners/'
        'by-name/$summonerName?'
        'api_key=');
  }

  /// Returns a Future<String> containing the Puuid of the user with
  /// the given [summonerName].
  static Future<String> puuidFromSummonerName(
      String region, String summonerName) async {
    final Map<String, dynamic> jsonMapped = await makeRequest('https://'
        '$region.api.riotgames.com/lol/summoner/v4/summoners/'
        'by-name/$summonerName?'
        'api_key=');
    return jsonMapped['puuid'];
  }

  /// Returns a Future<String> containing the encrypted summonerID
  static Future<String> summonerIdFromSummonerName(
      String region, String summonerName) async {
    final Map<String, dynamic> jsonMapped = await makeRequest('https://'
        '$region.api.riotgames.com/lol/summoner/v4/summoners/'
        'by-name/$summonerName?'
        'api_key=');
    return jsonMapped['id'];
  }

  /// Returns a list of Json file containing all information about the player's rank.
  ///
  /// Every file in the list contains information for a certain type of queue,
  /// to know the type of queue you can use list[[fileIndex]][['queueType']].
  ///
  /// If the list is empty it means that the player is unranked.
  static Future<List<dynamic>> rankedInformation(
      String region, String encryptedSummonerId) async {
    return await makeRequest('https://'
        '$region.api.riotgames.com/lol/league/v4/entries/by-summoner/'
        '$encryptedSummonerId?api_key=');
  }

  /// Returns a Json file containing all the information about player in solo duo
  /// queue.
  static Future<Map<String, dynamic>> rankedSoloDuoInfo(
      String region, String encryptedSummonerId) async {
    final jsonList = await rankedInformation(region, encryptedSummonerId);
    return jsonList[0];
  }

  /// Returns a Json file containing all the information about player in flex queue
  static Future<Map<String, dynamic>> rankedFlexInfo(
      String region, String encryptedSummonerId) async {
    final jsonList = await rankedInformation(region, encryptedSummonerId);
    return jsonList[1];
  }

  /// Return a list of matches with the following filters: [numberOfMatches] is the number of matches
  /// that the request is going to retrieve, it must be 0 <= [numberOfMatches] <= 100 otherwise it will use the default value 20;
  /// [type] represents what matches are we going to retrieve.
  static Future<List<dynamic>> listOfMatches(
      {required String region,
      required String puuid,
      int numberOfMatches = 20,
      MatchType? type}) async {
    if (numberOfMatches < 0 || numberOfMatches > 100) {
      numberOfMatches = 20;
    }

    switch (type) {
      case MatchType.ranked:
        return await makeRequest(
            'https://$region.api.riotgames.com/lol/match/v5/matches/by-puuid/'
            '$puuid'
            '/ids?type=ranked&start=0&count=$numberOfMatches&api_key=');
      case MatchType.normal:
        return await makeRequest(
            'https://$region.api.riotgames.com/lol/match/v5/matches/by-puuid/'
            '$puuid'
            '/ids?type=normal&start=0&count=$numberOfMatches&api_key=');
      default:
        return await makeRequest(
            'https://$region.api.riotgames.com/lol/match/v5/matches/by-puuid/'
            '$puuid'
            '/ids?start=0&count=$numberOfMatches&api_key=');
    }
  }

  /// Returns all match's info, a json file with metadata and info.
  static Future<Map<String, dynamic>> allMatchInfo(
      String region, String matchCode) async {
    return await makeRequest('https://'
        '$region.api.riotgames.com/lol/match/v5/matches/'
        '$matchCode?api_key=');
  }

  /// Returns the participant at position [index] in the match identified by [matchCode]
  Future<Map<String, dynamic>> getParticipant(
      String region, String matchCode, int index) async {
    return (await allMatchInfo(region, matchCode))['info']['participants']
        [index];
  }

  /// Returns the current match played for the given summonerId, if he is not currently playing
  /// it will throw DataNotFound exception
  static Future<Map<String, dynamic>> currentMatch(
      String encryptedSummonerId, String region) async {
    return await (makeRequest(
        'https://$region.api.riotgames.com/lol/spectator/v4/active-games/by-summoner/$encryptedSummonerId?api_key='));
  }
}
