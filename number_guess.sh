#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t -A -F"," -c"

TARGET_NUMBER=$(( (RANDOM % 1000) + 1 ))

echo "Enter your username:"
read USERNAME

DB_USERNAME=$($PSQL "SELECT username FROM guess_game WHERE username = '$USERNAME'")
DB_GAMES_PLAYED=$($PSQL "SELECT games_played FROM guess_game WHERE username = '$USERNAME'")
DB_BEST_GAME=$($PSQL "SELECT best_game FROM guess_game WHERE username = '$USERNAME'")

if [[ -z $DB_USERNAME ]]
then
  echo "Welcome, $USERNAME! It looks like this is your first time here."
else
  echo "Welcome back, $DB_USERNAME! You have played $DB_GAMES_PLAYED games, and your best game took $DB_BEST_GAME guesses."
fi
