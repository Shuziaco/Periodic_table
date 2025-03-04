#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z "$1" ]]
then 
  echo "Please provide an element as an argument."
else
  if [[ "$1" =~ ^[0-9]+$ ]]
  then 
    # if $1 is numeric use it directly
    element=$($PSQL "select * from properties as p INNER JOIN elements as e USING(atomic_number) WHERE p.atomic_number = $1")
  else
    # if $1 is symbol or name
    element=$($PSQL "select * from properties as p INNER JOIN elements as e USING(atomic_number) WHERE e.symbol = '$1' OR e.name = '$1'")
  fi
  if [[ -z $element ]]
  then
    echo I could not find that element in the database.
  else 
    IFS='|' read -r atomic_num mass melting_point boiling_point type_id symbol name <<< "$element"
    type=$($PSQL "SELECT type FROM types WHERE type_id = $type_id")
    echo "The element with atomic number $atomic_num is $name ($symbol). It's a $type, with a mass of $mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius." | sed 's/^*//g'
  fi  
fi