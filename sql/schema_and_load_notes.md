# Schema & Load Notes

## How the SQLite table is created

`notebooks/credit_scorecard.ipynb` loads the raw CSV into pandas, renames the
unnamed index column to `ID`, and writes it to a SQLite database at
`data/credit_data.db`:

```python
import pandas as pd
import sqlite3

df = pd.read_csv('../data/cs-training.csv')
df.rename(columns={'Unnamed: 0': 'ID'}, inplace=True)

conn = sqlite3.connect('../data/credit_data.db')
df.to_sql("credit_data", conn, if_exists="replace", index=False)
```

## Resulting table: `credit_data`

| Column | Type | Notes |
|---|---|---|
| ID | INTEGER | customer identifier (from the original CSV row index) |
| SeriousDlqin2yrs | INTEGER | target: 1 = defaulted within 2 years, 0 = did not |
| RevolvingUtilizationOfUnsecuredLines | REAL | total balance on credit cards / credit limits |
| age | INTEGER | age of borrower in years |
| NumberOfTime30-59DaysPastDueNotWorse | INTEGER | count of 30-59 day late payments |
| DebtRatio | REAL | monthly debt payments / monthly gross income |
| MonthlyIncome | REAL (nullable) | monthly income; ~20% missing in raw data |
| NumberOfOpenCreditLinesAndLoans | INTEGER | number of open loans/lines |
| NumberOfTimes90DaysLate | INTEGER | count of 90+ day late payments |
| NumberRealEstateLoansOrLines | INTEGER | number of mortgage/real estate loans |
| NumberOfTime60-89DaysPastDueNotWorse | INTEGER | count of 60-89 day late payments |
| NumberOfDependents | REAL (nullable) | number of dependents; small % missing |

## Why SQLite

- Zero-config, file-based — the whole database is a single portable file
  (`data/credit_data.db`), regenerated fresh each time Stage 1 of the
  notebook runs.
- Lets Stage 2 (EDA) be done with plain SQL (`sql/eda_queries.sql`) instead of
  only pandas, mirroring how EDA is often done against a real database
  before data reaches a modeling notebook.
- The database file is a build artifact, not a source of truth — it's
  excluded from version control (see `.gitignore`) and safe to delete and
  regenerate at any time by re-running the notebook from the top.
