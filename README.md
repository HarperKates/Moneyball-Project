# Moneyball-Project

Our project contains a Shiny App in which the user determines what franchises to look at and what graphs to compare.
It also has an rmd file that shows a set of plots (scatterplots, maps, etc.)

Step 1: We loaded in the csv files from Excel and cleaned both dataframes by removing non-numeric characters. We then merged them together to create a new dataframe.

Step 2: We created 5 scatterplots with W (wins) as the response variable.

Step 3: We created a map by manually finding the latitude and longitude of each stadium and inserting those vectors into a new dataframe. We loaded the US map data and used our subsetted mapfranchise dataframe to plot the points of each stadium. 

Step 4: We made an animated map showing the progression of team payroll over the years 2012-2019 for each franchise.

Step 5: We created many different scatterplots to look at different statistics to see if we could find any good conclusions. The last two scatterplots show that the OBP variable has a stronger correlation with wins than payroll over recent years, which certainly helps the case for the moneyball strategy.

Step 6: We created a Shiny App that displays 3 line graphs, which includes wins over time, payroll over time, and a given statistic over time, each for a given franchise. The user can select one of 30 franchises and one of 4 statistics from a drop-down menu, allowing us to look at a total of 120 different cases.
