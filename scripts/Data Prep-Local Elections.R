# local election data
library(data.table)
library(dplyr)
library(ggplot2)
library(here)
usethis::use_git()


elec <- read.csv("data/local_elections.csv", stringsAsFactors = FALSE)
head(elec)
str(elec)

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
