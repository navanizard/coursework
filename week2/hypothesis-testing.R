library(tidyverse)

####################################################################################
# IST Chapter 9, Exercise 9.1
magnets <- read_csv("http://pluto.huji.ac.il/~msby/StatThink/Datasets/magnets.csv")

# 1. What is the sample average of the change in score between the
#    patient's rating before the application of the device and the
#    rating after the application?
sample_mean <- mean(magnets$change)
# 2. Is the variable "active" a factor or a numeric variable?
str(magnets$active)
# 3. Compute the average value of the variable "change" for the patients that
#    received an active magnet and average value for those that received an
#    inactive placebo. (Hint: Notice that the first 29 patients received an
#    active magnet and the last 21 patients received an inactive placebo. The
#    subsequence of the first 29 values can be obtained via "change[1:29]" and
#    the last 21 values via "change[30:50]".)
sample_avg_active <- mean(magnets$change[1:29])
sample_avg_inactive <- mean(magnets$change[30:50])
# 4. Compute the sample standard deviation of the variable "change" for the
#    patients that received an active magnet and the sample standard deviation
#    for those that received an inactive placebo.
sample_sd_active <- sd(magnets$change[1:29])
sample_sd_inactive <-  sd(magnets$change[30:50])
# 5. Produce a boxplot of the variable "change" for the patients that received
#    an active magnet and for patients that received an inactive placebo. What
#    is the number of outliers in each subsequence?

magnets %>% 
    ggplot(aes(x = active, y = change)) + 
    geom_boxplot() 
 
# The active patients plot has no outliers, but the inactive patients plot has 3.

####################################################################################
# IST Chapter 10, Exercise 10.1
#
# In Subsection 10.3.2 we compare the average against the midrange as estimators
# of the expectation of the measurement. The goal of this exercise is to repeat
# the analysis, but this time compare the average to the median as estimators of
# the expectation in symmetric distributions.
#
# 1. Simulate the sampling distribution of average and the median of a sample
#    of size n = 100 from the Normal(3, 2) distribution. Compute the expectation
#    and the variance of the sample average and of the sample median. Which of
#    the two estimators has a smaller mean square error?

means <- replicate(1e4, mean(rnorm(100, mean = 3, sd = 2)))
medians <- replicate(1e4, median(rnorm(100, mean = 3, sd = 2)))

expected_mean <- mean(means)
expected_variance_for_means <- var(means)

expected_median <- mean(medians)
expected_variance_for_medians <- var(medians)

sd(means) < sd(medians) # TRUE, so the mean (as an estimator) has a smaller std error
#
# 2. Simulate the sampling distribution of average and the median of a sample
#    of size n = 100 from the Uniform(0.5, 5.5) distribution. Compute the
#    expectation and the variance of the sample average and of the sample
#    median. Which of the two estimators has a smaller mean square error?

means2 <- replicate(1e4, mean(runif(100, min = 0.5, max = 5.5)))
medians2 <- replicate(1e4, median(runif(100, min = 0.5, max = 5.5)))

expected_mean2 <- mean(means2)
expected_variance_for_means2 <- var(means2)

expected_median2 <- mean(medians2)
expected_variance_for_medians2 <- var(medians2)

sd(means2) < sd(medians2) # TRUE, the mean (as an estimator) has a smaller std error

####################################################################################
# IST Chapter 10, Exercise 10.2
#
# The goal in this exercise is to assess estimation of a proportion in a
# population on the basis of the proportion in the sample.
#
# The file "pop2.csv" was introduced in Exercise 7.1 of Chapter 7. This file
# contains information associated to the blood pressure of an imaginary
# population of size 100,000. One of the variables in the file is a factor by
# the name "group" that identifies levels of blood pressure. The levels of this
# variable are "HIGH", "LOW", and "NORMAL".
#
# The file "ex2.csv" contains a sample of size n = 150 taken from the given
# population. The file "ex2.csv" corresponds to the observed sample and the file
# "pop2.csv" corresponds to the unobserved population.

pop2 <- read_csv("http://pluto.huji.ac.il/~msby/StatThink/Datasets/pop2.csv")
ex2 <- read_csv("http://pluto.huji.ac.il/~msby/StatThink/Datasets/ex2.csv")

# 1. Compute the proportion in the sample of those with a high level of blood
#    pressure.
p_hat <- nrow(filter(ex2, group == 'HIGH')) / nrow(ex2)
# 2. Compute the proportion in the population of those with a high level of
#    blood pressure.
p <- nrow(filter(pop2, group == 'HIGH')) / nrow(pop2)
# 3. Simulate the sampling distribution of the sample proportion and compute
#    its expectation.
sampling_distribution_of_p_hat <- replicate(1e4, nrow(filter(slice_sample(pop2, n = 150), group == 'HIGH')) / 150)
expected_mean_of_sampling_dist_of_p_hat <- mean(sampling_distribution_of_p_hat)
# 4. Compute the variance of the sample proportion.
p_hat_variance <- var(sampling_distribution_of_p_hat)
# 5. It is proposed in Section 10.5 that the variance of the sample proportion
#    is Var(P_hat) = p(1 - p)/n, where p is the probability of the event (having
#    a high blood pressure in our case) and n is the sample size (n = 150 in our
#    case). Examine this proposal in the current setting.
# proposal: 
p_hat_variance == (p * (1 - p)) / 150 # Returns F, but
# 0.001350274 == 0.001347685 -> Pretty accurate

####################################################################################
# ISRS Exercise 2.2 - Heart transplants, Part II
#
# Exercise 1.50 introduces the Stanford Heart Transplant Study. Of the 34
# patients in the control group, 4 were alive at the end of the study. Of the 69
# patients in the treatment group, 24 were alive.
#
# Contingency table:
#                                    Group
#                       --------------------------
#                        Control  Treatment  Total
#          ---------------------------------------
#                Alive      4        24       28
#          ---------------------------------------
#  Outcome       Dead       30       45       75
#          ---------------------------------------
#                Total      34       69      103
#          ---------------------------------------
#
# (a) What proportion of patients in the treatment group and what proportion
#     of patients in the control group died?
p_hat_control <- 30 / 34
p_hat_treatment <- 45 / 69
# (b) One approach for investigating whether or not the treatment is effective
#     is to use a randomization technique.
#     i. What are the claims being tested? Use the same null and alternative
#          hypothesis notation used in the section.
# ANSWER:
    # H0 (Null Hypothesis): p_hat_treatment - p_hat_control = 0
    # HA (Alternative Hypothesis): p_hat_treatment - p_hat_control < 0

#     ii. The paragraph below describes the set up for such approach, if we were
#     to do it without using statistical software. Fill in the blanks with a
#     number or phrase, whichever is appropriate. 
#          We write alive on 28 cards representing patients who were
#          alive at the end of the study, and dead on 75 cards representing
#          patients who were not. Then, we shuffle these cards and split them
#          into two groups: one group of size 69 representing treatment, and
#          another group of size 34 representing control. We calculate the
#          difference between the proportion of dead cards in the treatment and
#          control groups (treatment - control) and record this value. We repeat
#          this many times to build a distribution centered at 0. Lastly, we
#          calculate the fraction of simulations where the simulated differences
#          in proportions are negative. If this fraction is low, we conclude that it is
#          unlikely to have observed such an outcome by chance and that the null
#          hypothesis should be rejected in favor of the alternative.
#     iii. What do the simulation results suggest about the effectiveness of
#          the transplant program? (See textbook page 109 for figure.)
# ANSWER: There was relatively no difference, since the results were centered around 0, 
#          which indicates that there isn't sufficient evidence supporting the effectiveness
#          of the transplant program.

####################################################################################
# ISRS Exercise 2.6 
# An experiment conducted by the MythBusters, a science entertainment TV program
# on the Discovery Channel, tested if a person can be subconsciously influenced
# into yawning if another person near them yawns. 50 people were randomly
# assigned to two groups: 34 to a group where a person near them yawned
# (treatment) and 16 to a group where there wasn't a person yawning near them
# (control). The following table shows the results of this experiment.
#
# Contingency table:
#                         --------------------------
#                         Control  Treatment  Total
#          ---------------------------------------
#               Yawn         10       4        14
#  Result       Not Yawn     24       12       36
#          ---------------------------------------
#                Total       34       16       50
#          ---------------------------------------
#
# A simulation was conducted to understand the distribution of the test
# statistic under the assumption of independence: having someone yawn near
# another person has no influence on if the other person will yawn. In order to
# conduct the simulation, a researcher wrote yawn on 14 index cards and not yawn
# on 36 index cards to indicate whether or not a person yawned. Then he shuffled
# the cards and dealt them into two groups of size 34 and 16 for treatment and
# control, respectively. He counted how many participants in each simulated
# group yawned in an apparent response to a nearby yawning person, and
# calculated the difference between the simulated proportions of yawning as
# ˆptrtmt,sim − pˆctrl,sim. This simulation was repeated 10,000 times using
# software to obtain 10,000 differences that are due to chance alone. The
# histogram shows the distribution of the simulated differences.
#
# (a) What are the hypotheses?
# ANSWER:
    # H0 (Null Hypothesis): p_hat_treatment - p_hat_control = 0
    # HA (Alternative Hypothesis): p_hat_treatment - p_hat_control > 0

# (b) Calculate the observed difference between the yawning rates under the
#     two scenarios.
p_hat_control2 <- 10/34
p_hat_treatment2 <- 4/16
difference_in_yawning_rate <- p_hat_treatment2 - p_hat_control2 # -0.04411765

# (c) Estimate the p-value using the figure (page 113) and determine the conclusion of
#     the hypothesis test.
# ANSWER: The p-value is estimated to be 0.25, so we fail to 
#         reject the null, meaning there is no sufficient evidence 
#         to support the claim that a person can be subconsciously influenced
#         into yawning if another person near them yawns. 

####################################################################################
# IST Exercise 9.2 
# In Chapter 13 we will present a statistical test for testing
# if there is a difference between the patients that received the active magnets
# and the patients that received the inactive placebo in terms of the expected
# value of the variable that measures the change. The test statist for this
# problem is taken to be
#  T = (X_bar_1 - X_bar_2) / sqrt(S_1^2/29 + S_2^2/21)
# where X_bar_1 and X_bar_2 are the sample averages for the 29 patients that 
# receive active magnets and for the 21 patients that receive inactive placebo, 
# respectively. The quantities S_1^2 and S_^2 are the sample variances for each
# of the two samples. Our goal is to investigate the sampling distribution 
# of this statistic in a case where both expectations are equal to each other 
# and to compare this distribution to the observed value of the statistic.
#
# 1. Assume that the expectation of the measurement is equal to 3.5, regardless
#    of what the type of treatment that the patient received. We take the
#    standard deviation of the measurement for patients the receives an active
#    magnet to be equal to 3 and for those that received the inactive placebo we
#    take it to be equal to 1.5. Assume that the distribution of the
#    measurements is Normal and there are 29 patients in the first group and 21
#    in the second. Find the interval that contains 95% of the sampling
#    distribution of the statistic. [-2.01488, 1.981477]
t_distibution <- replicate(1e4, (mean(sample1 <- rnorm(29, mean = 3.5, sd = 3)) - mean(sample2 <- rnorm(21, mean = 3.5, sd = 1.5))) / sqrt(((sd(sample1))^2)/29 + ((sd(sample2))^2)/21))

lower_bound <- quantile(t_distibution, 0.025) # -2.01488
upper_bound <- quantile(t_distibution, 0.975) # 1.981477

# 2. Does the observed value of T (computed from the "magnets" data) fall
#    inside or outside the interval computed in 1?
sample_avg_active <- mean(magnets$change[1:29])
sample_avg_inactive <- mean(magnets$change[30:50])
sample_sd_active <- sd(magnets$change[1:29])
sample_sd_inactive <-  sd(magnets$change[30:50])
t_val <- (sample_avg_active - sample_avg_inactive) / sqrt((sample_sd_active)^2/29 + (sample_sd_inactive)^2/21)

(lower_bound < t_val) & (t_val < upper_bound) # FALSE, so the observed value of T falls 
#                                               outside the 95% confidence interval.
