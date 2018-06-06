---
title: "Homework 5"
author: "Chris Ballenger"
date: "6/5/2018"
output: 
    html_document:
        keep_md: true
---



## Quesiton 1 Data Munging

#### a) Import and add column names

```r
df <- read.table('data/yob2016.txt',sep=';',header = FALSE)
names(df) <- c('name','gender','total_kids')
head(df)
```

```
##       name gender total_kids
## 1     Emma      F      19414
## 2   Olivia      F      19246
## 3      Ava      F      16237
## 4   Sophia      F      16070
## 5 Isabella      F      14722
## 6      Mia      F      14366
```

#### b) Summary & Structure
Summary

```r
summary( df )
```

```
##       name       gender      total_kids     
##  Aalijah:    2   F:18758   Min.   :    5.0  
##  Aaliyan:    2   M:14111   1st Qu.:    7.0  
##  Aamari :    2             Median :   12.0  
##  Aarian :    2             Mean   :  110.7  
##  Aarin  :    2             3rd Qu.:   30.0  
##  Aaris  :    2             Max.   :19414.0  
##  (Other):32857
```
Structure

```r
dim( df )
```

```
## [1] 32869     3
```

```r
str( df )
```

```
## 'data.frame':	32869 obs. of  3 variables:
##  $ name      : Factor w/ 30295 levels "Aaban","Aabha",..: 9317 22546 3770 26409 12019 20596 6185 339 9298 11222 ...
##  $ gender    : Factor w/ 2 levels "F","M": 1 1 1 1 1 1 1 1 1 1 ...
##  $ total_kids: int  19414 19246 16237 16070 14722 14366 13030 11699 10926 10733 ...
```

#### c) Search for a specific name

```r
df[grep('yyy$', df[,1]),]
```

```
##         name gender total_kids
## 212 Fionayyy      F       1547
```

#### d) remove value and create new dataset

```r
y2016 <- df[-grep('yyy$', df[,1]),]
```

## Question 2 Data Merging
#### a) Import and add column names for yob2015

```r
y2015 <- read.table('data/yob2015.txt',sep=',',header = FALSE)
names(y2015) <- c('name','gender','total_names_2015')
head(y2015)
```

```
##       name gender total_names_2015
## 1     Emma      F            20415
## 2   Olivia      F            19638
## 3   Sophia      F            17381
## 4      Ava      F            16340
## 5 Isabella      F            15574
## 6      Mia      F            14871
```

#### b) Display last 10 rows
The most uncomon names all start with Z

```r
tail(y2015, 10)
```

```
##         name gender total_names_2015
## 33054   Ziyu      M                5
## 33055   Zoel      M                5
## 33056  Zohar      M                5
## 33057 Zolton      M                5
## 33058   Zyah      M                5
## 33059 Zykell      M                5
## 33060 Zyking      M                5
## 33061  Zykir      M                5
## 33062  Zyrus      M                5
## 33063   Zyus      M                5
```

#### c) Merge y2016 & y2015

```r
# Merge Data
result <- merge(y2015, y2016, by.x = 'name', by.y = 'name')
# Update Names
names(result) <- c('name','gender_2015','total_counts_2015','gender_2016','total_counts_2016')
head(result)
```

```
##        name gender_2015 total_counts_2015 gender_2016 total_counts_2016
## 1     Aaban           M                15           M                 9
## 2     Aabha           F                 7           F                 7
## 3 Aabriella           F                 5           F                11
## 4     Aadam           M                22           M                18
## 5   Aadarsh           M                15           M                11
## 6     Aaden           M               297           M               194
```

```r
# Validate no NAs
sapply(result, function(x) sum(is.na(x)))
```

```
##              name       gender_2015 total_counts_2015       gender_2016 
##                 0                 0                 0                 0 
## total_counts_2016 
##                 0
```

## Question 3
#### a) Total the total_counts_yyyy columns and sum all values

```r
result$total_counts_all <- result$total_counts_2015 + result$total_counts_2016
#Total children
sum(result$total_counts_all)
```

```
## [1] 11404228
```

#### b) Show top 10 most popular names

```r
result <- result[order(result$total_counts_all, decreasing = TRUE),]
head(result, 10)
```

```
##           name gender_2015 total_counts_2015 gender_2016 total_counts_2016
## 9820      Emma           F             20415           F             19414
## 23607   Olivia           F             19638           F             19246
## 23258     Noah           M             19594           M             19015
## 19277     Liam           M             18330           M             18138
## 27782   Sophia           F             17381           F             16070
## 3725       Ava           F             16340           F             16237
## 21102    Mason           M             16591           M             15192
## 30128  William           M             15863           M             15668
## 13054    Jacob           M             15914           M             14416
## 12698 Isabella           F             15574           F             14722
##       total_counts_all
## 9820             39829
## 23607            38884
## 23258            38609
## 19277            36468
## 27782            33451
## 3725             32577
## 21102            31783
## 30128            31531
## 13054            30330
## 12698            30296
```

#### c) Show only girl names

```r
girl_names <- result[which(c(result$gender_2015=='F',result$gender_2016=='F')),]
head(girl_names)
```

```
##           name gender_2015 total_counts_2015 gender_2016 total_counts_2016
## 9820      Emma           F             20415           F             19414
## 23607   Olivia           F             19638           F             19246
## 27782   Sophia           F             17381           F             16070
## 3725       Ava           F             16340           F             16237
## 12698 Isabella           F             15574           F             14722
## 21722      Mia           F             14871           F             14366
##       total_counts_all
## 9820             39829
## 23607            38884
## 27782            33451
## 3725             32577
## 12698            30296
## 21722            29237
```

#### d) Write to csv file data/top_10_girl_names.csv

```r
write.csv(head(girl_names[,c(1,6)],10), file='data/top_10_girl_names.csv', row.names = FALSE)
```

## Question 4) Upload to GitHub
https://github.com/toadies/Homework_6306/tree/master/Assignment5/data

