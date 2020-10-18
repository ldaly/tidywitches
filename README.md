# tidywitches
Repository for the [CA 2020 Election Data Challenge](https://datalab.ucdavis.edu/ca-election-2020-data-challenge/)
  
**Project:** Influence of Parolee Voter Enfranchisement on Local Elections
    
**Team** install.packages("tidywitches")
  
*Laura Daly, Erica Orcutt, Sarah Byer*
  
*Interact with our Prop 17 Data Visualization [HERE](https://ldaly.github.io/tidywitches/prop17_tidywitches.html)*

We explored data relating to Prop 17, which would amend the California constitution to restore voting rights to people who have committed serious or violent crimes, who have been released from state prison but are now under state supervision (parole). Currently voting rights are restored after a person is released from state prison and has served their parole.

**Research Question**
While California has a huge population, there are many local elections in counties with smaller (eligible voter) populations where election outcomes are determined by a small number of votes. We were therefore interested in researching **how many people are on parole in each county and how the restoration of their voting rights could potentially influence local elections.** We focused the 2018 election, and on five counties with high numbers of parolees living in-county and/or high rates of parolee per 100k eligible voters: Fresno, Kings, Yuba, San Joaquin and San Bernardino.

**Conclusion**
We found that in 2018 there were many local election contests that could have been influenced by parolee voters--San Bernardino and Fresno Counties in particular both had 21 local election contests that were won by margins small enough to be influenced by the number of would-be parolee voters. Overall, local school board elections and city council races were the two election contests that could be most influenced by the passage of Prop 17.

We know that there is no guarantee all parolees would vote in elections--just like the general population. However, if parolees are not eligible to vote, no campaign or organization is going to spend time/resources doing voter outreach to them. Campaigns spend time trying to activate eligible voters that could sway the election in their favor–these local elections demonstrate that parolee voters could make a difference. Even more importantly, parolees who are eligible voters have "done their time" and deserve access to their civil rights. The local election contests in which parolee voters could sway outcomes are those that sometimes have the most influence on one's daily life and family, such as school board elections. Continuing to disenfranchise people after they have returned to their community also has ripple effects on suppressing civic engagement across the community (Burch 2014). Finally, [twenty other states](https://www.ncsl.org/research/elections-and-campaigns/felon-voting-rights.aspx) allow parolees to vote. California is behind, and it's time to catch up.

**[View our visualization HERE](https://ldaly.github.io/tidywitches/prop17_tidywitches.html)**

**Data Sources:**
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

  + Links to County Election Results:

  + San Bernardino County: 
  + http://www.sbcounty.gov/rov/elections/results/20180605/default.html
  + https://www.sbcounty.gov/rov/elections/results/20181106/default.html

  + San Joaquin County: 
  + https://opendata.sjgov.org/dataset/2018-november-general-election/resource/22e9901e-d234-4fc5-9adf-dd81157439ef

  + Kings County: 
  + https://www.countyofkings.com/home/showdocument?id=19648
  + https://www.countyofkings.com/home/showdocument?id=19291

  + Yuba County:
  + https://www.yuba.org/departments/elections/2018NovResults.php

  + Fresno County: 
  + https://www.co.fresno.ca.us/departments/county-clerk-registrar-of-voters/election-information/election-results/2018-november-general-election-results

- *Data Limitations:* Parolee data is not available at a smaller geography than county-level. CVAP estimates are known to be unstable with small populations. Some local elections are district-based, so not everyone in the county/city would be eligible to vote in those elections. Because we have no way to know where in each county parolees live, we tried to select local elections with more participating precincts so that the probability of parolee participation is greater. Some of the district-based elections are at-large seats in which all local voters were eligible to participate. 

**References**
Traci R. Burch. Effects of Imprisonment and Community Supervision on Neighborhood Political Participation in North Carolina. 2014.

Justin Goss and Joseph Hayes. California’s Changing Parole Population. 2018. https://www.ppic.org/publication/californias-changing-parole-population/

National Conference of State Legislatures. Felon Disenfranchisement. https://www.ncsl.org/research/elections-and-campaigns/felon-voting-rights.aspx

