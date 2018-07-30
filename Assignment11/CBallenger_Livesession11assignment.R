setwd("/Users/christopherballenger/Documents/Data Science/MSDS 6306/Projects/Homework_6306/Assignment11")
library(ggplot2)
library(ggfortify)

daxIndex <- EuStockMarkets[,"DAX"]
str(daxIndex)

autoplot(daxIndex, ts.linetype = "dot")

plot(
    daxIndex,
    main="EU DAX Index from 1850 to Current",
    xlab="Year",
    ylab="Index Price",
    col="blue"
)
abline(
    v=1997,
    color="red"
)

daxIndex.decompose.multi <- decompose(daxIndex,type="multiplicative")
plot(daxIndex.decompose.multi,col="blue")
abline(v=1997,col="red")

install.packages("fpp2")
library(fpp2) 
temps <- maxtemp
str(temps)

temps <- window(maxtemp, start = 1990)

temps.ses <- ses(
    temps, 
    h=5
)
plot(temps.ses)
lines(
    temps.ses$fitted,
    col="blue"
)
temps.ses$model$aicc

temps.holt <- holt(
    temps, 
    h=5, 
    damped = TRUE, 
    inital = "optimal"
)
plot(temps.holt)
lines(
    temps.holt$fitted,
    col="blue"
)


gregorovitch <- read.csv("Unit11TimeSeries_Gregorovitch.csv")
ollivander <- read.csv("Unit11TimeSeries_Ollivander.csv")

names(gregorovitch) <- c("year","wands_sold")
names(ollivander) <- c("year","wands_sold")

str(gregorovitch)
str(ollivander)



gregorovitch$year <- as.Date(gregorovitch$year, "%m/%d/%Y")
ollivander$year <- as.Date(gregorovitch$year, "%m/%d/%Y")

str(gregorovitch)
str(ollivander)



wandsSold <- merge(gregorovitch.ts,ollivander.ts)

library(dygraphs)

dygraph(wandsSold,main="Olivander vs. Gregorovitch Wand Sales",xlab="Year",ylab="Sales") %>%
    dySeries("ollivander.ts", label="Ollivander", col="red") %>%
    dySeries("gregorovitch.ts", label="Gregorovitch",col="green") %>%
    dyRangeSelector() %>%
    dyShading(from="1995-01-01",to="1999-01-01") %>%
    dyHighlight(highlightSeriesOpts = list( strokeWidth = 3 ) )
