setwd("/Users/christopherballenger/Documents/Data Science/MSDS 6306/Projects/Homework_6306/Assignment9")

library(RCurl)
library(XML)
library(ggplot2)
library(dataMaid)

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

# Get the HTML from ESPN
response <- GET("http://www.espn.com/nba/team/stats/_/name/sa/san-antonio-spurs")
response <- htmlParse(response)

# Get Second Table labeled class=tablehead from webpage document
qry_xpath <- "(//table[@class='tablehead'])[2]/tr[contains(@class, 'oddrow player')]/td | (//table[@class='tablehead'])[2]/tr[contains(@class, 'evenrow player')]/td"
result <- xpathSApply(response, qry_xpath, xmlValue)
stats <- data.frame( matrix(result, nrow=14, ncol =15, byrow = TRUE), stringsAsFactors=FALSE )

# Get Column Names
qry_xpath <- "(//table[@class='tablehead'])[2]/tr[@class='colhead']/td"
result <- xpathSApply(response, qry_xpath, xmlValue)
names(stats) <- make.names(result)

# Update stat fields to numeric
stats <- transform( 
    stats,
    FGM = as.numeric(FGM),
    FGA = as.numeric(FGA),
    FG. = as.numeric(FG.),
    X3PM = as.numeric(X3PM),
    X3PA = as.numeric(X3PA),
    X3P. = as.numeric(X3P.),
    FTM = as.numeric(FTM),
    FTA = as.numeric(FTA),
    FT. = as.numeric(FT.),
    X2PM = as.numeric(X2PM),
    X2PA = as.numeric(X2PA),
    X2P. = as.numeric(X2P.),
    PPS = as.numeric(PPS),
    AFG. = as.numeric(AFG.)
)

# set vectors for First Name and Last Name to temporarly store names
players <- data.frame( 
    do.call( 'rbind', strsplit( as.character( test_stats$PLAYER ),", ",fixed=TRUE))
)
names(players) <- c('Player', 'Position')
stats$PLAYER <- players$Player
stats$Position <- players$Position
str(stats)

Palette1 <- c('red','green','blue','violet','black')
ggplot( stats , aes( PLAYER, FG., fill=Position ) ) +
    geom_bar(stat="identity") +
    scale_fill_manual(values=Palette1) +
    labs(title="Field Goals Percentage Per Game",x ="Player", y = "Field Goal %" ) +
    coord_flip() +
    theme(plot.title = element_text(hjust = 0.5))

library(knitr)
library(rmarkdown)
render("CBallenger_Livesession9assignment.Rmd")

# Code Book For Cast of Harry Potter
makeCodebook(cast)

# Code Book for Shooting Statistics
attr(stats$FGM, "shortDescription") <- "Field Goals Made per game"
attr(stats$FGA, "shortDescription") <- "Field Goals Attempted per game"
attr(stats$FG., "shortDescription") <- "Field Goal Percentage per game"
attr(stats$X3PM, "shortDescription") <- "3 Points Made per game"
attr(stats$X3PA, "shortDescription") <- "3 Points Attempted per game"
attr(stats$X3P., "shortDescription") <- "3 Points Percentage per game"
attr(stats$FTM, "shortDescription") <- "Free Throws Made per game"
attr(stats$FTA, "shortDescription") <- "Free Throws Attempted per game"
attr(stats$FT., "shortDescription") <- "Free Throws Percentage per game"
attr(stats$X2PM, "shortDescription") <- "2 Points Made per game"
attr(stats$X2PA, "shortDescription") <- "2 Points Attempted per game"
attr(stats$X2P., "shortDescription") <- "2 Points Percentage per game"
attr(stats$PPS, "shortDescription") <- "Points Per Shot per game"
attr(stats$AFG., "shortDescription") <- "Adjusted Field Goal Percentage per game"

# Create the cookbook for descriptions
makeCodebook(stats, replace=TRUE)


library(knitr)
library(rmarkdown)
render("CBallenger_Livesession9assignment.Rmd")