# ---- Regime-switching estimation using MSMAHVAR package ----
library(MSMAHVAR)

Y <- readRDS("data/Y_clean.rds")

# ---- Set initial values ----
# TODO: define mu_init, A_init, S_init, P_init before running
# These should be set based on VAR estimates from script 02
# e.g.:
# mu_init    <- ...
# A_init     <- ...
# S_init     <- ...
# P_init     <- ...

# ---- 2-state MSMAH-VAR(2) on full Y ----
fit2 <- msmah_var_em(
  as.matrix(Y),
  p          = 2,
  mu_init    = mu_init,
  A_init     = A_init,
  Sigma_init = S_init,
  P_init     = P_init,
  max_iter   = 2000
)

png("figures/msmahvar_loglik.png", width = 800, height = 500)
plot(fit2$loglik, type = "l", main = "Log-Likelihood Convergence")
dev.off()

print(fit2$A)