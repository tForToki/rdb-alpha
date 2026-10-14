#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t -A -F"," -c"
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
fi
