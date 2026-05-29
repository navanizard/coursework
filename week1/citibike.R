library(tidyverse)
library(lubridate)

########################################
# READ AND TRANSFORM THE DATA
########################################

# read one month of data
trips <- read_csv('201402-citibike-tripdata.csv')

# replace spaces in column names with underscores
names(trips) <- gsub(' ', '_', names(trips))

# convert dates strings to dates
# trips <- mutate(trips, starttime = mdy_hms(starttime), stoptime = mdy_hms(stoptime))

# recode gender as a factor 0->"Unknown", 1->"Male", 2->"Female"
trips <- mutate(trips, gender = factor(gender, levels=c(0,1,2), labels = c("Unknown","Male","Female")))


########################################
# YOUR SOLUTIONS BELOW
########################################

# count the number of trips (= rows in the data frame)
nrow(trips)
#ANSWER: 224,736 rows

# find the earliest and latest birth years (see help for max and min to deal with NAs)
trips %>% 
    mutate(birth_year = na_if(birth_year, '\\N')) %>%
    summarize(min_birth_year = min(birth_year, na.rm = TRUE), max_birth_year = max(birth_year, na.rm = TRUE))
#ANSWER: Earliest = 1899, Latest = 1997

# use filter and grepl to find all trips that either start or end on broadway
trips %>% 
    filter(grepl('Broadway', start_station_name) 
        | grepl('Broadway', end_station_name))

# do the same, but find all trips that both start and end on broadway
trips %>% 
    filter(grepl('Broadway', start_station_name) 
        & grepl('Broadway', end_station_name))

# find all unique station names
c(trips$start_station_name, trips$end_station_name) %>% 
    n_distinct()

# count the number of trips by gender, the average trip time by gender, and the standard deviation in trip time by gender
# do this all at once, by using summarize() with multiple arguments
trips %>% 
    group_by(gender) %>%
    summarize(total_trips = n(), 
                avg_trip_duration = mean(tripduration), 
                std = sd(tripduration))

# find the 10 most frequent station-to-station trips
trips %>% 
    group_by(start_station_name, end_station_name) %>% 
    summarize(count = n()) %>% 
    arrange(desc(count)) %>%
    head(10)

# find the top 3 end stations for trips starting from each start station 
trips %>% 
    group_by(start_station_name, end_station_name) %>% 
    summarise(count = n()) %>%
    group_by(start_station_name) %>%
    arrange(desc(count)) %>%
    slice(1:3)

# find the top 3 most common station-to-station trips by gender
trips %>%
    group_by(gender, start_station_name, end_station_name) %>%
    summarize(count = n()) %>%
    group_by(gender) %>%
    arrange(desc(count)) %>%
    slice(1:3)

# find the day with the most trips
# tip: first add a column for year/month/day without time of day (use as.Date or floor_date from the lubridate package)
trips %>% 
    mutate(date = as.Date(starttime)) %>% 
    group_by(date) %>% 
    summarize(count = n()) %>% 
    arrange(desc(count)) %>%
    head(1)
#ANSWER: 2014-02-02 (13, 816 trips)

# compute the average number of trips taken during each of the 24 hours of the day across the entire month
trips %>% 
    mutate(hour = hour(starttime), date = as.Date(starttime)) %>% 
    group_by(hour, date) %>% 
    summarize(count = n()) %>% 
    summarize(avg = mean(count))
    
# what time(s) of day tend to be peak hour(s)?
trips %>% 
    mutate(hour = hour(starttime), date = as.Date(starttime)) %>% 
    group_by(hour, date) %>% 
    summarize(count = n()) %>% 
    summarize(avg = mean(count)) %>% 
    filter(avg == max(avg))