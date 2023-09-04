#!/bin/sh
# Simulates hitting a key on OS X
# http://apple.stackexchange.com/a/63899/72339
echo "started..."
var="abcdefghijklmnopqrstuvwxyz123456789 +-*"
while true
do
  # set a array of charachters 
  letter="${var:$(( RANDOM % ${#var} )):1}"
  
  # Send the keyboard events 
  echo "tell application \"System Events\" to keystroke \"$letter\"" | osascript

  # Get a random number between 1 to 3
  t=$(jot -r 1  1 3)

  # Execute sleep for the above random sec
  sleep $t

  # for letter in {a..z} ; do
  #   echo $letter
  #   echo "tell application \"System Events\" to keystroke \"$letter\"" | osascript
  #   sleep 5
  # done
done
