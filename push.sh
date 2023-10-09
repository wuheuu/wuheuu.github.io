#!/bin/bash

date=$(date '+%d-%m-%Y_%H:%M:%S')

git add * --ignore-errors

update_message="$@ - $date"

if [ $# -eq 0 ]
then
    update_message="Update - $date"
fi

git commit -m "$update_message"
echo "$update_message"
git push 
