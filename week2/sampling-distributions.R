library(tidyverse)

####################################################################################
# IST Chapter 4, Exercise 4.1
#
# Table 4.4 presents the probabilities of the random variable Y:
#
#   Value | Probability
#   ------|------------
#     0   |    1p
#     1   |    2p
#     2   |    3p
#     3   |    4p
#     4   |    5p
#     5   |    6p
#
# These probabilities are a function of the number p, the probability of
# the value "0". Answer the following questions:
#
# 1. What is the value of p? 
# WORK: 1p + 2p + 3p + 4p + 5p + 6p = 1.0 -> 21p = 1 -> p = 1/21
# 2. P(Y < 3) = 2/7
# WORK: 1p + 2p + 3p = 6p = 6/21 = 2/7
# 3. P(Y = odd) = 4/7 
# WORK: 2p + 4p + 6p = 12p = 12/21 = 4/7
# 4. P(1 <= Y < 4) = 3/7
# WORK : 2p + 3p + 4p = 9p = 9/21 = 3/7
# 5. P(|Y - 3| < 1.5) = 4/7
# WORK: 3p + 4p + 5p = 12p = 12/21 = 4/7
# 6. E(Y) = 10/3
# WORK: (0)(1p) + (1)(2p) + (2)(3p) + (3)(4p) + (4)(5p) + (5)(6p) = 2p + 6p + 12p + 20p + 30p
#       = 70p = 70/21 = 10/3
# 7. Var(Y) = 20/9
# WORK: (1/21)(0 - 10/3)^2 + (2/21)(1 - 10/3)^2 + (3/21)(2 - 10/3)^2 + (4/21)(3 - 10/3)^2 
#       + (5/21)(4 - 10/3)^2 + (6/21)(5 - 10/3)^2 = 20/9
# 8. What is the standard deviation of Y? ((2)sqrt(5))/3
# WORK: sqrt(20/9) = sqrt(20)/3 = ((2)sqrt(5))/3



####################################################################################
# IST Chapter 4, Exercise 4.2
#
# One invests $2 to participate in a game of chance. In this game a coin
# is tossed three times. If all tosses end up "Head" then the player wins
# $10. Otherwise, the player loses the investment.
#
# 1. What is the probability of winning the game? 0.125
# WORK: P(HHH) =  (0.5)*(0.5)*(0.5) = 0.125
# 2. What is the probability of losing the game? 0.875
# WORK: 1 - 0.125
# 3. What is the expected gain for the player that plays this game? $-0.75
#    (Notice that the expectation can obtain a negative value.)
# WORK: WIN = +8$; LOSE = -2$. E(X) = (0.125)*(8) + (0.875)*(-2) = -0.75



####################################################################################
# IST Chapter 6, Exercise 6.1
#
# Consider the problem of establishing regulations concerning the maximum
# number of people who can occupy a lift. In particular, we would like to
# assess the probability of exceeding maximal weight when 8 people are
# allowed to use the lift simultaneously and compare that to the probability
# of allowing 9 people into the lift.
#
# Assume that the total weight of 8 people chosen at random follows a
# Normal distribution with a mean of 560kg and a standard deviation of 57kg.
# Assume that the total weight of 9 people chosen at random follows a
# Normal distribution with a mean of 630kg and a standard deviation of 61kg.
#
# 1. What is the probability that the total weight of 8 people exceeds 650kg? 0.0572
# WORK: P(x > 650) = P(z > (650-560)/57) = pnorm((650-560)/57, lower.tail = FALSE)
# 2. What is the probability that the total weight of 9 people exceeds 650kg?
# WORK
# 3. What is the central region that contains 80% of distribution of the
#    total weight of 8 people?
# 4. What is the central region that contains 80% of distribution of the
#    total weight of 9 people?

# Hint: use pnorm() and qnorm().



####################################################################################
# IST Chapter 7, Exercise 7.1
#
# The file "pop2.csv" contains information associated to the blood pressure
# of an imaginary population of size 100,000:
# http://pluto.huji.ac.il/~msby/StatThink/Datasets/pop2.csv
#
# Variables: id, sex, age, bmi, systolic, diastolic, group
#
# Our goal is to investigate the sampling distribution of the sample average
# of the variable "bmi". We assume a sample of size n = 150.
#
# 1. Compute the population average of the variable "bmi".
# 2. Compute the population standard deviation of the variable "bmi".
# 3. Compute the expectation of the sampling distribution for the sample
#    average of the variable.
# 4. Compute the standard deviation of the sampling distribution for the
#    sample average of the variable.
# 5. Identify, using simulations, the central region that contains 80% of
#    the sampling distribution of the sample average.
# 6. Identify, using the Central Limit Theorem, an approximation of the
#    central region that contains 80% of the sampling distribution of the
#    sample average.

pop2 <- read_csv("http://pluto.huji.ac.il/~msby/StatThink/Datasets/pop2.csv")

# Hint: for (5), use replicate() to draw many samples of size 150,
# compute the mean of bmi for each, then use quantile().
# For (6), use qnorm() with the expectation and sd from (3) and (4).
