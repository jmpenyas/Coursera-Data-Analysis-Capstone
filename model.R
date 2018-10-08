library(tm)
library(ngram)
library(stringr)
library(quanteda)
cleanText <- function (txt) {
        # Before corpus creation, proceeding to remove line feeds and carriage returns
        txt <- str_replace_all(txt, "[\r\n]" , "")
        txt <- str_replace_all(txt, "[^[:alpha:][:space:]]*" , "")
        txt <- str_replace_all(txt, "http[^[:space:]]*" , "")
        txt <-
                str_replace_all(txt, "\\b(?=\\w*(\\w)\\1)\\w+\\b"  , "")
        txt <- iconv(txt, to = "ASCII", sub = "")
        txt <- removeWords(txt, stopwords("english"))
}
cleanInput <- function(input){
        input <- cleanText(input)
        
        words <- tokens(x = tolower(input),
                        remove_punct = T,
                        remove_symbols = T, remove_separators = T,
                        remove_twitter = T, remove_hyphens = T, remove_url = T)
        long <- length(words)
        if (long > 3)
                res <- words$text1[(long -2):long]
        else
         res <- words$text1
        res <- sapply(res,stemDocument)
        res
}

nextWord  <- function(input) {
        load("unigram.RData") 
        load("bigram.RData")
        load("trigram.RData");         
        inputSplit <- cleanInput(input)
        inputSize <- length(inputSplit)
        
        res <- ""
        if (inputSize == 1) {
                res <- subset(bigrams.df, word1 == inputSplit[1])$word2
                if (length(res) == 0)
                        res<-unigrams.df[1:3]
                
        }
        else   if (inputSize == 2) {
                res <- subset(
                                trigrams.df,
                                word1 == inputSplit[1] &&
                                        word2 == inputSplit[2]
                        )$word3
                if (length(res) == 0) {
                        res <- nextWord(paste(inputSplit[-1], collapse = " "))
                }
        }
        else   if (inputSize > 2)
                res <-
                        nextWord(paste(inputSplit[-1], collapse = " "))
        else 
                res <- "No result found"
        res
} 
