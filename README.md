# E-Commerce SQL Business Analysis

A SQL business-analysis project built on a realistic, large-scale e-commerce
dataset (15 tables, ~6M rows, ~365 MB). Covers database setup, data-quality /
NULL handling, and 25 business-driven analysis questions ranging from simple
aggregations to cohort retention, RFM segmentation, and churn analysis.

## Repository structure

```
.
├── sql/
│   ├── 01_database_setup.sql     # schema + table creation
│   ├── 02_null_check.sql         # data-quality / NULL auditing queries
│   ├── 03_null_handling.sql      # NULL handling & cleanup logic
│   └── 04_business_analysis.sql  # full solutions to the practice questions
├── docs/
│   └── practice_questions.md     # the 25 business questions (3 difficulty levels)
├── data/
│   ├── DATA_DICTIONARY.md        # table/row counts, PKs, FKs, NULL design rules
│   └── *.csv                     # the 15 source tables (tracked with Git LFS)
└── README.md
```

## Dataset

15 CSVs, ~6.07M rows total. Every optional column carries 5–10% real NULLs;
every required column (keys, dates, statuses, amounts) is 100% populated, and
all foreign keys are valid with no orphans. Full details, table-by-table row
counts, and the relationship map are in [`data/DATA_DICTIONARY.md`](data/DATA_DICTIONARY.md).

## Analysis questions

See [`docs/practice_questions.md`](docs/practice_questions.md) for the full list:

- **Level 1 — Foundations**: top categories, payment method failure rates, average order value, coupon usage, session trends
- **Level 2 — Joins & Aggregation**: top customers by spend, return rates by category, seller ratings, delivery times by carrier, repeat-purchase rate
- **Level 3 — Business-Driven Analysis**: cohort retention, coupon effectiveness, RFM segmentation, churn risk, seller scorecards, funnel drop-off, cross-sell patterns, warehouse efficiency, dead stock, marketing attribution

## Data files & Git LFS

The CSV files are large (up to ~76 MB each), so they're tracked with
[Git LFS](https://git-lfs.com/) rather than committed as plain blobs. Install
Git LFS before cloning:

```bash
git lfs install
git clone <repo-url>
```

If you only want the SQL and docs without pulling the full dataset:

```bash
GIT_LFS_SKIP_SMUDGE=1 git clone <repo-url>
```

## How to use

1. Load the schema: run `sql/01_database_setup.sql` against your database.
2. Import the CSVs in `data/` into the corresponding tables.
3. Run `sql/02_null_check.sql` and `sql/03_null_handling.sql` to audit and handle NULLs.
4. Work through `docs/practice_questions.md`, or review the worked solutions in `sql/04_business_analysis.sql`.
