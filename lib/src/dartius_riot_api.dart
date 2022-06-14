import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dartius_summoner.dart';

const apiKey = 'RGAPI-28c22536-bb59-48b9-87a3-e39892039fe4';

class DataNotFound implements Exception {}

class BadRequest implements Exception {}

/// Returns a decoded json file containing the result of the http request
/// made to the given url; the riot api key is added automatically so don't
/// insert it in the url. Throws exceptions for bad requests and data not found in
/// other cases of http errors the program print the error code and automatically
/// crash.
Future<dynamic> makeRequest(String url) async {
  try {
    final HttpClientRequest request =
        await HttpClient().getUrl(Uri.parse(url + apiKey));
    final HttpClientResponse response = await request.close();
    if (response.statusCode != 200) {
      throw response.statusCode;
    } else {
      final jsonFiles = await response.transform(const Utf8Decoder()).toList();
      final String jsonString = jsonFiles.first;
      final values = jsonDecode(jsonString);
      return values;
    }
  } catch (e) {
    switch (e as int) {
      case 400:
        throw BadRequest();
        break;
      case 404:
        throw DataNotFound();
        break;
      default:
        // Serious errors
        print('Serious error occurred with the http request, error code: $e');
        exit(1);
    }
    exit(1);
  }
}

/// Returns the json file containing all summoner info
Future<Map<String, dynamic>> summonerInformation(
    String region, String summonerName) async {
  return await makeRequest('https://'
      '$region.api.riotgames.com/lol/summoner/v4/summoners/'
      'by-name/$summonerName?'
      'api_key=');
}

/// Returns a Future<String> containing the Puuid of the user with
/// the given [summonerName].
Future<String> puuidFromSummonerName(String region, String summonerName) async {
  final Map<String, dynamic> jsonMapped = await makeRequest('https://'
      '$region.api.riotgames.com/lol/summoner/v4/summoners/'
      'by-name/$summonerName?'
      'api_key=');
  return jsonMapped['puuid'];
}

/// Returns a Future<String> containing the encrypted summonerID
Future<String> summonerIdFromSummonerName(
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
Future<List<dynamic>> rankedInformation(
    String region, String encryptedSummonerId) async {
  return await makeRequest('https://'
      '$region.api.riotgames.com/lol/league/v4/entries/by-summoner/'
      '$encryptedSummonerId?api_key=');
}

/// Returns a Json file containing all the information about player in solo duo
/// queue.
Future<Map<String, dynamic>> rankedSoloDuoInfo(
    String region, String encryptedSummonerId) async {
  final jsonList = await rankedInformation(region, encryptedSummonerId);
  return jsonList[0];
}

/// Returns a Json file containing all the information about player in flex queue
Future<Map<String, dynamic>> rankedFlexInfo(
    String region, String encryptedSummonerId) async {
  final jsonList = await rankedInformation(region, encryptedSummonerId);
  return jsonList[1];
}
