# README

# What this Project about?

War Card app is a backend command lines to run the War Card game.

# WarCard

War Card is a game which expect two or four players. The game will keep getting rounds between players till one of them has 52 cards.

The game rules:

● A standard 52-card playing card deck is divided evenly amongst two or four
players. (Each player’s deck is 26 cards for a two-player game, 13 cards for a fourplayer
game, etc.)

● Players go through their decks in a series of rounds until one player has all 52
cards, at which point the game ends and the player with all the cards is the winner.

● If there are more than two players, then a player can be eliminated if they run out of
cards. The game continues as usual with the remaining players until there is a
winner.

● A round consists of the following:

A. Each player puts into play the top card of their deck face up.

B. The player with the face up card of the highest rank wins all the cards in play,
and places them at the bottom of their deck in any order. This concludes the
round.

C. If two or more players have equal highest-rank face up cards, those players put
into play three cards from the top of their decks face down, then repeat steps A
and B above. If two or more players have equal highest-rank face up cards
again, repeat step C as many times as needed for the round to conclude.

D. If any player would run out of cards in the middle of a round, then that player
plays their last card face up, and that card serves as the player’s face up card
for the remainder of the round.
    
● An ace is treated as the highest rank card (followed by king, queen, jack, 10, 9, etc.)

● Suits (hearts, diamonds, spades, clubs) are not relevant to the game.

# About the code

Game code is placed under `lib/war_card` folder

Test cases located under `spec/lib/war_card` folder

To run the test

```
bundle exec rspec
```

# How to play the game?

In Terminal, navigate to the project folder

run console

```
rails c
```

run the game

```
WarCard::Game.start
```

The game will ask you to enter number of the players (2 or 4 only). Once you enter it, press Enter and the game will start.

Have Fun :)


