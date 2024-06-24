#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ $# -eq 0 ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi

if [[ $1 =~ ^([1-9]|10)$ ]]; 
then
  ATOMIC_NUM=$1
  TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties USING(type_id) WHERE atomic_number = $ATOMIC_NUM")
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ATOMIC_NUM")
  NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ATOMIC_NUM")
  MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUM")
  MELT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUM")
  BOIL=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUM")
elif [[ $1 =~ ^[A-Z]$ || $1 =~ ^[A-Z][a-z]$ ]];
then
  SYMBOL=$1
  ATOMIC_NUM=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$SYMBOL'")
  if [[ ! -z $ATOMIC_NUM ]]
  then
    TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties USING(type_id) WHERE atomic_number = $ATOMIC_NUM")
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ATOMIC_NUM")
    MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUM")
    MELT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUM")
    BOIL=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUM")
  fi
elif [[ $1 =~ ^[A-Z][a-z]*$ ]];
then
  NAME=$1
  ATOMIC_NUM=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$NAME'")
  if [[ ! -z $ATOMIC_NUM ]]
  then
    TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties USING(type_id) WHERE atomic_number = $ATOMIC_NUM")
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ATOMIC_NUM")
    MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUM")
    MELT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUM")
    BOIL=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUM")
  fi
fi

if [[ ! -z $ATOMIC_NUM ]]
then
  echo "The element with atomic number $ATOMIC_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
else 
  echo "I could not find that element in the database."
fi
# The element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius.

