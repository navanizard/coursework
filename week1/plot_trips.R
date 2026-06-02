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
    geom_histogram(bins = 30) +
    labs(
        x = 'Trip Duration (minutes)', 
        y = 'Number of Trips', 
        title = 'Distribution of Trip Durations Over All Rides')

# plot the distribution of trip times by rider type indicated using color and fill (compare a histogram vs. a density plot)
trips %>% 
    filter(tripduration <= 40000) %>% #filter out all trips longer than 24 hours
    ggplot(aes(x = tripduration / 60, fill = usertype)) +
    geom_histogram(bins = 10) +
    scale_y_continuous(label = comma) +
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

# plot the ratio of male to female trips (on the y axis) by age (on the x axis) 
# hint: use the pivot_wider() function to reshape things to make it easier to compute this ratio
trips %>%
    filter(!is.na(birth_year), gender != "Unknown") %>% #filter out NA in gender and age
    mutate(age = 2014 - birth_year) %>%
    group_by(age, gender) %>%
    summarise(count = n()) %>%
    pivot_wider(names_from = gender, values_from = count) %>%
    mutate(ratio = Male / Female) %>%
    ggplot(aes(x = age, y = ratio, color = age)) +
    geom_point() + 
    xlim(0, 80) + 
    labs(
        x = 'Age', 
        y = 'Ratio of Male to Female', 
        title = 'Ratio of Male to Female Trips by Age',
        color = 'Age')


########################################
# plot weather data
########################################
# plot the minimum temperature (on the y axis) over each day (on the x axis)
weather %>% 
    ggplot(aes(x = ymd, y = tmin)) +
    geom_point() +
    labs(
        x = 'Date', 
        y = 'Minimun Temperature', 
        title = 'Minimum Temperature Over Each Day') +
    scale_x_date(breaks = '3 months')

# plot the minimum temperature and maximum temperature (on the y axis, with different colors) over each day (on the x axis) 
# hint: try using the pivot_longer() function for this to reshape things before plotting
weather %>%
    pivot_longer(names_to = 'tmin_max', values_to = 'temps', cols = c(tmin, tmax)) %>%
    ggplot(aes(x = ymd, y = temps, color = tmin_max)) +
    geom_line() +
    labs (
        x = 'Date',
        y = 'Min and Max Temperature',
        title = 'Min and Max Temperatures Over Each Day', 
        color = 'Temperature Limits') +
        scale_x_date(breaks = '1 month')
      

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
    group_by(ymd, substantial_prcp, tmin) %>%
    summarize(count = n()) %>%
    ggplot(aes(x = tmin, y = count, color = substantial_prcp)) +
    geom_point() +
    labs(
        x = 'Minimum Temperature', 
        y = 'Number of Trips', 
        color = 'Substantial Percipitation',
        title = 'Number of Trips as a Function of the Minimum Temperature') + 
    scale_y_continuous(label = comma)

# add a smoothed fit on top of the previous plot, using geom_smooth
trips_with_weather %>% 
    mutate(substantial_prcp = (prcp >= mean(prcp))) %>%
    group_by(ymd, tmin, substantial_prcp) %>%
    summarize(count = n()) %>%
    ggplot(aes(x = tmin, y = count, color = substantial_prcp)) +
    geom_point() +
    geom_smooth() +
    labs(
        x = 'Minimum Temperature', 
        y = 'Number of Trips', 
        color = 'Substantial Percipitation',
        title = 'Number of Trips as a Function of the Minimum Temperature') +
    scale_y_continuous(label = comma)

# compute and plot the average number of trips and standard deviation in number of trips by hour of the day
# hint: use the hour() function from the lubridate package
trips_with_weather %>%
    mutate(hr = hour(starttime), day = as.Date(starttime)) %>%
    group_by(hr, day) %>%
    summarize(count = n()) %>%
    group_by(hr) %>%
    summarize(avg = mean(count), std = sd(count)) %>%
    ggplot(aes(x = hr, y = avg, ymin = avg - std, ymax = avg + std)) +
    geom_pointrange() +
    labs(
        x = 'Hour of the Day', 
        y = 'Average Number of Trips', 
        title = 'Avg Number of Trips and Std in Number of Trips by Hour of the Day') 

# repeat this, but now split the results by day of the week (Monday, Tuesday, ...) or weekday vs. weekend days
# hint: use the wday() function from the lubridate package
trips_with_weather %>%
    mutate(hr = hour(starttime), weekday = wday(starttime, label = TRUE), day = as.Date(starttime)) %>%
    group_by(hr, weekday, day) %>%
    summarize(count = n()) %>%
    group_by(hr, weekday) %>%
    summarize(avg = mean(count), std = sd(count)) %>%
    ggplot(aes(x = hr, y = avg, ymin = avg - std, ymax = avg + std)) +
    geom_pointrange() +
    labs(
        x = 'Hour of the Day', 
        y = 'Average Number of Trips', 
        title = 'Avg Number of Trips and Std in Number of Trips by Hour of the Day') +
        facet_wrap(~ weekday)