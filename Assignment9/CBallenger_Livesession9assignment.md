---
title: "Homework 9"
author: "Chris Ballenger"
date: "7/2/2018"
output: 
  html_document:
    keep_md: true
---



### Quesiton 1 Harry Potter Cast (50%)

#### a) IMDB Data
* Import Cast of Harry Potter and the Deathly Hallows: Part 2
    * https://www.imdb.com/title/tt1201607/fullcredits?ref_=tt_ql_1
#### b) R Code to read HTML Document

```r
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
head(cast)
```

```
##                             actor
## 1    \n Ralph Fiennes\n          
## 2   \n Michael Gambon\n          
## 3     \n Alan Rickman\n          
## 4 \n Daniel Radcliffe\n          
## 5     \n Rupert Grint\n          
## 6      \n Emma Watson\n          
##                                                                   character
## 1             \n            Lord Voldemort \n                  \n          
## 2 \n            Professor Albus Dumbledore \n                  \n          
## 3    \n            Professor Severus Snape \n                  \n          
## 4               \n            Harry Potter \n                  \n          
## 5                \n            Ron Weasley \n                  \n          
## 6           \n            Hermione Granger \n                  \n
```

#### c) Clean up table

```r
# Clean Up Data
# Remove Leading & trailing White Spaces
cast <- sapply( cast, trimws, which="both" )

# Remove "\n "
cast <- gsub( "\n ", "", cast)

#Update Mr. Warwick character
cast[grep( "^Warwick", cast[,1] ),2] <- "Griphook  /  Professor  Filius  Flitwick"

head(cast)
```

```
##      actor              character                   
## [1,] "Ralph Fiennes"    "Lord Voldemort"            
## [2,] "Michael Gambon"   "Professor Albus Dumbledore"
## [3,] "Alan Rickman"     "Professor Severus Snape"   
## [4,] "Daniel Radcliffe" "Harry Potter"              
## [5,] "Rupert Grint"     "Ron Weasley"               
## [6,] "Emma Watson"      "Hermione Granger"
```

```r
tail(cast)
```

```
##        actor               character                               
## [144,] "Nick Turner"       "Death Eater    (uncredited)"           
## [145,] "Aaron Virdee"      "Gryffindor Senior    (uncredited)"     
## [146,] "John Warman"       "Railway Station Porter    (uncredited)"
## [147,] "Spencer Wilding"   "Knight of Hogwarts    (uncredited)"    
## [148,] "Amy Wiles"         "Slytherin Student    (uncredited)"     
## [149,] "Thomas Williamson" "Hogwarts Student    (uncredited)"
```

```r
summary(cast)
```

```
##             actor                                character  
##  Aaron Virdee  :  1   Gringotts Goblin    (uncredited): 10  
##  Adrian Rawlins:  1   Death Eater                     :  9  
##  Afshan Azad   :  1   Death Eater    (uncredited)     :  6  
##  Alan Rickman  :  1   Wizard Parent    (uncredited)   :  5  
##  Albert Tang   :  1   Hogwarts Student    (uncredited):  4  
##  Alfie McIlwain:  1   Giant                           :  3  
##  (Other)       :143   (Other)                         :112
```

#### d) Split Actor's Name

```r
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
cast <- data.frame( FirstName = firstName, LastName = lastName, Character = cast[,2])
```

#### e) Present first 10 rows

```r
kable( head( cast, 10 ), row.names=FALSE )  %>%
  kable_styling(bootstrap_options = c("striped", "condensed"), full_width = F)
```

<table class="table table-striped table-condensed" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> FirstName </th>
   <th style="text-align:left;"> LastName </th>
   <th style="text-align:left;"> Character </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Ralph </td>
   <td style="text-align:left;"> Fiennes </td>
   <td style="text-align:left;"> Lord Voldemort </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Michael </td>
   <td style="text-align:left;"> Gambon </td>
   <td style="text-align:left;"> Professor Albus Dumbledore </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Alan </td>
   <td style="text-align:left;"> Rickman </td>
   <td style="text-align:left;"> Professor Severus Snape </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Daniel </td>
   <td style="text-align:left;"> Radcliffe </td>
   <td style="text-align:left;"> Harry Potter </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Rupert </td>
   <td style="text-align:left;"> Grint </td>
   <td style="text-align:left;"> Ron Weasley </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Emma </td>
   <td style="text-align:left;"> Watson </td>
   <td style="text-align:left;"> Hermione Granger </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Evanna </td>
   <td style="text-align:left;"> Lynch </td>
   <td style="text-align:left;"> Luna Lovegood </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Domhnall </td>
   <td style="text-align:left;"> Gleeson </td>
   <td style="text-align:left;"> Bill Weasley </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Clémence </td>
   <td style="text-align:left;"> Poésy </td>
   <td style="text-align:left;"> Fleur Delacour </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Warwick </td>
   <td style="text-align:left;"> Davis </td>
   <td style="text-align:left;"> Griphook  /  Professor  Filius  Flitwick </td>
  </tr>
</tbody>
</table>
