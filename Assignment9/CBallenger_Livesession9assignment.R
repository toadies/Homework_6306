setwd("/Users/christopherballenger/Documents/Data Science/MSDS 6306/Projects/Homework_6306/Assignment9")

library(RCurl)
library(XML)

# Get the HTML from IMDB
response <- GET("https://www.imdb.com/title/tt1201607/fullcredits?ref_=tt_ql_1")
response <- htmlParse(response)

# Get Cast List Table
qry_xpath <- "//table[@class='cast_list']/tr/td[@itemprop='actor'] | //table[@class='cast_list']/tr/td[@class='character']"
raw_cast <- xpathSApply( response, qry_xpath, xmlValue)

# Convert to Data Frame
# Actors on Odd Rows & Character are on Even Rows
total_rows <- length(raw_cast)
even_indexes <- seq(2, total_rows, 2)
odd_indexes <- seq(1, total_rows - 1, 2)
cast <- data.frame(
    actor = raw_cast[odd_indexes],
    character = raw_cast[even_indexes],
    stringsAsFactors = FALSE 
)

# Clean Up Data
# Remove Leading & trailing White Spaces
cast <- sapply( cast, trimws, which="both" )

# Remove "\n "
cast <- gsub( "\n ", "", cast)
head(cast)
tail(cast)
summary(cast)

#Update Mr. Warwick character
cast[grep( "^Warwick", cast[,1] ),2] <- "Griphook  /  Professor  Filius  Flitwick"

# set vectors for First Name and Last Name to temporarly store names
firstName <- character(0)
lastName <- character(0)
for( i in 1:nrow(cast) ) {
    #split name
    actors <- strsplit(cast[i,1], " ")
    
    if( length(actors$actor) == 2 ){
        # If name is only 2 words, store data
        firstName[i] <- actors$actor[1]
        lastName[i] <- actors$actor[2]
    } else {
        # If name is > 2 words, store only the last word in lastName vector
        firstName[i] <- paste(actors$actor[1:length(actors$actor)-1],collapse = " ")
        lastName[i] <- actors$actor[length(actors$actor)]
    }
}

# Combine Vectors with existing Data Frame
cast <- data.frame( FirstName = firstName, LastName = lastName, character = cast$character)


library(knitr)
library(rmarkdown)
render("CBallenger_Livesession9assignment.Rmd")