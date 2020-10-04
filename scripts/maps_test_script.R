#Going to plot our average parolee data per county on a CA map

library(ggplot2)
library(maps)
library(dplyr)
library(RColorBrewer)

#load in our parolee data by county which we add to our map
Par_Ratio_Data <- read.csv("C:/Users/rica460/Documents/Postdoc/Ratio_Parolees_to_EligibleVoters.csv")

Par_Ratio_Data$par_tot_est <- round(Par_Ratio_Data$par_tot_est)
Par_Ratio_Data$rate_per_100kcvap <- round(Par_Ratio_Data$rate_per_100kcvap)

#need to pull map of CA county in a format that can be used by ggplot, map_data is a ggplot2 function that turns
#maps from the map package into a dataframe suitable for ggplot
CA_countdf <- map_data(map='county', 'california', boundary=TRUE)

#look at dataframe to understand structure
head(CA_countdf)

#These data have to be plotted using geom_polygon(). I used this tutorial to help
#https://eriqande.github.io/rep-res-web/lectures/making-maps-with-R.html this mapping process as I don't use ggplot
#for maps very often, but this will keep with the theme of the rest of our data visualization

#okie doke, so now we want to add our parolee data to our counties, first subset county name and the column we want
Par_Data_Avg <- cbind.data.frame(Par_Ratio_Data$County, Par_Ratio_Data$par_tot_est, Par_Ratio_Data$rate_per_100kcvap)

#make column name match CA_countdf so can join on that column name
colnames(Par_Data_Avg) <- c("subregion", "Parolee_Average", "Parolee_Rate_100kcvap")

#change to lower case subregions so can match with county df
Par_Data_Avg$subregion <- tolower(Par_Data_Avg$subregion)

#join datasets so parolees are in the map df
CA_countdf_par <- inner_join(CA_countdf, Par_Data_Avg, by="subregion")

#need to get centroids of map polygons to do county labels
Map1 <- map("county", "california", plot=FALSE, fill=TRUE)
Map_centroid <- maps:::apply.polygon(Map1, maps:::centroid.polygon)

#pull out just lat/long of the center
Labs_latlong <- Reduce(rbind, Map_centroid)

#combine with county names and parolee data
Labs <- cbind.data.frame(Labs_latlong, Par_Ratio_Data$County, Par_Ratio_Data$par_tot_est, Par_Ratio_Data$rate_per_100kcvap)
colnames(Labs) <- c("long", "lat", "names", "Parole_Average", "Parolee_Rate_100kcvap")


#create a theme to remove the axes and labels
noaxes_theme <- theme(
  axis.text = element_blank(),
  axis.line = element_blank(),
  axis.ticks = element_blank(),
  panel.border = element_blank(),
  panel.grid = element_blank(),
  axis.title = element_blank()
)

col = c("lightyellow", "wheat", "peachpuff1", "tan1")

#map of average parolees over 2015-2018 by county
Count_Parolavg <- ggplot(data=CA_countdf, mapping=aes(x=long, y=lat, group=group))+
  coord_fixed(1.3)+
  geom_polygon (data=CA_countdf_par, aes(fill=Parolee_Average), color="gray48")+
  scale_fill_gradientn(colours=col, guide="colourbar", aesthetics="fill")+
  geom_text(data=Labs, aes(label=names, group=names), nudge_y = 0.05, size=2)+
  geom_text(data=Labs, aes(label=Parole_Average, group=Parole_Average), nudge_y = -0.05, size=2)+
  ggtitle("Average Parolees Released by County 2015-2018")+
  noaxes_theme
Count_Parolavg


#map of average parolees 2015-2018 rate of parolees to 100k vap
Count_Parolrat <- ggplot(data=CA_countdf, mapping=aes(x=long, y=lat, group=group))+
  coord_fixed(1.3)+
  geom_polygon (data=CA_countdf_par, aes(fill=Parolee_Rate_100kcvap), color="gray48")+
  scale_fill_gradientn(colours=col, guide="colourbar", aesthetics="fill")+
  geom_text(data=Labs, aes(label=names, group=names), nudge_y = 0.05, size=2)+
  geom_text(data=Labs, aes(label= Parolee_Rate_100kcvap, group=Parolee_Rate_100kcvap), nudge_y = -0.05, size=2)+
  ggtitle("Rate of Parolees per 100k Citizen Voting Age Population by County")+
  noaxes_theme
Count_Parolrat


#try it with highmaps, hopefully make it interactive
library(highcharter)

#used https://jkunst.com/highcharter/articles/maps.html as a guidance for making this map in highcharter
#so highcharts is a javascript library, but highcharter is a wrapper for that

#okay so we need to download the map, and then extract the metadata from that map so we know how to join
#our data to the map
mapdata <- get_data_from_map(download_map_data("countries/us/us-ca-all"))

#lets you look at the data
glimpse(mapdata)

#it looks like $name is what we want, those look like the county names


hcmap(
  map="countries/us/us-ca-all", data=Par_Ratio_Data, 
  joinBy = c("name", "County"), value="par_tot_est",
  dataLabels= list(enabled=TRUE, format="{point.name}")
) %>%
  hc_colorAxis(minColor="#FFF8DC", maxColor = "#F4A460")%>%
  hc_title(text="Average Parolees Released by County 2015-2018")

#okay now make the parolees / 100 k VAP map

hcmap(
  map="countries/us/us-ca-all", data=Par_Ratio_Data, 
  joinBy = c("name", "County"), value="rate_per_100kcvap",
  dataLabels= list(enabled=TRUE, format="{point.name}")
) %>%
  hc_colorAxis(minColor="#FFF8DC", maxColor = "#F4A460")%>%
  hc_title(text="Rate of Parolees per 100k Citizen Voting Age Population by County")
