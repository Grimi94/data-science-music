library("ggplot2")
charts_clean = read.delim("./charts_clean.tsv")

# scatter plot settings
scatter_plot <- ggplot(charts_clean, aes(x=Year, y=Time.num)) + 
  geom_point(alpha=1/80, color="blue") + 
  geom_smooth(color="Black") + 
  labs(x="Year", y="Length (seconds)", title="Year vs Songs Length") 
print(scatter_plot)

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

print(histogram_plot)
