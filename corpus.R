library(tm)
library(ngram)
library(stringr)

if (!file.exists("data/capstone.zip")) {
        download.file(
                "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip",
                "data/capstone.zip"
        )
        unzip("data/capstone.zip")
}
enUS.blogs <-
        readLines("final/en_US/en_US.blogs.txt",
                  warn = FALSE,
                  encoding = "UTF-8")
enUS.news <-
        readLines("final/en_US/en_US.news.txt",
                  warn = FALSE,
                  encoding = "UTF-8")
enUS.twitter <-
        readLines("final/en_US/en_US.twitter.txt",
                  warn = FALSE,
                  encoding = "UTF-8")
set.seed(912574)
enUs.blogs.sample <- sample(enUS.blogs, length(enUS.blogs) * .05)
enUs.twitter.sample <- sample(enUS.twitter, length(enUS.twitter) * .05)
enUs.news.sample <- sample(enUS.news, length(enUS.news) * .05)
# Removing objects to free memory
rm(enUS.blogs)
rm(enUS.news)
rm(enUS.twitter)
enUs.sample <-
        c(enUs.blogs.sample, enUs.twitter.sample, enUs.news.sample)
rm(enUs.blogs.sample)
rm(enUs.news.sample)
rm(enUs.twitter.sample)
# Function that cleans the text passed as parameter
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

enUs.sample <- cleanText(enUs.sample)
# Corpus Creation
enUs.corpus <- Corpus(VectorSource(enUs.sample))
# Cleaning chats that can distort the prediction
enUs.corpus <-
        tm_map(
                enUs.corpus,
                removePunctuation,
                preserve_intra_word_contractions = T,
                preserve_intra_word_dashes = T
        )
enUs.corpus <- tm_map(enUs.corpus, stripWhitespace)
enUs.corpus <- tm_map(enUs.corpus, content_transformer(tolower))
enUs.corpus <- tm_map(enUs.corpus, removeNumbers)
enUs.corpus <- tm_map(enUs.corpus, PlainTextDocument)
enUs.corpus <-
        tm_map(enUs.corpus, removeWords, stopwords("english"))
# concatenate in one string
enUS.joined <- concatenate (enUs.corpus)
rm(enUs.corpus)
# Preprocessing the string
enUS.corpus.joined <-
        preprocess(
                enUS.joined,
                remove.punct = T,
                remove.numbers = T,
                fix.spacing = T
        )
enUS.corpus.joined <-
        str_replace_all(enUS.corpus.joined, "[\r\n]" , " ")
rm(enUS.joined)
rm(enUs.sample)
unigrams <- ngram(enUS.corpus.joined, 1)
bigrams <- ngram(enUS.corpus.joined, 2)
trigrams <- ngram(enUS.corpus.joined, 3)

getWord <- function(x, n) {
        unlist(strsplit(x, " "))[n]
}
unigrams.df <- get.phrasetable(unigrams)
bigrams.df <- get.phrasetable(bigrams)
bigrams.df$word1 <- sapply(bigrams.df$ngrams, getWord, 1)
bigrams.df$word1 <- sapply(bigrams.df$word1, stemDocument)
bigrams.df$word2 <- sapply(bigrams.df$ngrams, getWord, 2)
trigrams.df <- get.phrasetable(trigrams)
trigrams.df <- subset(trigrams.df, freq > 1)
trigrams.df$word1 <- sapply(trigrams.df$ngrams, getWord, 1)
trigrams.df$word1 <- sapply(trigrams.df$word1, stemDocument)
trigrams.df$word2 <- sapply(trigrams.df$ngrams, getWord, 2)
trigrams.df$word2 <- sapply(trigrams.df$word2, stemDocument)
trigrams.df$word3 <- sapply(trigrams.df$ngrams, getWord, 3)

save(unigrams.df, file = "unigram.RData")
save(bigrams.df, file = "bigram.RData")
save(trigrams.df, file = "trigram.RData")
rm(unigrams)
rm(bigrams)
rm(trigrams)
rm(tetragrams)
rm(enUS.corpus.joined)
rm(unigrams.df)
rm(bigrams.df)
rm(trigrams.df)