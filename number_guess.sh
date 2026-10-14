#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t -A -F"," -c"

TARGET_NUMBER=$(( (RANDOM % 1000) + 1 ))
echo "$TARGET_NUMBER"

echo "Enter your username:"
read USERNAME

DB_USERNAME=$($PSQL "SELECT username FROM guess_game WHERE username = '$USERNAME'")
DB_GAMES_PLAYED=$($PSQL "SELECT games_played FROM guess_game WHERE username = '$USERNAME'")
DB_BEST_GAME=$($PSQL "SELECT best_game FROM guess_game WHERE username = '$USERNAME'")
GAMES_PLAYED=0
BEST_GAME=0

if [[ -z $DB_USERNAME ]]
then
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  echo -e "\nGuess the secret number between 1 and 1000:"
  while [[ $TARGET_NUMBER != $NUMBER ]]
  do
    read NUMBER
    if [[ $TARGET_NUMBER > $NUMBER ]]
    then
      echo -e "\nIt's higher than that, guess again:"
      (( BEST_GAME += 1 ))
    elif [[ $TARGET_NUMBER < $NUMBER ]]
    then
      echo -e "\nIt's lower than that, guess again:"
      (( BEST_GAME += 1 ))
    elif [[ ! "$NUMBER" =~ ^-?[0-9]+$ ]]
    then
      echo -e "\nThat is not an integer, guess again:"
      (( BEST_GAME += 1 ))
    fi
  done
  (( BEST_GAME += 1 ))
  (( GAME_PLAYED += 1 ))
  INSERT_INFO=$($PSQL "INSERT INTO guess_game(username,games_played,best_game) VALUES('$USERNAME',$GAMES_PLAYED,$BEST_GAME)")
  echo -e "\nYou guessed it in $BEST_GAME tries. The secret number was $TARGET_NUMBER. Nice job!"
else
  echo "Welcome back, $DB_USERNAME! You have played $DB_GAMES_PLAYED games, and your best game took $DB_BEST_GAME guesses."
fi
