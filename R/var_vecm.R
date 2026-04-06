# ---- VAR and VECM estimation, diagnostics, and forecasting ----
library(tidyverse)
library(vars)
library(urca)
library(tseries)
library(forecast)
library(zoo)

Y = readRDS("data/Y_clean.rds")
n = ncol(Y)

# ---- Lag selection ----
VARselect(Y, type = "const", lag.max = 10)
# All except AIC suggest lag 1

# ---- VAR ----
var_model = VAR(Y, p = 1, type = "none")
summary(var_model)
roots(var_model)
# Note: one eigenvalue above 1 — non-stationary, so VECM preferred


# ---- Stationarity tests prior to cointegration testing ----
adf_results = list()
for (i in 1:n) {
  adf_results[[i]] = adf.test(Y[, i])
}
adf_results
# Debt servicing ratios: ADF fails to reject H0 → not stationary → use cointegration

# ---- Seasonal differencing of mortgage delinquency rate ----
# ACF of residuals showed quarterly seasonal pattern in mtg.del.rate
# Differenced by lag 4; analysis starts at t = 5
Y2 = diff(Y[, 2], lag = 4)
Y2 = cbind(Y2, Y[5:120, c(1, 3, 4, 5)])
colnames(Y2)[1] = "mtg.del.rate"

# ---- VECM ----
jo = ca.jo(Y2, type = "trace", ecdet = "none", K = 2)
summary(jo)  # rank = 4, thus indicating 4 cointegrating relationships

vecm = cajorls(jo, r = 4)
summary(vecm$rlm)

vec_res = residuals(vecm$rlm)

par(mfrow = c(1, 1))
for (i in 1:n) {
  qqnorm(vec_res[, i], main = colnames(vec_res)[i])
  qqline(vec_res[, i], col = "turquoise")
}

for (i in 1:n) {
  acf(vec_res[, i], main = colnames(vec_res)[i], col = c(1:5))
}

var_rep = vec2var(jo, r = 4)

# ---- Forecasting from VECM ----
h = 50

pred = predict(var_rep, n.ahead = h)

pred_mtg_diff = pred$fcst[[1]][, "fcst"]
pred_var2     = pred$fcst[[2]][, "fcst"]
pred_var3     = pred$fcst[[3]][, "fcst"]
pred_var4     = pred$fcst[[4]][, "fcst"]
pred_var5     = pred$fcst[[5]][, "fcst"]

# Un-difference the seasonal variable using last 4 observed values as seeds
seed_values = Y[117:120, 2]

undiff_mtg = numeric(h)
for (t in 1:h) {
  if (t <= 4) {
    undiff_mtg[t] = pred_mtg_diff[t] + seed_values[t]
  } else {
    undiff_mtg[t] = pred_mtg_diff[t] + undiff_mtg[t - 4]
  }
}

forecast_matrix = cbind(
  mtg.del.rate = undiff_mtg,
  pred_var2,
  pred_var3,
  pred_var4,
  pred_var5
)
colnames(forecast_matrix) = colnames(Y2)

# ---- Forecast plots ----
t_obs  = 1:nrow(Y2)
t_fore = (nrow(Y2) + 1):(nrow(Y2) + h)

png("outputs/figures/vecm_forecasts.png", width = 1400, height = 900)
par(mfrow = c(3, 2))

for (i in 1:ncol(Y2)) {
  plot(t_obs, Y2[, i],
       type = "l", col = "black",
       xlim = c(1, max(t_fore)),
       ylim = range(c(Y2[, i], forecast_matrix[, i])),
       xlab = "Time", ylab = colnames(Y2)[i],
       main = colnames(Y2)[i])
  lines(t_fore, forecast_matrix[, i], col = "red",  lty = 2, lwd = 2)
  lines(t_fore, pred$fcst[[i]][, "lower"], col = "pink", lty = 3)
  lines(t_fore, pred$fcst[[i]][, "upper"], col = "pink", lty = 3)
  legend("topleft",
         legend = c("Observed", "Forecast", "95% CI"),
         col    = c("black", "red", "pink"),
         lty    = c(1, 2, 3), cex = 0.7)
}
dev.off()

par(mfrow = c(1, 1))

# Save objects needed downstream
saveRDS(list(Y2 = Y2, jo = jo, vecm = vecm, var_rep = var_rep,
             vec_res = vec_res, h = h, t_obs = t_obs, t_fore = t_fore),
        file = "data/vecm_objects.rds")