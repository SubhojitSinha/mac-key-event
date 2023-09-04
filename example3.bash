#!/bin/sh
# Simulates hitting a key on OS X
# http://apple.stackexchange.com/a/63899/72339

MYSELF="$(realpath "$0")"
MYDIR="${MYSELF%/*}"
file="$MYDIR/probs/readfile.php"
NEWLINE="\n\r"


sleeper(){
    lt=$(jot -r 1  $1 $2)
    sleep $lt
}

keyevent_generator() {
    LINE=$1
    for (( i=0; i<${#LINE}; i++ )); do
        sleeper .1 1
        letter="${LINE:$i:1}"

        if [ "$letter" == "\\" ]; then
            # https://macbiblioblog.blogspot.com/2014/12/key-codes-for-function-and-special-keys.html
            echo "tell application \"System Events\" to key code 42" | osascript
        else
            echo "tell application \"System Events\" to keystroke \"$letter\"" | osascript
        fi
    done
}

# --------------------------


while read -r line; do
    keyevent_generator "$line"
    echo "tell application \"System Events\" to keystroke \"$NEWLINE\"" | osascript
done <$file