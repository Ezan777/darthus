## 1.0.0

- Initial version.

## 1.0.1

- Now getters methods rankSoloDuo and rankFlex of Summoner class will return an object of type Rank instead of a String.

## 1.2.0

- Changed Match and Participant classes into abstract classes. Created CurrentMatch, CurrentParticipant, FinishedMatch and FinishedParticipant classes to implement live match feature.

- Implemented Live Match feature, now from the summoner it is possible to obtain the live match, only if he is playing, if he is not a DataNotFound exception will be thrown.

## 1.2.1

- Fixed a bug of the method getMatches in Summoner class, now _matchHistory will be empty before adding new matches.

## 1.2.2

- Added RateLimitExceeded exception on api request it will be thrown if the user exceed the request rate limit set by riot games for the api key.

## 1.2.3 

- Added some getters for FinishedParticipants

## 1.2.4

- Added a method to retrieve matchType from a FinishedMatch

## 1.2.5

- Added a method to get the summoner spells names from participant

## 1.2.6

- Added assets

## 1.2.7

- Assets didn't work, tring to fix

## 1.2.8

- Assets should work now

## 1.2.9

- Version 1.2.8 crashed

## 1.2.10

- Finally solved Assets problem

## 1.2.11

- Bugs fixed

## 1.2.12

- There is no way to achieve what I was trying to do so now the summonerSpellsNames now require a path to json file as parameter.

## 1.2.13

- Since is impossible to parse local json files in the package while it's executing inside the application I removed summonerSpellsNames method. Now if you want summoner spells names you have to parse Riot's json by your own and use the summoner spells ids as identifier.

## 1.2.14

- Added some attributes and their getters to the FinishedParticipant class, these attributes concern the damage dealt and taken by the participant.

## 1.2.15

- Fixed some bugs

## 1.2.16

- Fixed some bugs

## 1.2.17

- Added some getters to retrieve max damage dealt, taken and self mitgated by a FinishedTeam class derived from Team class

## 1.2.18

- Adjusted exports

## 1.2.19

- Due to some problems with tyoe casting Finished Team class has been deleted and max damages methods are now inside of FInished Match class.