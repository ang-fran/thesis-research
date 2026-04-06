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

# ---- Plot 1: All variables over time ----
p1 = mydata %>%
  pivot_longer(-date) %>%
  ggplot(aes(date, value)) +
  geom_line() +
  facet_wrap(~name, scales = "free") +
  theme_minimal() +
  labs(
    title    = "Macroeconomic Variables Over Time",
    subtitle = "Quarterly data — raw series before transformation",
    x        = "Date",
    y        = "Value"
  )

ggsave(
  filename = "figures/01_all_variables_raw.png",
  plot     = p1,
  width    = 12,
  height   = 8,
  dpi      = 150
)

# ---- Select and scale variables for modeling ----
# Columns 2, 3, 5, 7, 9 selected for analysis
# Columns 1, 3, 4 of Y are proportions — divided by 100 to express as decimals
Y = mydata[, c(2, 3, 5, 7, 9)]
Y[, c(1, 3, 4)] = Y[, c(1, 3, 4)] / 100

print(cor(Y))
str(Y)
head(Y)

# ---- Plot 2: Modelling variables overlaid ----
png("figures/modeling_variables_overlay.png", width = 1000, height = 600)

ts.plot(Y,
        col  = c("salmon", "cyan", "seagreen", "gold", "sienna"),
        main = "Selected Modeling Variables",
        ylab = "Value",
        xlab = "Time (quarters)")

legend("topright",
       legend = colnames(Y),
       col    = c("salmon", "cyan", "seagreen", "gold", "sienna"),
       lty    = 1,
       cex    = 0.8)

dev.off()

# ---- Save Y for downstream scripts ----
saveRDS(Y, file = "data/Y_clean.rds")
