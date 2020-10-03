# CVAP Data Prep
# download from https://www.census.gov/programs-surveys/decennial-census/about/voting-rights/cvap.html

library(data.table)
library(dplyr)
library(tidycensus)
library(here)
usethis::use_git()

# load county level data from source file
cvap <- fread("data/source/CVAP/County.csv", header = TRUE, stringsAsFactors = FALSE, data.table = FALSE)

# limit to CA counties
cvap_tot <- 
  cvap %>% 
  filter(geoname %like% ", California" & lntitle =="Total" )

head(cvap_tot)


# may be interesting to see if potentially counties with larger POC CVAP populations are receiving higher parolees?
cvap_race <- 
  cvap %>% 
  # filter race/ethnic groups
  filter(geoname %like% ", California" & !lntitle %in% c("Total", "White Alone", "Not Hispanic or Latino")) %>%
  
  # join total cvap
  left_join(cvap_tot %>% 
              select(geoname, geoid, cvap_est, cvap_moe) %>% 
              rename("cvap_tot" = cvap_est ,
                     "cvap_tot_moe" = cvap_moe), 
            by=c("geoname", "geoid")) %>%
  
  # calc percent cvap for that race/ethnic group + moe and cv for the estimate
  mutate(prc_cvap = cvap_est/cvap_tot,
         prc_cvap_moe = moe_prop(cvap_est, cvap_tot, cvap_moe, cvap_tot_moe),
         prc_cvap_cv = (prc_cvap_moe/1.645)/prc_cvap)

head(cvap_race)


# quick exploration of the data just for context
# quick look at top 15 race/ethnicities for all counties
cvap_race %>% 
  top_n(15, prc_cvap) 

# quick look at the next highest groups if we don't look at HL
cvap_race %>%
  filter(lnnumber !="13") %>% 
  top_n(15, prc_cvap) 

# quick look at top parolee (per 100k resident) county
cvap_race %>% 
  filter(geoname %like% "Kings") # 43% Latino, next highest Black and Asian


## Export data
# 

# I'll just export the cvap by race/eth for now. 
write.csv(cvap_race, "data/CVAP_2018_RaceEth.csv", row.names = FALSE)

