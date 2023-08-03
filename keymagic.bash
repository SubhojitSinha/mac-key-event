#!/bin/sh
# Simulates hitting a key on OS X
# http://apple.stackexchange.com/a/63899/72339
echo "started..."
while true
do
  var="abcdefghijklmnopqrstuvwxyz123456789 +-*"
  letter="${var:$(( RANDOM % ${#var} )):1}"
  #echo $n
  echo "tell application \"System Events\" to keystroke \"$letter\"" | osascript

  t=$(jot -r 1  1 3)
  #echo $t
  sleep $t

  # for letter in {a..z} ; do
  #   echo $letter
  #   echo "tell application \"System Events\" to keystroke \"$letter\"" | osascript
  #   sleep 5
  # done
done