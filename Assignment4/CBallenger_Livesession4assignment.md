---
title: "Homework 4"
author: "Chris Ballenger"
date: "6/3/2018"
output: 
    html_document:
        keep_md: true
---



### Pleae install the following libraries
* fivethirtyeight
* plyr

## Question 1: FiveThirtyEight Data

#### a) Install Package

```r
install.packages("fivethirtyeight")
trying URL 'https://cran.rstudio.com/bin/macosx/el-capitan/contrib/3.5/fivethirtyeight_0.4.0.tgz'
Content type 'application/x-gzip' length 6058695 bytes (5.8 MB)
==================================================
downloaded 5.8 MB


The downloaded binary packages are in
	/var/folders/8r/jnnz1p2573q22hlc6pg2f9jc0000gn/T//RtmpCY3lpr/downloaded_packages
```

#### b) Assign college_recent_grads to df variable

```r
df <- college_recent_grads
str(df)
```

```
## Classes 'tbl_df', 'tbl' and 'data.frame':	173 obs. of  21 variables:
##  $ rank                       : int  1 2 3 4 5 6 7 8 9 10 ...
##  $ major_code                 : int  2419 2416 2415 2417 2405 2418 6202 5001 2414 2408 ...
##  $ major                      : chr  "Petroleum Engineering" "Mining And Mineral Engineering" "Metallurgical Engineering" "Naval Architecture And Marine Engineering" ...
##  $ major_category             : chr  "Engineering" "Engineering" "Engineering" "Engineering" ...
##  $ total                      : int  2339 756 856 1258 32260 2573 3777 1792 91227 81527 ...
##  $ sample_size                : int  36 7 3 16 289 17 51 10 1029 631 ...
##  $ men                        : int  2057 679 725 1123 21239 2200 2110 832 80320 65511 ...
##  $ women                      : int  282 77 131 135 11021 373 1667 960 10907 16016 ...
##  $ sharewomen                 : num  0.121 0.102 0.153 0.107 0.342 ...
##  $ employed                   : int  1976 640 648 758 25694 1857 2912 1526 76442 61928 ...
##  $ employed_fulltime          : int  1849 556 558 1069 23170 2038 2924 1085 71298 55450 ...
##  $ employed_parttime          : int  270 170 133 150 5180 264 296 553 13101 12695 ...
##  $ employed_fulltime_yearround: int  1207 388 340 692 16697 1449 2482 827 54639 41413 ...
##  $ unemployed                 : int  37 85 16 40 1672 400 308 33 4650 3895 ...
##  $ unemployment_rate          : num  0.0184 0.1172 0.0241 0.0501 0.0611 ...
##  $ p25th                      : num  95000 55000 50000 43000 50000 50000 53000 31500 48000 45000 ...
##  $ median                     : num  110000 75000 73000 70000 65000 65000 62000 62000 60000 60000 ...
##  $ p75th                      : num  125000 90000 105000 80000 75000 102000 72000 109000 70000 72000 ...
##  $ college_jobs               : int  1534 350 456 529 18314 1142 1768 972 52844 45829 ...
##  $ non_college_jobs           : int  364 257 176 102 4440 657 314 500 16384 10874 ...
##  $ low_wage_jobs              : int  193 50 0 0 972 244 259 220 3253 3170 ...
```

#### c) Comment the URL
https://fivethirtyeight.com/features/the-economic-guide-to-picking-a-college-major/

#### d) Dimensions and column names

```r
dim(df)
```

```
## [1] 173  21
```

```r
names(df)
```

```
##  [1] "rank"                        "major_code"                 
##  [3] "major"                       "major_category"             
##  [5] "total"                       "sample_size"                
##  [7] "men"                         "women"                      
##  [9] "sharewomen"                  "employed"                   
## [11] "employed_fulltime"           "employed_parttime"          
## [13] "employed_fulltime_yearround" "unemployed"                 
## [15] "unemployment_rate"           "p25th"                      
## [17] "median"                      "p75th"                      
## [19] "college_jobs"                "non_college_jobs"           
## [21] "low_wage_jobs"
```

## Question 2: Data Summary
#### a) Column Names and Column Counts

```r
names(df)
```

```
##  [1] "rank"                        "major_code"                 
##  [3] "major"                       "major_category"             
##  [5] "total"                       "sample_size"                
##  [7] "men"                         "women"                      
##  [9] "sharewomen"                  "employed"                   
## [11] "employed_fulltime"           "employed_parttime"          
## [13] "employed_fulltime_yearround" "unemployed"                 
## [15] "unemployment_rate"           "p25th"                      
## [17] "median"                      "p75th"                      
## [19] "college_jobs"                "non_college_jobs"           
## [21] "low_wage_jobs"
```

```r
ncol(df)
```

```
## [1] 21
```

#### b) Count major_catagory

```r
major_count <- count(df, 'major_category')
major_count
```

```
##                         major_category freq
## 1      Agriculture & Natural Resources   10
## 2                                 Arts    8
## 3               Biology & Life Science   14
## 4                             Business   13
## 5          Communications & Journalism    4
## 6              Computers & Mathematics   11
## 7                            Education   16
## 8                          Engineering   29
## 9                               Health   12
## 10           Humanities & Liberal Arts   15
## 11 Industrial Arts & Consumer Services    7
## 12                   Interdisciplinary    1
## 13                 Law & Public Policy    5
## 14                   Physical Sciences   10
## 15            Psychology & Social Work    9
## 16                      Social Science    9
```

#### c) Bar Plot of Major Catagories

```r
op <- par(mar=c(4,15,2,1), las= 2)
barplot(
    height=major_count$freq,
    names.arg = major_count$major_category,
    horiz = TRUE,
    main = 'The Economic Guide To Picking A College Major',
    xlab = 'Frequency',
    ylab = 'Catagory',
    col = 'Green'
)
```

![](CBallenger_Livesession4assignment_files/figure-html/unnamed-chunk-6-1.png)<!-- -->

#### d) write a csv file

```r
write.csv(df, file = 'MSDS 6306/college_grad_students.csv',row.names = FALSE)
```

## Question 3 Codebook
https://github.com/toadies/Homework_6306/blob/master/README.md
