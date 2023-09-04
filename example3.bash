#!/bin/sh
# Simulates hitting a key on OS X
# http://apple.stackexchange.com/a/63899/72339

# MYSELF="$(realpath "$0")"
# MYDIR="${MYSELF%/*}"
# if [ -z "$1" ]; then
#     FILE="$MYDIR/probs/readfile.php"
# else
#     FILE=$1
# fi

# Usage
# bash ~/Documents/your/script/path/example3.bash /Users/your/reference/document.extention

NEWLINE="\n\r"
FILE=$1

# FUNCTION TO INTRODUCE RANDOM SEC OF SLEEP
sleeper(){
    duration=$(jot -r 1  $1 $2)
    sleep $duration
}

# FINCTION TO GENERATE SPECIFIC KEYEVENTS ACCORDING TO PASSED CHARACHTER
keyevent_generator() {
    CHAR=$1
    if [ "$CHAR" == "\\" ]; then
        # https://macbiblioblog.blogspot.com/2014/12/key-codes-for-function-and-special-keys.html
        echo "tell application \"System Events\" to key code 42" | osascript
    else
        echo "tell application \"System Events\" to keystroke \"$CHAR\"" | osascript
    fi
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
    # echo "tell application \"System Events\" to keystroke \"$NEWLINE\"" | osascript
done <$FILE