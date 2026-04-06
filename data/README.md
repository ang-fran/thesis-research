# Data

Raw data is not included in this repository.

## Source

Quarterly Canadian macroeconomic data spanning [e.g., Q1 1995 – Q4 2024].
Data was collected from the following sources:

| Variable | Source | Notes |
|----------|--------|-------|
| `real.gdp` | [FRED (Federal Reserve Economic Data)](https://fred.stlouisfed.org) | Used directly |
| `cpi` | [FRED (Federal Reserve Economic Data)](https://fred.stlouisfed.org) | Used directly |
| `gdp.growth` | Calculated | Derived from `real.gdp` |
| `inflation.rate` | Calculated | Derived from `cpi` |
| `mtg.del.rate` | [Canadian Bankers Association (CBA)](https://cba.ca) | Originally monthly; converted to quarterly |
| `unemployment.rate` | [Statistics Canada](https://www.statcan.gc.ca) | |
| `household.income` | [Statistics Canada](https://www.statcan.gc.ca) | Removed due to multicollinearity |
| `debt.service.ratio` | [Statistics Canada](https://www.statcan.gc.ca) | |

## Variables Used in Analysis

| Column | Description | Units |
|--------|-------------|-------|
| `unemployment.rate` | Canadian unemployment rate | % |
| `mtg.del.rate` | Residential mortgage delinquency rate | % |
| `gdp.growth` | Quarter-over-quarter GDP growth rate | % |
| `inflation.rate` | Inflation rate derived from CPI | % |
| `debt.service.ratio` | Household debt service ratio | % |

> `household.income` (Statistics Canada, in units of x1,000 CAD) was collected
> but excluded from final models due to multicollinearity with other regressors.

## Preprocessing Notes

- Mortgage delinquency rate (`mtg.del.rate`) was originally available at monthly
  frequency and was converted to quarterly to match all other variables
- `gdp.growth` and `inflation.rate` were calculated from `real.gdp` and `cpi` respectively
- Rows with missing values were removed via `na.omit()`
- `mtg.del.rate` exhibited a quarterly seasonal pattern in residual ACF diagnostics and was
  seasonally differenced (lag 4) prior to cointegration analysis; observations
  begin at t = 5 after differencing

## Time Period

[e.g., Q1 1995 – Q4 2024]
