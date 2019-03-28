library(RMySQL)
library(data.table)
library(dplyr)
library(ggplot2)
library(stringr)
library(tm)
library(magrittr)
library(textcat)
library(tidytext)
library(RTextTools)

#https://datascienceplus.com/exploratory-data-analysis-and-sentiment-analysis/


mydb = dbConnect(MySQL(), user='dva', password='DVA2019!', dbname='reviews', host='dvaproject.c9f0lti9xqdg.us-east-1.rds.amazonaws.com')
rs = dbSendQuery(mydb, "select * from movie_reviews")
data = fetch(rs, n=-1)
data = data.table(data)


#Identify languages using textcat package and remove reviews that are not in English
data$language <-as.factor(textcat(data$review))
data <- data[language == "en"]

#Remove reviews without a rating
data <- data[!is.na(data$rating)]

#Remove reviews with fewer than 5 words
data <- data[length(data$review) >=5]

#Remove reviews with a rating of ?
data <- data[data$rating != "?"]

#Remove language column and add review_id column
data$language <- NULL
data$review_id <- 1:nrow(data)

#Remove reviews with more than 6000 characters
n <- nrow(data[data$review.length >= 6000])
data <- data[data$review.length <= 6000]
hist(data$review.length, 
     ylim = c(0,100000), 
     main = "Distribution of review length" )

# Loading the first sentiment score lexicon
AFINN <- sentiments %>%
  filter(lexicon == "AFINN") %>%
  select(word, afinn_score = score)
head(AFINN)

# Loading the second sentiment score lexicon
Bing <- sentiments %>%
  filter(lexicon == "bing") %>%
  select(word, bing_sentiment = sentiment)
head(Bing)

#subset data
tempdata = data[0:50000, ]

# "tidying" up the data (1 word per row) and adding the sentiment scores for each word
review_words <- tempdata %>%
  unnest_tokens(word, review) %>%
  select(-c(imdbid, review.length)) %>%
  left_join(AFINN, by = "word") 
#  left_join(Bing, by = "word")

review_mean_sentiment <- review_words %>%
  group_by(review_id, rating) %>%
  summarize(mean_sentiment = mean(afinn_score, na.rm = TRUE))

theme_set(theme_bw())
ggplot(review_mean_sentiment, aes(rating, mean_sentiment, group = rating)) +
  geom_boxplot() +
  ylab("Average sentiment score")

review_mean_sentiment <- review_mean_sentiment %>%
  select(-rating) %>% # We remove the rating here to avoid duplicating it
  data.table()
cleandata <- tempdata %>%
  left_join(review_mean_sentiment, by = "review_id")

review_median_sentiment <- review_words %>%
  group_by(review_id, rating) %>%
  summarize(median_sentiment = median(afinn_score, na.rm = TRUE))
theme_set(theme_bw())
ggplot(review_median_sentiment, aes(rating, median_sentiment, group = rating)) +
  geom_boxplot() +
  ylab("Median sentiment score")

review_median_sentiment <- review_median_sentiment %>%
  data.table()
cleandata <- cleandata %>%
  left_join(review_median_sentiment, by = "review_id")


# Counting the number of negative words per review according to AFINN lexicon
review_count_afinn_negative <- review_words %>%
  filter(afinn_score < 0) %>%
  group_by(review_id, rating) %>%
  summarize(count_afinn_negative = n())
# Transferring the results to our dataset
review_count_afinn_negative <- review_count_afinn_negative %>%
  select(-rating) %>%
  data.table()
cleandata <- cleandata %>%
  left_join(review_count_afinn_negative, by = "review_id")

# Counting the number of positive words per review according to AFINN lexicon
review_count_afinn_positive <- review_words %>%
  filter(afinn_score > 0) %>%
  group_by(review_id, rating) %>%
  summarize(count_afinn_positive = n())
# Transferring the results to our dataset
review_count_afinn_positive <- review_count_afinn_positive %>%
  select(-rating) %>%
  data.table()
cleandata <- cleandata %>%
  left_join(review_count_afinn_positive, by = "review_id")


word_mean_summaries <- review_words %>%
  count(review_id, rating, word) %>%
  group_by(word) %>%
  summarize(reviews = n(),
            uses = sum(n),
            average_rating = mean(rating)) %>%
  filter(reviews >= 3) %>%
  arrange(average_rating)

#----------------------------------------------------------------------------------------#

word_mean_afinn <- word_mean_summaries %>%
  inner_join(AFINN)

ggplot(word_mean_afinn, aes(afinn_score, average_rating, group = afinn_score)) +
  geom_boxplot() +
  xlab("AFINN score of word") +
  ylab("Mean rating of reviews with this word")

#----------------------------------------------------------------------------------------#

set.seed(1234)


library(caret)
library(xgboost)
library(ROCR)
library(slam)

data <- read.csv("GoodReadsCleanData.csv", stringsAsFactors = FALSE)

# Creating the outcome value
data$quality <- 0
data$quality[data$rating > 7] <- 1

trainIdx <- createDataPartition(data$quality, 
                                p = .75, 
                                list = FALSE, 
                                times = 1)
train <- data[trainIdx, ]
test <- data[-trainIdx, ]


library("quanteda")
#baddata = train[which(train$quality == 0),]
#badcorp <- corpus(baddata, text_field = "review")
#badfm <- dfm(badcorp, remove_punct = TRUE, remove=stopwords("english"))
#badtrimmed <- dfm_trim(badfm, min_termfreq =500, termfreq_type = "count")
#badresult <- cbind(docvars(badtrimmed), convert(badtrimmed, to="data.frame"))

#gooddata = train[which(train$quality == 1),]
#goodcorp <- corpus(gooddata, text_field = "review")
#goodfm <- dfm(goodcorp, remove_punct = TRUE, remove=stopwords("english"))
#goodtrimmed <- dfm_trim(goodfm, min_termfreq =500, termfreq_type = "count")
#goodresult <- cbind(docvars(goodtrimmed), convert(goodtrimmed, to="data.frame"))

corp = corpus(train, text_field = "review")
corpfm <-dfm(corp, remove_punct = TRUE, remove=stopwords("english"))
corptrimmer <- dfm_trim(corpfm, min_termfreq=500, termfreq_type = "count")
corpresult <-cbind(docvars(corptrimmer), convert(corptrimmer, to="data.frame"))

corptest = corpus(train, text_field = "review")
corpfmtest <-dfm(corptest, remove_punct = TRUE, remove=stopwords("english"))
corptrimmertest <- dfm_trim(corpfmtest, min_termfreq=500, termfreq_type = "count")
corpresulttest <-cbind(docvars(corptrimmertest), convert(corptrimmertest, to="data.frame"))

corpresulttest <- head(bind_rows(corpresulttest, corpresult[1, ]), -1)
corpresulttest <- corpresulttest %>% 
  select(one_of(colnames(corpresult)))
corpresulttest[is.na(corpresulttest)] <- 0

baseline.acc <- sum(corpresulttest$quality == "1") / nrow(corpresulttest)

XGB_train <- as.matrix(corpresult)
XGB_test <- as.matrix(corpresulttest[, names(corptest) != "quality"])
XGB_model <- xgboost(data = XGB_train, 
                     label = corpresult$quality,
                     nrounds = 400, 
                     objective = "binary:logistic")

XGB_predict <- predict(XGB_model, XGB_test)

XGB.results <- data.frame(quality = corptest$quality,
                          pred = XGB.predict)

ROCR.pred <- prediction(XGB.results$pred, XGB.results$gquality)
ROCR.perf <- performance(ROCR.pred, 'tnr','fnr') 
plot(ROCR.perf, colorize = TRUE)