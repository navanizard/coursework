library(tidyverse)

####################################################################################
# 12.2.1. Exercise 2
# Compute the rate for table2, and table 4a + table4b. You will need
# to perform four operations:

#TABLE 2:
#   1. Extract the number of TB cases per country per year.
    # table2 %>%
    #   pivot_wider(names_from = type, values_from = count) %>% 
    #   group_by(country, year) %>%
    #   select(cases)
#   2. Extract the matching population per country per year.
    # table2 %>%
    #   pivot_wider(names_from = type, values_from = count) %>% 
    #   group_by(country, year) %>%
    #   select(population)
#   3. Divide cases by population, and multiply by 10000.
#   4. Store back in the appropriate place.
table2 %>%
  pivot_wider(names_from = type, values_from = count) %>% 
  group_by(country, year) %>%
  mutate(ratio_of_cases_to_pop = (cases / population)* 10000)


#TABLE 4:
#Join the tables
tbl4a <- table4a %>% pivot_longer(names_to = "year", values_to = "cases", cols = c('1999', '2000'))
tbl4b <- table4b %>% pivot_longer(names_to = "year", values_to = "population", cols = c('1999', '2000'))
table4 <- full_join(tbl4a, tbl4b)
#   1. Extract the number of TB cases per country per year.
    # table4 %>%
    #   select(country, year, cases)
#   2. Extract the matching population per country per year.
    # table4 %>%
    #   select(country, year, population)
#   3. Divide cases by population, and multiply by 10000.
#   4. Store back in the appropriate place.
table4 %>%
  mutate(ratio_of_cases_to_pop = (cases / population) * 10000)

# Which representation is easiest to work with? Which is hardest? Why?
# ANSWER: The table4 representation is easier, since it had (once joined), the cases and population
#         counts as seperate columns so it was easier to select / extract the data needed. With table2, 
#         we first had to restructure the data (pivot_wider()) in order to seperate the fields.

####################################################################################
# 12.3.3 Exercise 1
# 1. Why are pivot_longer() and pivot_wider() not perfectly symmetrical?
# Carefully consider the following example:
stocks <- tibble(
  year   = c(2015, 2015, 2016, 2016),
  half  = c(   1,    2,     1,    2),
  return = c(1.88, 0.59, 0.92, 0.17)
)
stocks %>% 
  pivot_wider(names_from = year, values_from = return) %>% 
  pivot_longer(`2015`:`2016`, names_to = "year", values_to = "return")

# (Hint: look at the variable types and think about column names.)
# pivot_longer() has a names_ptypes argument, e.g.  names_ptypes = list(year = double()). 
# What does it do? 

# ANSWER: pivot_wider() creates a new column, with the name of the new column being of type "char", so even if
#         we were to pivot_longer() it back, which would take the names of the columns and stores them as values, 
#         it would now store those as characters, regardless of their initial types.

####################################################################################
# 12.3.3 Exercise 3
# What would happen if you widen this table? Why? 
# ANSWER: It would attempt to seperate the ages and heights as new columns, but since
#         there are duplicate entries the age for the same given name, there'd be an error. 
# How could you add a new column to uniquely identify each value?
# ANSWER: pivot_wider(names_from: names, values_from = values) after adding a row number to distinguish
#         between each observation. 

people <- tribble(
  ~name,             ~names,  ~values,
  #-----------------|--------|------
  "Phillip Woods",   "age",       45,
  "Phillip Woods",   "height",   186,
  "Phillip Woods",   "age",       50,
  "Jessica Cordero", "age",       37,
  "Jessica Cordero", "height",   156
)