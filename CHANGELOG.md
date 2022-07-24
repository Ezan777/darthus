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