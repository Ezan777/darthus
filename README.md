<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

Dartius is a package that aim to give an easy and intuitive access to league of legends API.

## Features

This package can retrieve information for a summoner and his matches.

## Usage

Before using the package remeber set your api key like that:

```dart
ApiRequest.setApiKey(myApyKey);
```

Since constructors can't be async you must invoke the function buildSummoner before using a summoner instance.

```dart
// Creating an instance of the summoner class
Summoner summoner('euw1', 'summonerName');
// Getting all data from servers (async method)
await summoner.buildSummoner;
```

The *buildSummoner* method will retrieve a list with the last 20 matches played by the summoner (default request), if you want you can call the *getMatches* method where you can choose the number of matches (max 100) and what type of matches the server is going to send you. The type of matches must be specified using the *matchType* enum, like this:

```dart
matchType.normal;
matchType.ranked;
```

## Additional information

If you desire you can contribute to the package: https://www.github.com/Ezan777/dartius
