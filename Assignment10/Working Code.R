setwd("/Users/christopherballenger/Documents/Data Science/MSDS 6306/projects/Homework_6306/Assignment10")

library(dplyr)
library(ggplot2)

load("N-MHSS-2015-DS0001-bndl-data-r/N-MHSS-2015-DS0001-data/N-MHSS-2015-DS0001-data-r.rda")

levels(mh2015_puf$LST) <- trimws(levels(mh2015_puf$LST))
str(mh2015_puf)
# b) distinct list of States
states <- unique(mh2015_puf$LST)

# c) serch for Veterans Administration medical center (VAMC)

va <- mh2015_puf[mh2015_puf$FACILITYTYPE == "Veterans Administration medical center (VAMC) or other VA health care facility",]
dim(va)
va <- va[va$LST != "AK" & va$LST != "HI" & va$LST != "PR" & va$LST != "VI" & va$LST != "AS",c(1,2)]


va.states <- va %>%
    group_by(LST) %>%
    summarize(count = n())

dim(va.states)

# d) ggplot2 of states
ggplot( va.states , aes( LST, count, fill = LST ) ) +
    geom_bar(stat="identity") +
    labs(title="Veterans Affairs Centers by State",y ="Total Medical Centers", x = "State") +
    coord_flip() +
    theme(plot.title = element_text(hjust = 0.5))

# Questions 2
# a) merge area
s <- data.frame(abb = state.abb, area = state.area, region = state.region, name = state.name)
va.states <- merge(va.states, s, by.x="LST",by.y="abb", all.x=TRUE)
va.states$per_sq_mile <-  va.states$area / va.states$count / 1000

ggplot( va.states[!is.na(va.states$per_sq_mile),]  , aes( x = reorder(name, per_sq_mile ), per_sq_mile, fill = region ) ) +
    geom_bar(stat="identity") +
    labs(title="Veterans Affairs Centers by State",y ="Total Medical Centers per 1000 sq miles", x = "State") +
    coord_flip() +
    theme(plot.title = element_text(hjust = 0.5))
