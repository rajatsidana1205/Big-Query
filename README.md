# Automated RFM Donor Segmentation (BigQuery + Power BI)

A donor segmentation pipeline that answers a simple question for a nonprofit fundraising team: **which donors are still engaged, and which are quietly slipping away?**

The segmentation logic is written once in SQL, scheduled to refresh on its own in BigQuery, and surfaced on a live dashboard, so nobody has to re-run a report to keep the picture current.

```
donor transactions  ->  BigQuery RFM query  ->  rfm_segments table  ->  Power BI / Looker Studio
   (donor_data)         (scheduled refresh)      (rebuilt each run)       (auto-refreshing dashboard)
```

## What RFM measures

| Letter | Question | Measured as |
|---|---|---|
| **R**ecency | When did they last give? | Days since last donation |
| **F**requency | How often do they give? | Number of donations |
| **M**onetary | How much have they given? | Total amount donated |

Each donor gets a 1-5 score on each dimension (5 = best, via `NTILE(5)`), and the combination maps to a segment:

| Segment | Rule | Meaning |
|---|---|---|
| Loyal | R >= 4 and F >= 4 | Recent and frequent: strongest supporters |
| New | R >= 4 and 1-2 gifts | Recently started giving |
| Active | R >= 3 | Still giving, not yet loyal |
| At-Risk | R = 2 and F >= 3 | Used to give regularly, gone quiet |
| Lapsed | Everything else | Long gap since last gift |

Rules are evaluated top to bottom, so a donor lands in the first segment that matches.

## Repository layout

```
sql/
  01_rfm_segmentation.sql    # the RFM query (run ad hoc to explore)
  02_scheduled_refresh.sql   # same logic wrapped in CREATE OR REPLACE TABLE for scheduling
data/
  generate_sample_donors.py  # builds a synthetic dataset (no real donor data)
  sample_donors.csv          # 3,000 synthetic donors, ~18.6k donations
```

## Run it yourself

1. In the BigQuery console, create a dataset called `donor_data`.
2. Upload `data/sample_donors.csv` as a table named `donor_data` (schema auto-detect works: `donor_id`, `donation_date`, `donation_amount`).
3. Run `sql/01_rfm_segmentation.sql` to see segments for every donor.
4. Open `sql/02_scheduled_refresh.sql`, run it once, then click **Schedule** and set a daily frequency.
5. Connect Power BI (Get Data -> Google BigQuery) or Looker Studio to `donor_data.rfm_segments`.

The free BigQuery sandbox is enough for this dataset.

### Why the scheduled version uses `CREATE OR REPLACE TABLE`

BigQuery's scheduler rejects a bare `SELECT` unless a destination table is configured. Wrapping the query in `CREATE OR REPLACE TABLE` makes the statement write its own output, so the schedule needs no extra settings. Recency is calculated from `CURRENT_DATE()`, so segments stay current on every run rather than being frozen to a fixed date.

## Example output (synthetic data)

Running the query against the sample dataset produces:

| Segment | Donors | Share | Avg days since last gift | Avg gifts | Avg total given |
|---|---|---|---|---|---|
| Active | 782 | 26.1% | 85 | 5.8 | $510 |
| Lapsed | 691 | 23.0% | 854 | 2.6 | $148 |
| Loyal | 624 | 20.8% | 35 | 13.0 | $1,804 |
| At-Risk | 509 | 17.0% | 411 | 7.2 | $643 |
| New | 394 | 13.1% | 35 | 1.5 | $90 |

These figures come from generated data and only illustrate the shape of the output.

## Notes and limitations

- **Quintile scoring and ties.** Many donors share the same frequency or total, so `NTILE` splits tied values across scores. A `donor_id` tie-breaker keeps results repeatable, but the cut-offs are relative to the donor base rather than fixed thresholds. Switching to fixed day and gift-count thresholds is a reasonable alternative if stakeholders prefer rules they can state in a sentence.
- **Segment rules are a starting point.** Thresholds should be tuned with the fundraising team against how they actually run campaigns.
- **Snapshot only.** Each run overwrites the table. Appending a dated snapshot would allow tracking donors moving between segments over time.

## Possible next steps

- Alerts when a donor moves into At-Risk
- Historical snapshots to measure the impact of retention campaigns
- Feeding segments into a CRM

## Tech

BigQuery Standard SQL, Power BI / Looker Studio, Python (sample data generator only)
