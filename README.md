# tidywitches
Repository for the CA 2020 Election Data Challenge, Team install.packages("tidywitches").

We explored data relating to Prop 17, which would amend the California constitution to restore voting rights to people who have committed serious or violent crimes, who have been released from state prison but are now under state supervision (parole). Currently voting rights are restored after a person is released from state prison and has served their parole.

While California has a huge population, there are many local elections in smaller-population counties where election outcomes are determined by a small number of votes. We were therefore interested in researching how many people are on parole in each county and how the restoration of their voting rights could potentially influence elections. We focused the 2018 election, and on five counties with high numbers of parolees living in-county and/or high rates of parolee per 100k eligible voters: Fresno, Kings, Yuba, San Joaquin and San Bernardino.

View our visualization here:
https://ldaly.github.io/tidywitches/prop17_tidywitches.html

Data Sources:
- Parolees released from state prison by county came from the California Department of Corrections and Rehabilitation Offender Data Points reports for 2016 and 2018. We then took a four year average (2015-2018) to smooth out any one-year irregularities.
- Parolee total estimated for each county: Scraped data from CDCR pdf reports 2016-2018 for total parolees at the state level. In R, calculated a weighted average to estimate the number of parolees at the county level using the 4-year average share of parolees released to each county each year. 

+ CDCR links:
+ 2017-2018
+ https://www.cdcr.ca.gov/research/wp-content/uploads/sites/174/2020/01/201812_DataPoints.pdf

+ 2015-2016
+ https://www.cdcr.ca.gov/research/wp-content/uploads/sites/174/2019/08/DataPoints_122016.pdf

- Eligible Voter Population: Citizen Voting Age Population (CVAP) ACS 2014-2018 5-year estimates. Downloaded from the US Census Bureau and prepared in R.
link: https://www.census.gov/programs-surveys/decennial-census/about/voting-rights/cvap.html
  
- Local Election Data: Scraped data from individual county registrar Statement of Vote (SOV) reports for 2018 Primary and General Elections. We selected five counties to explore, focusing on the counties with high numbers of parolees living in-county and/or high rates of parolee per 100k eligible voters. These counties were: Fresno, Kings, Yuba, San Joaquin and San Bernardino. 

Links to County Election Results:
San Bernardino County: 
http://www.sbcounty.gov/rov/elections/results/20180605/default.html
https://www.sbcounty.gov/rov/elections/results/20181106/default.html

San Joaquin County: 
https://opendata.sjgov.org/dataset/2018-november-general-election/resource/22e9901e-d234-4fc5-9adf-dd81157439ef

Kings County: 
https://www.countyofkings.com/home/showdocument?id=19648
https://www.countyofkings.com/home/showdocument?id=19291

Yuba County:
https://www.yuba.org/departments/elections/2018NovResults.php

Fresno County: 
https://www.co.fresno.ca.us/departments/county-clerk-registrar-of-voters/election-information/election-results/2018-november-general-election-results

- Limitations: Parolee data not available at a smaller geography. CVAP estimates known to be unstable with small populations. 
