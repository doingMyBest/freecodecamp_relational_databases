#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

# Do not change code above this line. Use the PSQL variable above to query your database.

echo -e "\nTotal number of goals in all games from winning teams:"

echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

echo -e "\nTotal number of goals in all games from both teams combined:"
echo "$($PSQL "SELECT SUM(winner_goals + opponent_goals) as combined_sum FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams:"
echo "$($PSQL "SELECT AVG(winner_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo "$($PSQL "SELECT ROUND(AVG(winner_goals),2) FROM games")"

echo -e "\nAverage number of goals in all games from both teams:"
echo "$($PSQL "SELECT AVG(winner_goals + opponent_goals) AS average_total_goals
FROM games")"

echo -e "\nMost goals scored in a single game by one team:"
echo "$($PSQL "SELECT MAX(winner_goals) FROM games")"

echo -e "\nNumber of games where the winning team scored more than two goals:"
echo "$($PSQL "SELECT COUNT(winner_goals) FROM games WHERE winner_goals > 2")"

echo -e "\nWinner of the 2018 tournament team name:"
echo "$($PSQL "SELECT teams.name FROM teams JOIN games ON teams.team_id = games.winner_id WHERE games.year = 2018 AND games.round = 'Final'")"

echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
echo "$($PSQL "SELECT teams.name FROM teams JOIN games AS winning_team ON teams.team_id = winning_team.winner_id WHERE winning_team.round = 'Eighth-Final' AND winning_team.year = 2014  UNION SELECT teams.name FROM teams JOIN games AS losing_team ON teams.team_id = losing_team.opponent_id WHERE losing_team.round = 'Eighth-Final' AND losing_team.year = 2014")"

echo -e "\nList of unique winning team names in the whole data set:"
echo "$($PSQL "SELECT DISTINCT teams.name FROM teams JOIN games ON teams.team_id = games.winner_id ORDER BY teams.name ASC")"

echo -e "\nYear and team name of all the champions:"
echo "$($PSQL "SELECT CONCAT(year, ' | ', teams.name) AS display_text FROM games JOIN teams ON teams.team_id = games.winner_id WHERE games.round = 'Final' ORDER BY teams.name DESC")"

echo -e "\nList of teams that start with 'Co':"
echo "$($PSQL "SELECT teams.name FROM teams JOIN games AS winning_team ON teams.team_id = winning_team.winner_id WHERE teams.name ILIKE 'CO%' UNION SELECT teams.name FROM teams JOIN games AS losing_team ON teams.team_id = losing_team.opponent_id WHERE teams.name ILIKE 'CO%'")"
