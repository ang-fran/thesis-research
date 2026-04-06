# ---- Load, clean, and visualize raw data ----
library(tidyverse)
library(zoo)

mydata = read.csv("data/2026 Mar Working Data.csv")
mydata = mydata[, -c(9:10)]
mydata = na.omit(mydata)
mydata$date = as.yearqtr(as.Date(mydata$date), format = "%Y Q%q")
mydata = mydata %>%
  mutate(across(
    where(is.character),
    ~ as.numeric(gsub(",", "", .))
  ))

# Sanity checks
colSums(is.na(mydata))
str(mydata)

# Time series plot of all variables
mydata %>%
  pivot_longer(-date) %>%
  ggplot(aes(date, value)) +
  geom_line() +
  facet_wrap(~name, scales = "free") +
  theme_minimal()

# Select and scale variables for modeling
# Columns 2, 3, 5, 7, 9 — proportions divided by 100 where applicable
Y = mydata[, c(2, 3, 5, 7, 9)]
Y[, c(1, 3, 4)] = Y[, c(1, 3, 4)] / 100

# Overview
par(mfrow = c(1, 1))
ts.plot(Y, col = c("salmon", "cyan", "seagreen", "gold", "sienna"))
print(cor(Y))
str(Y)
head(Y)

# Save Y for use in downstream scripts
saveRDS(Y, file = "data/Y_clean.rds")
