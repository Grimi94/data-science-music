library("ggplot2")

charts_clean = read.delim("./charts_clean.tsv")
grammys = read.delim("./grammys.tsv", header=FALSE)
colnames(grammys) <- c("Year","Track")


# mode function, source: stackoverflow
Mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

mean <- mean(charts_clean$Time.num)
deviation <- sd(charts_clean$Time.num)
median <- median(charts_clean$Time.num)
mode <- mode (charts_clean$Time.num)


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

is.na(grammys$Time.num) <- which(grammys$Time.num == "")
grammys <- subset(grammys, !is.na(grammys$Time.num))
# scatter plot settings


scatter_plot <- ggplot() + 
  geom_smooth(data=grammys, aes(x=Year, y=Time.num), color="Black") + 
  geom_smooth(data=charts_clean, aes(x=Year, y=Time.num), color="Blue") + 
  labs(x="Year", y="Length (seconds)", title="Year vs Songs Length") +
print(scatter_plot)
