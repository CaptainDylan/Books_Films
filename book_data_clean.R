library(dplyr)
library(RMySQL)

con <- dbConnect(MySQL(),
                 dbname = "reviews",
                 host = "dvaproject.c9f0lti9xqdg.us-east-1.rds.amazonaws.com",
                 port = 3306,
                 user = "dva",
                 password = "DVA2019!"
)

dbListTables(con)  # list all available database

rs = dbSendQuery(con, "select * from book_data")
temp.book = fetch(rs, n=-1)
#head(data,10)

rs.map = dbSendQuery(con, "select * from wiki_book_movie_ids_matching")

id_map <- fetch(rs.map, n=-1)

books.NoReview <- temp.book[temp.book$review_count == 0,] # identify books without any reviews

#filter out non-english books
#book.Eng <- data[which(!grepl("[^\u0001-\u007F]+", data$title)),]

#filter title that cannot be translated
temp.book.1 <- temp.book[!grepl('\\?\\?', temp.book$title),]

library(stringr)
# remove bracket from series column
book.choice$series <- gsub("?", "", book.choice$series, fixed = TRUE)
book.choice$series  <- gsub("[(|)]","" , book.choice$series ,ignore.case = TRUE)

#split series column into 2 to show book series name and # within series
series.split <- data.frame(str_split_fixed(book.choice$series, " #", 2))

book.choice$series <- series.split$X1
library(tibble)
book.choice <- add_column(book.choice, series_num = series.split$X2, .after = 6)

#remove "pages" from length column
book.choice$length  <- gsub("pages","" , book.choice$length ,ignore.case = TRUE)

book.choice$description <- str_replace_all(book.choice$description, "\\?+","")

book.choice$description[book.choice$book_id == 3038497 | book.choice$book_id == 70700 ] <- ""

# Write data.frame to MySQL
dbWriteTable(conn = con, name = 'book_data_cleaned', value = book.choice,row.names = FALSE, overwrite = TRUE)

