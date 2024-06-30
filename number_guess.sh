#!/bin/bash

# Initialize PSQL variable
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# Ask for username and read it in
echo "Enter your username:"
read USERNAME

# Search for username in the database
EXISTING_USER=$($PSQL "SELECT name FROM users WHERE name = '$USERNAME'")

#if it is not existing, then welcome message and insert a new row
if [ -z "$EXISTING_USER" ]; then
  $PSQL "INSERT INTO users(name) VALUES ('$USERNAME')" > /dev/null 2>&1
  GAMES_PLAYED=0
  BEST_GAME=0
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  #otherwise print name, games played and best games
else
#if it is existing, welcoming the user back
  GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE name = '$USERNAME'")
  BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE name = '$USERNAME'")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

#create random number between 1 and 1000
SECRET_NUMBER=$(( $RANDOM % 1000 + 1 ))
#let the user guess the number and read it in
echo "Guess the secret number between 1 and 1000:"
read USER_NUMBER
COUNT=1
#echo $SECRET_NUMBER
#if the number is not the secret number
while [[ $USER_NUMBER -ne $SECRET_NUMBER ]]
do
#if the number is an integer
  if [[ $USER_NUMBER =~ ^[0-9]+$ ]]; then
    #if the user number is higher than the secret number
    if [ $USER_NUMBER -lt $SECRET_NUMBER ]; then
      COUNT=$((COUNT + 1))
      echo "It's higher than that, guess again:"
      read USER_NUMBER
    #if the user number is lower than the secret number
    elif [ $USER_NUMBER -gt $SECRET_NUMBER ]; then
      COUNT=$((COUNT + 1))
      echo "It's lower than that, guess again:"
      read USER_NUMBER
    fi
  else
    COUNT=$((COUNT + 1))
    echo "That is not an integer, guess again:"
    read USER_NUMBER
  fi
done

#once the secret number has been guessed
echo "You guessed it in $COUNT tries. The secret number was $SECRET_NUMBER. Nice job!"
GAMES_PLAYED=$((GAMES_PLAYED + 1))
$PSQL "UPDATE users SET games_played = '$GAMES_PLAYED' WHERE name = '$USERNAME'" > /dev/null 2>&1

if [[ $BEST_GAME -eq 0 ]]; then
  BEST_GAME=$COUNT
  $PSQL "UPDATE users SET best_game = '$BEST_GAME' WHERE name = '$USERNAME'" > /dev/null 2>&1
else
  BEST_GAME_TABLE=$($PSQL "SELECT best_game FROM users WHERE name = '$USERNAME'")
  if [[ $BEST_GAME_TABLE -gt $COUNT ]]; then
    $PSQL "UPDATE users SET best_game = '$COUNT' WHERE name = '$USERNAME'" > /dev/null 2>&1
  fi
fi





