# CVAP Data Prep, Calculate Parolee Estimate:CVAP Ratio
# download from https://www.census.gov/programs-surveys/decennial-census/about/voting-rights/cvap.html

library(data.table)
library(dplyr)
library(tidycensus)
library(here)

###### Prep CVAP Data ####
# load county level data from source file
cvap <- fread("data/source/CVAP/County.csv", header = TRUE, stringsAsFactors = FALSE, data.table = FALSE)

# limit to CA counties
cvap_tot <- 
  cvap %>% 
  filter(geoname %like% "California" & lntitle =="Total" )

head(cvap_tot)


# may be interesting to see if potentially counties with larger POC CVAP populations are receiving higher parolees?
cvap_race <- 
  cvap %>% 
  # filter race/ethnic groups
  filter(geoname %like% " California" & !lntitle %in% c("Total", "White Alone", "Not Hispanic or Latino")) %>%
  
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

# I'll just export the cvap by race/eth for now. 
write.csv(cvap_race, "data/CVAP_2018_RaceEth.csv", row.names = FALSE)


###### Estimate Parolee Total by County ######

# we have the number of parolees released each year into each county (4-year average)
# source: CDCR
# https://www.cdcr.ca.gov/research/wp-content/uploads/sites/174/2020/01/201812_DataPoints.pdf
par <- fread("data/Parole_county_data.csv", header = TRUE, stringsAsFactors = FALSE, data.table = FALSE)
head(par)

# calculate 4-year average state total for the average number of parolees released in one year and 
# calc the county share of state tot
par$county_share = par$`4-year_mean_rounded`/sum(par$`4-year_mean_rounded`)

head(par)

# total number of parolees at the state level
# source: CDCR
par_tot <-  fread("data/Parolee Pop by Major Parole County 15-18.csv", header = TRUE, stringsAsFactors = FALSE, data.table = FALSE)

head(par_tot)

# Calculate the 4 yr average for parolee total  in the state/county (NOT the # parolees released in one year, but EVERYBODY)
par_tot$tot_avg = rowMeans(par_tot[,2:5])
head(par_tot)

# Estimate the number of parolees in each county in CA in 2018 by using a weighted average

# join county parolee total where data is available, for all others estimate a weighted average
par_county <- 
par %>% 
  left_join(par_tot %>% 
              select(County, tot_avg), by="County") %>% 
  
  # if the total 4-avg is NA (no parolee tot for that county), substitute the state average multiplied by the county weight
  mutate(par_tot_est = ifelse(is.na(tot_avg), par_tot[par_tot$County=="Total", ]$tot_avg * county_share, tot_avg))

head(par_county)


# export the estimated number of parolees in each county in 2018
write.csv(par_county, "data/Parolee_EstTotal_County.csv", row.names = FALSE)


###### Calculate the Ratio of Parolee:Eligible Voters #####

# join cvap tot to parolee by county

ratio_dat <- 
par_county %>% 
  select(County, par_tot_est) %>% 
  left_join(
    cvap_tot %>% 
      mutate(County = gsub(" County, California", "", geoname)) %>% 
      select(County, cvap_est, cvap_moe)) %>% 
  mutate( ratio_par_cvap = par_tot_est/cvap_est,
          rate_per_100kcvap = par_tot_est/(cvap_est/100000))

head(ratio_dat)
View(ratio_dat)

# review counties with top 5-10 ratio of parolees to eligible voters
ratio_dat %>% 
  top_n(5, ratio_par_cvap) %>% 
  arrange(-ratio_par_cvap) # Trinity, Kings, Fresno, Yuba and Tehama


# export ratio table
write.csv(ratio_dat, "data/Ratio_Parolees_to_EligibleVoters.csv", row.names = FALSE)
