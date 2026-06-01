########################################
# load libraries
########################################
#change directories
setwd("c:/Users/nava/Documents/coursework/week1")

# load some packages that we'll need
library(tidyverse)
library(scales)

# be picky about white backgrounds on our plots
theme_set(theme_bw())

# load RData file output by load_trips.R
load('trips.RData')


########################################
# plot trip data
########################################

# plot the distribution of trip times across all rides (compare a histogram vs. a density plot)
trips %>% 
    filter(tripduration <= 40000) %>% #filter out all trips longer than 24 hours
    group_by(tripduration) %>%
    summarise(count = n()) %>%
    ggplot(aes(x = tripduration / 60)) +
    geom_histogram(bins = 10) +
    # scale_x_log10(label = comma) +
    labs(
        x = 'Trip Duration (minutes)', 
        y = 'Number of Trips', 
        title = 'Distribution of Trip Durations Over All Rides')

# plot the distribution of trip times by rider type indicated using color and fill (compare a histogram vs. a density plot)
trips %>% 
    filter(tripduration <= 40000) %>% #filter out all trips longer than 24 hours
    ggplot(aes(x = tripduration / 60, fill = usertype)) +
    geom_histogram(bins = 10) +
    scale_y_log10(label = comma) +
    labs(
        x = 'Trip Duration (minutes)', 
        y = 'Number of Trips', 
        title = 'Distribution of Trip Durations By Rider Type',
        fill = 'User Type') +
        facet_wrap(~ usertype, scales = "free") #change the scale of the y-axis for each graph

# plot the total number of trips on each day in the dataset 
trips %>%
    mutate(date = as.Date(starttime)) %>%
    group_by(date) %>%
    summarise(count = n()) %>%
    ggplot(aes(x = date, y = count)) + 
    geom_point() + 
    labs(
        x = 'Date', 
        y = 'Number of Trips', 
        title = 'Number of Trips Per Day')


# plot the total number of trips (on the y axis) by age (on the x axis) and gender (indicated with color)
trips %>% 
    mutate(age = 2014 - birth_year) %>%
    group_by(age, gender) %>%
    summarize(count = n()) %>%
    ggplot(aes(x = age, y = count, color = gender)) +
    geom_point() +
    ylim(0, 30000) +
    labs(
        x = 'Age', 
        y = 'Number of Trips', 
        title = 'Number of Trips by Age and Gender',
        color = 'Gender')

# plot the ratio of male to female trips (on the y axis) by age (on the x axis) ------------------------------------
# hint: use the pivot_wider() function to reshape things to make it easier to compute this ratio
# (you can skip this and come back to it tomorrow if we haven't covered pivot_wider() yet)

########################################
# plot weather data
########################################
# plot the minimum temperature (on the y axis) over each day (on the x axis)
weather %>% 
    ggplot(aes(x = date, y = tmin)) +
    geom_point() +
    labs(
        x = 'Date', 
        y = 'Minimun Temperature', 
        title = 'Minimum Temperature Over Each Day')

# plot the minimum temperature and maximum temperature (on the y axis, with different colors) over each day (on the x axis) -----------------------------------------------------------
# hint: try using the pivot_longer() function for this to reshape things before plotting
# (you can skip this and come back to it tomorrow if we haven't covered reshaping data yet)

########################################
# plot trip and weather data
########################################

# join trips and weather
trips_with_weather <- inner_join(trips, weather, by="ymd")

# plot the number of trips as a function of the minimum temperature, where each point represents a day
# you'll need to summarize the trips and join to the weather data to do this
trips_with_weather %>%
    group_by(tmin, day = as.Date(starttime)) %>%
    summarize(count = n()) %>%
    ggplot(aes(x = tmin, y = count)) +
    geom_point() +
    labs(
        x = 'Minimum Temperature', 
        y = 'Number of Trips', 
        title = 'Number of Trips as a Function of the Minimum Temperature') 

# repeat this, splitting results by whether there was substantial precipitation or not
# you'll need to decide what constitutes "substantial precipitation" and create a new T/F column to indicate this
trips_with_weather %>% 
    mutate(substantial_prcp = (prcp >= mean(prcp))) %>%
    group_by(tmin, substantial_prcp) %>%
    summarize(count = n()) %>%
    ggplot(aes(x = tmin, y = count, color = substantial_prcp)) +
    geom_point() +
    labs(
        x = 'Minimum Temperature', 
        y = 'Number of Trips', 
        color = 'Substantial Percipitation',
        title = 'Number of Trips as a Function of the Minimum Temperature') 

# add a smoothed fit on top of the previous plot, using geom_smooth
trips_with_weather %>% 
    mutate(substantial_prcp = (prcp >= mean(prcp))) %>%
    group_by(tmin, substantial_prcp) %>%
    summarize(count = n()) %>%
    ggplot(aes(x = tmin, y = count, color = substantial_prcp)) +
    geom_point() +
    geom_smooth() +
    labs(
        x = 'Minimum Temperature', 
        y = 'Number of Trips', 
        color = 'Substantial Percipitation',
        title = 'Number of Trips as a Function of the Minimum Temperature') 

# compute the average number of trips and standard deviation in number of trips by hour of the day
# hint: use the hour() function from the lubridate package
trips_with_weather %>%
    mutate(hr = hour(date)) %>%
    group_by(hr) %>%
    summarize(count = n()) %>%
    summarize(avg = mean(count), std = sd(count)) %>%
    ggplot(aes())

# plot the above

# repeat this, but now split the results by day of the week (Monday, Tuesday, ...) or weekday vs. weekend days
# hint: use the wday() function from the lubridate package
