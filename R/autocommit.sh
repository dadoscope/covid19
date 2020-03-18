#/bin/bash

sufix=$1
bz2filename=$2

msg="Adding file $sufix"
git add "../data/$bz2filename"
git commit -am "$msg"
git remote set-url origin git@github.com:dadoscope/covid19.git
git push origin master
