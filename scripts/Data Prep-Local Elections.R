# local election data
library(data.table)
library(dplyr)
library(ggplot2)
library(here)


elec <- read.csv("data/local elections.csv", stringsAsFactors = FALSE)
head(elec)
str(elec)
table(elec$county)

elec <- 
  elec %>% 
  filter(office !="Proposition" & !is.na(losing_vote_count)) %>% 
  mutate(diff = winning_vote_count - losing_vote_count,
         name = paste0(office, " ", office_2))


# test plot differences
ggplot(elec, aes(x=reorder(name, diff), y=diff, fill=county)) +
  geom_bar(stat = "identity") +
  coord_flip()+
  theme_minimal()
