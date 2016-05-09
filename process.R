library("ggplot2")

charts_clean = read.delim("./charts_clean.tsv")
grammys = read.delim("./grammys.tsv", header=FALSE)
colnames(grammys) <- c("Year","Track")


# mode function, source: stackoverflow
Mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

Scale <- function(x) {
  return(log10(x))
}

mean <- mean(charts_clean$Time.num)
deviation <- sd(charts_clean$Time.num)
median <- median(charts_clean$Time.num)
mode <- Mode(charts_clean$Time.num)


# histogram plot settings
histogram_plot <-  ggplot(charts_clean, aes(Time.num), sd = sd(y)) + geom_histogram() +
  #geom_vline(aes(xintercept = median), color="blue") +
  geom_vline(aes(xintercept = mean), color="white") +
  geom_vline(aes(xintercept = mean - deviation), color="lightgray") +
  geom_vline(aes(xintercept = mean + deviation), color="lightgray") +
  #geom_vline(aes(xintercept = mode), color="#FF9999") +
  labs(x="Song Length(seconds)", title="Songs Length Histogram") 

#print(histogram_plot)


func_setSongLength <- function(trackName){
  result <- charts_clean[charts_clean[, "Track"] == as.character(trackName),,drop=FALSE]
  value <- head(result,1)$Time.num
  if(length(value) > 0){
    return(value)
  } else {
    return(NA)
  }
}

grammys$Time.num <- sapply(grammys$Track, func_setSongLength)
#grammys$Time.num.log <- sapply(grammys$Time.num, Scale)
#charts_clean$Time.num.log <- sapply(charts_clean$Time.num, Scale)

# grammys data cleaning
is.na(grammys$Time.num) <- which(grammys$Time.num == "")
grammys <- subset(grammys, !is.na(grammys$Time.num))

# scatter plot settings
theplot <- ggplot() +
  geom_smooth(data=charts_clean, aes(x=Year, y=Time.num), color="blue") +
  geom_smooth(data=grammys, aes(x=Year, y=Time.num), color="Black") + 
  geom_point(data=grammys, aes(x=Year, y=Time.num), color="Black") + 
  labs(x="Year", y="Length (seconds)", title="Year vs Songs Length")

print(theplot)

#convert grammys to list
grammys <- as.list(grammys)

#Extract geom_smooth data
grap_data <- ggplot_build(theplot)$data
years_data <- grap_data[[1]][1]
predict_length <- grap_data[[1]][2]

#Apply transformations to data
smooth_data <- lapply(years_data, as.integer)
smooth_data[2] <- predict_length
names(smooth_data) <- c("Year", "Time.smooth")
df <- as.data.frame(smooth_data)
#Remove duplicated years
smooth_data <- as.list(df[!duplicated(df[,'Year']),])
#shapiro.test(grammys)
merged_data <- merge (grammys, smooth_data, by=c("Year"))

#get chi-square test over data
print(chisq.test(merged_data$Time.smooth, y=merged_data$Time.num))

  