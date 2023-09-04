#!/bin/sh
# Simulates hitting a key on OS X
# http://apple.stackexchange.com/a/63899/72339

var="Basically, for non-default non-null values of $IFS,
    fields can be separated with either (1) a sequence of one

    or more characters that are all from the set of 'IFS whitespace characters'
    (that is, whichever of <space>, <tab>, and <newline> ("newline" meaning line feed (LF))
    are present anywhere in $IFS), or (2) any non-'IFS whitespace character' that's present
    in $IFS along with whatever 'IFS whitespace characters' surround it in the input line.
    For the OP, it's possible that the second separation mode I described in the previous
    paragraph is exactly what he wants for his input string, but we can be pretty confident
    that the first separation mode I described is not correct at all. For example, what if
    his input string was 'Los Angeles, United States, North America'? Even if you were to use
    this solution with a single-character separator (such as a comma by itself, that is, with
    no following space or other baggage), if the value of the $string variable happens to contain
    any LFs, then read will stop processing once it encounters the first LF. The read builtin only
    processes one line per invocation. This is true even if you are piping or redirecting input only
    to the read statement, as we are doing in this example with the here-string mechanism, and thus
    unprocessed input is guaranteed to be lost. The code that powers the read builtin has no knowledge
    of the data flow within its containing command structure. You could argue that this is unlikely to
    cause a problem, but still, it's a subtle hazard that should be avoided if possible. It is caused
    by the fact that the read builtin actually does two levels of input splitting: first into lines,
    then into fields. Since the OP only wants one level of splitting, this usage of the read builtin is
    not appropriate, and we should avoid it. 3: A non-obvious potential issue with this solution is that
    read always drops the trailing field if it is empty, although it preserves empty fields otherwise.
    Here's a demo These solutions leverage word splitting in an array assignment to split the string into
    fields. Funnily enough, just like read, general word splitting also uses the $IFS special variable,
    although in this case it is implied that it is set to its default value of <space><tab><newline>, and
    therefore any sequence of one or more IFS characters (which are all whitespace characters now) is considered
    to be a field delimiter. This solves the problem of two levels of splitting committed by read, since
    word splitting by itself constitutes only one level of splitting. But just as before, the problem here
    is that the individual fields in the input string can already contain $IFS characters, and thus they
    would be improperly split during the word splitting operation. This happens to not be the case for any
    of the sample input strings provided by these answerers (how convenient...), but of course that doesn't
    change the fact that any code base that used this idiom would then run the risk of blowing up if this
    assumption were ever violated at some point down the line. Once again, consider my counterexample of
    'Los Angeles, United States, North America' (or 'Los Angeles:United States:North America'). Also, word splitting
    is normally followed by filename expansion (aka pathname expansion aka globbing), which, if done, would
    potentially corrupt words containing the characters *, ?, or [ followed by ] (and, if extglob is set,
    parenthesized fragments preceded by ?, *, +, @, or !) by matching them against file system objects and
    expanding the words ("globs") accordingly. The first of these three answerers has cleverly undercut this
    problem by running set -f beforehand to disable globbing. Technically this works (although you should probably
    add set +f afterward to reenable globbing for subsequent code which may depend on it), but it's undesirable to
    have to mess with global shell settings in order to hack a basic string-to-array parsing operation in local code.
    Another issue with this answer is that all empty fields will be lost. This may or may not be a problem, depending
    on the application. Note: If you're going to use this solution, it's better to use the 'pattern substitution'
    form of parameter expansion, rather than going to the trouble of invoking a command substitution (which forks the shell),
    starting up a pipeline, and running an external executable (tr or sed), since parameter expansion is purely a shell-internal
    operation. (Also, for the tr and sed solutions, the input variable should be double-quoted inside the command substitution;
    otherwise word splitting would take effect in the echo command and potentially mess with the field values. Also, the text form
    of command substitution is preferable to the old text form since it simplifies nesting of command substitutions and allows
    for better syntax highlighting by text editors.) This answer is almost the same as #2. The difference is that the answerer
    has made the assumption that the fields are delimited by two characters, one of which being represented in the default $IFS,
    \and the other not. He has solved this rather specific case by removing the non-IFS-represented character using a pattern
    substitution expansion and then using word splitting to split the fields on the surviving IFS-represented delimiter character.
    This is not a very generic solution. Furthermore, it can be argued that the comma is really the "primary" delimiter character
    here, and that stripping it and then depending on the space character for field splitting is simply wrong. Once again, consider
    my counterexample: 'Los Angeles, United States, North America'. Also, again, filename expansion could corrupt the expanded words,
    but this can be prevented by temporarily disabling globbing for the assignment with set -f and then set +f. Also, again, all empty
    fields will be lost, which may or may not be a problem depending on the application. This is similar to #2 and #3 in that it uses
    word splitting to get the job done, only now the code explicitly sets $IFS to contain only the single-character field delimiter
    present in the input string. It should be repeated that this cannot work for multicharacter field delimiters such as the OP's
    comma-space delimiter. But for a single-character delimiter like the LF used in this example, it actually comes close to being
    perfect. The fields cannot be unintentionally split in the middle as we saw with previous wrong answers, and there is only one
    level of splitting, as required. One problem is that filename expansion will corrupt affected words as described earlier, although
    once again this can be solved by wrapping the critical statement in set -f and set +f. Another potential problem is that, since LF
    qualifies as an 'IFS whitespace character' as defined earlier, all empty fields will be lost, just as in #2 and #3. This would of
    course not be a problem if the delimiter happens to be a non-IFS whitespace character, and depending on the application it may not
    matter anyway, but it does vitiate the generality of the solution."

array=($(echo "$var" | tr ',' '\n'))
space=" "
newline="\r"
counter=0
break_feed=10 #newline after words
# echo "${array[2]}"
for index in "${!array[@]}"; do
    ((counter++))
    word="${array[index]}"

    for ((i=0;i<${#word};i++)); do
        lt=$(jot -r 1  .1 1)
        sleep $lt

        letter=${word:i:1}
        # echo $letter
        echo "tell application \"System Events\" to keystroke \"$letter\"" | osascript
    done
    # echo $word." - "
    # echo "$index ${array[index]}"

    # echo " "
    if [ $counter -eq $break_feed ]; then
        counter=0
        echo "tell application \"System Events\" to keystroke \"$newline\"" | osascript
    else
        echo "tell application \"System Events\" to keystroke \"$space\"" | osascript
    fi

    t=$(jot -r 1  .1 2)
    sleep $t
done