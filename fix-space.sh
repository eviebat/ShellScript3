#!/usr/bin/ksh
#Assignment 3
#Author: Emily VanDerveer
# This script accepts files and directorys and will rename
#them by removing any spaces and inserting a "-" in it's place


USAGE="$0 -f directory
$0 -d  directory
$0 -d -f directory

-f rename files 
-d rename directories 
"

usage ()
    {
    print -u2 "$USAGE"
    exit 1
    }

pathname ()
    {
    # function provided for the student
    print -- "${1%/*}"
    }

basename ()
    {
    # function provided for the student
    print -- "${1##*/}"
    }

find_dirs ()
    {
    # function provided for the student
    find "$1" -depth -type d -name '* *' -print
    }

find_files ()
    {
    # function provided for the student
    find "$1" -depth -type f -name '* *' -print
    }

my_rename()
    {
        OLD_NAME="$1"
        NEW_NAME="$2"

        if [ ! -w "$OLD_NAME" ]                 #Check if writeable
        then
            print -u2 "$OLD_NAME is not writeable."
            exit 1
        fi

        if [ -d "$NEW_NAME" -o -f "$NEW_NAME" ]         #Check if new name exisits
        then
            print -u2 "$NEW_NAME exists and cannot be created."
            exit 2
        fi

        mv "$OLD_NAME" "$NEW_NAME"                  #Check status of mv command
        SUCCESS=$?
        if [ $SUCCESS  -ne 0 ]
        then
            print -u2 "Error moving $OLD_NAME to $NEW_NAME"
        fi

    }

fix_dirs ()
    {
        TO_CHANGE="$1"
        CHANGE_TO="${TO_CHANGE// /-}"       #Creates new name from current name replacing spaces with -

        my_rename "$TO_CHANGE" "$CHANGE_TO"

    }

fix_files ()
    {
        TO_CHANGE="$1"
        CHANGE_TO="${TO_CHANGE// /-}"        #Creates new name from current name replacing spaces with -

        my_rename "$TO_CHANGE" "$CHANGE_TO"
    }

WFILE=
WDIR=
DIR=

if [ "$#" -eq 0 ]
   then
   usage
   fi

while [ $# -gt 0 ] 
    do
    case $1 in
    -d)
        WDIR=1
        ;;
    -f)
        WFILE=1
        ;;
    -*)
        usage 
        ;;
    *)
	if [ -d "$1" ]
	    then
	    DIR="$1"
	elif [ -f "$1" ]
        then
        FILE="$1"
    else
	    print -u2 "$1 does not exist ..."
	    exit 1
	    fi
	;;
    esac
    shift
    done


if [ "$DIR" == '' -a "$WDIR" == '1' ]          
   then
   print -u2 "Directory not specified"
   exit 2
elif [ "$DIR" == "$PWD" ]
   then
   print -u2 "Directory specified is current directory - action not supported."
   exit 3
elif [ "$DIR" == '.' -o "$DIR" == '..' ]
   then
   print -u2 "Directory specified cannot be . or .. "
   exit 4
elif [ "$WDIR" == 0 -a "$WFILE" == 0 ]
   then
   print -u2 "Directory or File type was not submitted."
   exit 5
fi

if [ "$WDIR" -a "$WFILE" ]
    then
    fix_files "$FILE"
    fix_dirs "$DIR"
elif [ "$WDIR" ]
    then
    fix_dirs "$DIR"
elif [ "$WFILE" ]
    then
    fix_files "$FILE"
    fi
