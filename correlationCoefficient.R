source("timeToSec.R")
chart_dirty = read.csv("./charts_clean.csv")

# Dependant variable
duration = charts_clean$Time.num
# Independant variable 
year = charts_clean$Year
# Get R
cor(duration, year)
# [1] 0.6713525