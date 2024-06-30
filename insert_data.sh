#!/bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
# looping through games.csv to insert teams into corresponding table
tail -n +2 games.csv | while IFS="," read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
    # Check if the winner already exists in the teams table
    EXISTS_WINNER=$($PSQL "SELECT name FROM teams WHERE name='$WINNER' LIMIT 1")
    EXISTS_OPPONENT=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT' LIMIT 1")

    if [ -z "$EXISTS_WINNER" ]
    then
        # Winner does not exist, so insert into teams
        INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")

        if [[ $INSERT_WINNER == "INSERT 0 1" ]]
        then
            echo "Inserted into teams: $WINNER"
        else
            echo "Failed to insert into teams: $WINNER"
        fi
    else
        echo "Winner $WINNER already exists in teams"
    fi
       if [ -z "$EXISTS_OPPONENT" ]
    then
        # Winner does not exist, so insert into teams
        INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")

        if [[ $INSERT_OPPONENT == "INSERT 0 1" ]]
        then
            echo "Inserted into teams: $OPPONENT"
        else
            echo "Failed to insert into teams: $OPPONENT"
        fi
    else
        echo "Opponent $OPPONENT already exists in teams"
    fi
done

#looping again through games.csv to insert rows into games table
tail -n +2 games.csv | while IFS="," read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
#get the winner id from the team_id in the teams table
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    #get the opponent id from the team_id in the teams table
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    #Insert all rows into the games table  
  INSERT_ROWS=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$WINNER_ID', $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
            if [[ $INSERT_ROWS == "INSERT 0 1" ]]
        then
        #if rows are successfully inserted print the inserted winner and opponent
            echo "Inserted into teams: $WINNER,$OPPONENT"
        else
        #if rows are not successfully inserted, print an error message
            echo "Failed to insert into teams: $WINNER, $OPPONENT"
        fi
        done