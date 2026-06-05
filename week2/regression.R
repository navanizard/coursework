##################################################################################
# ISRS Exercise 5.20
# Part III. Exercise 5.13 introduces data on shoulder girth and
# height of a group of individuals. The mean shoulder girth is 
# 108.20 cm with a standard deviation of 10.37 cm. The mean height 
# is 171.14 cm with a standard deviation of 9.41 cm. The correlation
# between height and shoulder girth is 0.67
# See textbook for image

# a. Write the equation of the regression line for predicting height.
sy <- 9.41
sx <- 10.37
x_bar <- 108.20
y_bar <- 171.14
r <- 0.67
m <- r * (sy/sx)
b <- y_bar - m * x_bar
# y = mx + b -> y = 0.6080x + 105.3571

# b. Intepret the slope and the intercept in this context.
# ANSWER: 
    # As the shoulder girth increases by 1 cm, the height increases 0.6080cm. 
    # When the shoulder girth is 0, the height is 105.3571cm. 

# c. Calculate R^2 of the regression line for predicting height from 
#    shoulder girth, and interpret in the context of the application. 
r_sqr <- r^2
# (NOTE: r^2 represents the proportion of variability in the response 
#        variable (y) that's explained by the explanatory variable (x).)
# ANSWER: About 45% of the variability in heights is explained by the 
#         shoulder girth.

# d. A randomly selected student from your class has a shoulder girth 
#    of 100 cm. Predict the height of this student using the model.
# ANSWER:
y_hat <- 0.6080*(100) + 105.3571 # 166.1571 cm 

# e. The student from part (d) is 160 cm tall. Calculate the residual, 
#    and explain what this residual means.
residual <- y_hat - 160 # 6.1571, which means that the difference
#                         between the predicted height and the actual 
#                         height is apprx 6 cm.

# f. A one year old has a shoulder girth of 56 cm. Would it be 
#    appropriate to use this linear model to predict the height of this child?

56 < 80 # TRUE, so it's out of range for this linear model (since the min(y) is
#         80 - as shown in the plot).

##################################################################################
# ISRS Exercise 5.29
# The scatterplot and least squares summary below show the relationship
# between weight measured in kilograms and height measured in centimeters
# of 507 physically active individuals
# See textbook for scatterplot.

# Coefficients:
#               Estimate  Std. Error  t value  Pr(>|t|)
# (Intercept)  -105.0113      7.5394   -13.93    0.0000
# height          1.0176      0.0440    23.13    0.0000


# a. Describe the relationship between height and weight.
# ANSWER: Positive correlation
# b. Write the equation of the regression line. Interpret the slope
#    and intercept in context.
# ANSWER: 
    # As the x increases by 1 cm, the y increases 1.0176cm. 
    # When the x is 0, the y is -105.0113. 
# y = 1.0176x -105.0113
# c.Do the data provide strong evidence that an increase in height 
#   is associated with an increase in weight? State the null and 
#   alternative hypotheses, report the p-value, and state your conclusion.
# d. The correlation coefficient for height and weight is 0.72. 
#    Calculate R^2 and interpret it in context.