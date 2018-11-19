#Analysis of Lebanon Airport data
#Trends in departures and arrivals

#Addi Faerber, Nov 2018

#Data downloaded from Bureau of Transportation Statistics
# https://transtats.bts.gov/DL_SelectFields.asp?Table_ID=236&DB_Short_Name=On-Time

#Library Calls
library(tidyverse)

# Import Data------------

airports <- read_csv(file = "./data/airport_codes.csv") %>% 
  rename(airport = Description) #From https://transtats.bts.gov/DL_SelectFields.asp?Table_ID=236&DB_Short_Name=On-Time
airlines <- read_csv(file = "./data/airline_codes.csv") %>% 
  rename(airline = Description) #from https://transtats.bts.gov/DL_SelectFields.asp?Table_ID=236&DB_Short_Name=On-Time
cities <- read_csv(file = "./data/airport_city_codes.csv") %>% 
  rename(city = Description) #from https://transtats.bts.gov/DL_SelectFields.asp?Table_ID=236&DB_Short_Name=On-Time

flights <- list.files(path = "./data",
           pattern = "*REPORTING-[0-9]{1,2}.csv",
           full.names = T, 
           recursive = T) %>% 
  map_df(~read_csv(.)) %>% #Read in all files in the directories and read them into a CSV
  rename_all(tolower) %>% #lowercase variable names
  # Join in airports, airlines and city data to flights
  left_join(y = airports, by = c("origin_airport_id" = "Code")) %>% #join for origin airport
  rename(origin_airport = airport) %>% 
  left_join(y = airports, by = c("dest_airport_id" = "Code")) %>% #join again for destination airport
  rename(dest_airport = airport) 


passengers <-
  list.files(path = "./data",
             pattern = "*ALL_CARRIER-[0-9]{1,2}.csv",
             full.names = T, 
             recursive = T) %>% 
  map_df(~read_csv(.)) 



%>% #Read in all files in the directories and read them into a CSV
  rename_all(tolower) %>% #lowercase variable names
  # Join in airports, airlines and city data to flights
  left_join(y = airports, by = c("origin_airport_id" = "Code")) %>% #join for origin airport
  rename(origin_airport = airport) %>% 
  left_join(y = airports, by = c("dest_airport_id" = "Code")) %>% #join again for destination airport
  rename(dest_airport = airport) 
  
  
#Dates for Dartmouth Graduation
graduation <- c(as.Date("2012-06-10"), 
                as.Date("2013-06-09"), 
                as.Date("2014-06-08"), 
                as.Date("2015-06-14"),
                as.Date("2016-06-12"),
                as.Date("2017-06-11"),
                as.Date("2018-06-10"))
  
nongraduationSunday <- graduation + 7
nongraduationSunday2 <- graduation - 7


#tally of flights per airport on graudation and non-graduation Sundays
flights %>% 
  filter(fl_date %in% graduation | fl_date %in% nongraduationSunday | fl_date %in% nongraduationSunday2) %>% 
  group_by(origin_airport, fl_date) %>% 
  count(dest_airport)
