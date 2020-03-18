#/bin/bash

dir="/home/ubuntu/raspador/covid19/"
sufix=$1
bz2filename=$2

cd $dir
msg="Adding file $sufix"
git add "$bz2filename"
git commit -am "$msg"
git remote set-url origin git@github.com:dadoscope/covid19.git
git push origin master
