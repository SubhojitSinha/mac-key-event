#!/bin/bash

NEWLINE="\n"
FILE=$1

# FUNCTION TO INTRODUCE RANDOM SEC OF SLEEP
sleeper(){
    duration=$((RANDOM%4))
    sleep $duration
}

# FINCTION TO GENERATE SPECIFIC KEYEVENTS ACCORDING TO PASSED CHARACHTER
keyevent_generator() {
    CHAR=$1

    if [ "$CHAR" == " " ]; then
        xdotool key space
    elif [ "$CHAR" == "!" ]; then
        xdotool key exclam
    elif [ "$CHAR" == "\"" ]; then
        xdotool key quotedbl
    elif [ "$CHAR" == "#" ]; then
        xdotool key numbersign
    elif [ "$CHAR" == "$" ]; then
        xdotool key dollar
    elif [ "$CHAR" == "%" ]; then
        xdotool key percent
    elif [ "$CHAR" == "&" ]; then
        xdotool key ampersand
    elif [ "$CHAR" == "(" ]; then
        xdotool key parenleft
    elif [ "$CHAR" == ")" ]; then
        xdotool key parenright
    elif [ "$CHAR" == "[" ]; then
        xdotool key bracketleft
    elif [ "$CHAR" == "]" ]; then
        xdotool key bracketright
    elif [ "$CHAR" == "*" ]; then
        xdotool key asterisk
    elif [ "$CHAR" == "\\" ]; then
        xdotool key backslash
    elif [ "$CHAR" == "+" ]; then
        xdotool key plus
    elif [ "$CHAR" == "," ]; then
        xdotool key comma
    elif [ "$CHAR" == "-" ]; then
        xdotool key minus
    elif [ "$CHAR" == "_" ]; then
        xdotool key underscore
    elif [ "$CHAR" == "." ]; then
        xdotool key period
    elif [ "$CHAR" == "/" ]; then
        xdotool key slash
    elif [ "$CHAR" == ":" ]; then
        xdotool key colon
    elif [ "$CHAR" == ";" ]; then
        xdotool key semicolon
    elif [ "$CHAR" == "<" ]; then
        xdotool key less
    elif [ "$CHAR" == "=" ]; then
        xdotool key equal
    elif [ "$CHAR" == ">" ]; then
        xdotool key greater
    elif [ "$CHAR" == "?" ]; then
        xdotool key question
    elif [ "$CHAR" == "@" ]; then
        xdotool key at
    elif [ "$CHAR" == "{" ]; then
        xdotool key braceleft
    elif [ "$CHAR" == "}" ]; then
        xdotool key braceright
    elif [ "$CHAR" == "|" ]; then
        xdotool key bar
    elif [ "$CHAR" == "~" ]; then
        xdotool key asciitilde
    elif [ "$CHAR" == "\n" ]; then
        xdotool key Return
    else
        xdotool key $CHAR
    fi
    # https://www.linux.org/threads/xdotool-keyboard.10528/
}

# ITERATE OVE_name(R EVERY CHAR IN THE LINE
char_iterator(){
    LINE=$1
    for (( i=0; i<${#LINE}; i++ )); do
        sleeper .1 1
        CHAR="${LINE:$i:1}"
        keyevent_generator "$CHAR"
    done
}

# --------------------------

# READING THE FILE LINE BY LINE AND GENERATING KEY EVENTS
# VIA FUNCTION CALLS
while read -r LINE; do
    char_iterator "$LINE"
    keyevent_generator "$NEWLINE"
done <$FILE