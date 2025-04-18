#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

# Check if an argument is provided
if [ -z "$1" ]; then
  echo "Please provide an element as an argument."
  exit 0
fi

# Query the database and get output as pipe-delimited and trimmed
element_data=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius, t.type
                      FROM elements e
                      JOIN properties p ON e.atomic_number = p.atomic_number
                      JOIN types t ON p.type_id = t.type_id
                      WHERE e.atomic_number::TEXT = '$1'
                        OR e.symbol = INITCAP('$1')
                        OR e.name = INITCAP('$1');
                      ")

# Check if the result is empty
if [ -z "$element_data" ]; then
  echo "I could not find that element in the database."
  exit 0
fi

# Read the pipe-delimited result into variables
IFS="|" read atomic_number symbol name atomic_mass melting_point boiling_point type <<< "$element_data"

# Output the formatted result
echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."


