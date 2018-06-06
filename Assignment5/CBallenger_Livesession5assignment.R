setwd('/Users/christopherballenger/Documents/Data Science/')
setwd(paste(getwd(),'/MSDS 6306/Projects/Homework_6306/Assignment5',sep=''))


# Download the yob2016.txt file
# library(repmis)
# kidsNames <- repmis::source_data(
#     'https://www.dropbox.com/sh/pdk0yr5uq5z6n71/AAAfrdmDO9nGZyzIpS2cOD0Pa?dl=0&preview=yob2016.txt?raw=1',
#     sep=';',
#     header = FALSE)
df <- read.table('data/yob2016.txt',sep=';',header = FALSE)
head(df)
tail(df)

names(df) <- c('name','gender','total_names_2016')
summary( df )
dim( df )
str( df )

df[grep('yyy$', df[,1]),]

dim(df)

y2016 <- df[-grep('yyy$', df[,1]),]
dim(y2016)

y2015 <- read.table('data/yob2015.txt',sep=',',header = FALSE)
names(y2015) <- c('name','gender','total_names_2015')
head(y2015)
tail(y2015, 10)

# Merge Data
result <- merge(y2015, y2016, by.x = 'name', by.y = 'name')
# Update Names
names(result) <- c('name','gender_2015','total_counts_2015','gender_2016','total_counts_2016')
head(result)

# Validate no NAs
sapply(result, function(x) sum(is.na(x)))


summary(result)
sapply(result, function(x) sum(is.na(x)))

result$total_counts_all <- result$total_counts_2015 + result$total_counts_2016
sum(result$total_counts_all)
result <- result[order(result$total_counts_all, decreasing = TRUE),]
head(result, 10)

girl_names <- result[which(c(result$gender_2015=='F',result$gender_2016=='F')),]
head(girl_names)

write.csv(head(girl_names[,c(1,6)],10), file='data/top_10_girl_names.csv', row.names = FALSE)
