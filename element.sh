#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t -A -F"," -c"
if [[ -z $1 ]]
then

  echo "Please provide an element as an argument."

else
  if [[ $1  =~ ^[1-10]$ ]]
  then

    QUERY_INT=$($PSQL "SELECT properties.atomic_number,elements.symbol,
        elements.name,type,atomic_mass,melting_point_celsius,boiling_point_celsius 
        FROM properties LEFT JOIN elements ON properties.atomic_number = elements.atomic_number
        LEFT JOIN types ON properties.type_id = types.type_id 
        WHERE properties.atomic_number = $1;")
    echo "$QUERY_INT" | while IFS="," read -r ATOMIC_NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
    do 

      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    
    done
  
  elif [[ $($PSQL "SELECT elements.symbol
       FROM properties LEFT JOIN elements ON properties.atomic_number = elements.atomic_number LEFT JOIN types ON properties.type_id = types.type_id 
       WHERE symbol = '$1' OR name = '$1';") = $1 || $($PSQL "SELECT elements.name
       FROM properties LEFT JOIN elements ON properties.atomic_number = elements.atomic_number LEFT JOIN types ON properties.type_id = types.type_id
       WHERE symbol = '$1' OR name = '$1';") = $1 ]]
  then

    QUERY_CHAR=$($PSQL "SELECT properties.atomic_number,elements.symbol,
        elements.name,type,atomic_mass,melting_point_celsius,boiling_point_celsius 
        FROM properties LEFT JOIN elements ON properties.atomic_number = elements.atomic_number LEFT JOIN types ON properties.type_id = types.type_id 
        WHERE symbol = '$1' OR name = '$1';")
    echo "$QUERY_CHAR" | while IFS="," read -r ATOMIC_NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
    do 

      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."

    done    
  
  else

    echo "I could not find that element in the database."

  fi
fi
