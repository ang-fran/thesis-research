# Thesis Research: Macroeconomic Influences on Mortgage Delinquency in Canada

Exploring regime-switching time series models to analyze how macroeconomic 
conditions affect mortgage delinquency rates in Canada.

---

## Research Question

Do macroeconomic variables (e.g., GDP, inflation, unemployment, debt-servicing 
ratios) influence Canadian mortgage delinquency rates differently across 
economic regimes?

---

## Methods

- **VAR** — baseline vector autoregressive model for joint dynamics
- **VECM** — cointegration analysis via Johansen trace test; handles non-stationarity
- **MSMAH-VAR** — Markov-Switching Mean-Adjusted VAR for regime-dependent estimation,
  implemented via the [MSMAHVAR](https://github.com/ang-fran/MSMAHVAR) package

---

## Data

Quarterly macroeconomic data for Canada. Variables include mortgage delinquency 
rates, interest rates, unemployment, and household debt-servicing ratios.  
See [`data/README.md`](data/README.md) for variable descriptions and how to obtain the data.

---

## Repository Structure

| File | Description |
|------|-------------|
| `R/data_prep.R` | Loading, cleaning, and visualizing raw data |
| `R/var_vecm.R` | VAR and VECM estimation, diagnostics, forecasting |
| `R/msvar.R` | Regime-switching estimation using MSMAHVAR package |
| `outputs/figures/` | All generated plots |

---

## Key Findings

*(To be updated as research progresses)*

---

## Dependencies
```r
install.packages(c("tidyverse", "zoo", "forecast", "vars", 
                   "urca", "tseries", "corrplot"))
devtools::install_github("ang-fran/MSMAHVAR")
```
