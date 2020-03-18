library(rtweet)
library(tidyverse)
library(jsonlite)


terms <- c("covid","covid-19","corona","coronavirus")
all_tweets <- data.frame()
sufix <- system("date +'%Y%m%d%H%M'", intern=TRUE)
for(t in terms){
   cat(paste(t,"at",sufix),sep="\n")
   tweets <- search_tweets(t, n= 4000);
   tweets$term <- t
   all_tweets <-rbind(all_tweets, tweets)
}
jsonfilename <- paste0("../data/tweets_",sufix,".json")
bz2filename <- paste0("../data/tweets_",sufix,".bz2")
write_json(all_tweets, jsonfilename, pretty = TRUE, auto_unbox = FALSE)
system(paste("tar -cvjf",bz2filename,jsonfilename))
system(paste("sh autocommit.sh",sufix,bz2filename))
system(paste("rm -Rf",jsonfilename))
