source("timeToSec.R")
chart_dirty = read.csv("./Book1.csv")

# Subset only specified fields
charts <- subset(chart_dirty, select = c(Year, Artist, Title, Time, Genre))
# Subset only data from 1950 to have more consistent data
charts <- subset(charts, Year > 1949)
# Create a new row with the time transformed from minutes to seconds
charts$Time.num <- sapply(charts$Time, func_timeToSec)
# Remove rows that have no info
is.na(charts$Time) <- which(charts$Time == "")
charts <- subset(charts, !is.na(charts$Time))
# Save table
write.table(charts, "charts_clean.tsv", quote = FALSE, sep = "\t", row.names = FALSE)