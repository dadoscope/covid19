library(rtweet)
library(tidyverse)
library(jsonlite)

basedir<- "/home/ubuntu/raspador/covid19/R/"
terms <- c("covid","covid-19","corona","coronavirus","Chloroquine","Azithromycin")
all_tweets <- data.frame()
sufix <- system("date +'%Y%m%d%H%M'", intern=TRUE)
for(t in terms){
   cat(paste(t,"at",sufix),sep="\n")
   tweets <- search_tweets(t, n= 4000);
   tweets$term <- t
   all_tweets <-rbind(all_tweets, tweets)
}
jsonfilename <- paste0(basedir,"../data/tweets_",sufix,".json")
bz2filename <- paste0(basedir,"../data/tweets_",sufix,".bz2")
bz2filename2 <- paste0("data/tweets_",sufix,".bz2")
write_json(all_tweets, jsonfilename, pretty = TRUE, auto_unbox = FALSE)
system(paste("tar -cvjf",bz2filename,jsonfilename))
system(paste("sh /home/ubuntu/raspador/covid19/R/autocommit.sh",sufix,bz2filename2))
system(paste("rm -Rf",jsonfilename))
