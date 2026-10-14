# Week 8 — Team Pipeline Demo

## Team roles

| Role | Team member | Responsibility |
|---|---|---|
| Role A — API Query | Reio | Fetch sales, customers and products from the Supabase API into pandas DataFrames. |
| Role B — Data Processing | Maria | Clean and merge the data, then calculate weekly aggregates and KPIs. |
| Role C — Visualization + Saving | Marvis | Create Plotly visualizations and export results to CSV and HTML files. |
| Role D — Automation | Daria | Connect all modules into one automated pipeline with logging and one-command execution. |

## Pipeline

```text
Supabase API
    ↓
Data Fetching
    ↓
Cleaning & Transformation
    ↓
Validation
    ↓
Visualization
    ↓
CSV / HTML Export
```

The full workflow can be run with one command, depending on the local Python installation:

**Windows:**

```bash
python pipeline.py
```

**macOS / Linux:**

```bash
python3 pipeline.py
```

In some environments, `python` may also work on macOS/Linux.

## Demo result

The pipeline runs end-to-end and:

- fetches data from Supabase through the API
- cleans and transforms the data
- calculates weekly aggregates and KPIs
- validates the transformed results
- creates Plotly outputs
- exports CSV and HTML files
- logs the progress of each stage

In Daria's test run, the pipeline completed in approximately **0.70 seconds**.

## Synthesis questions

### 1. How much time does the pipeline save compared to manual processing?

The scenario describes a manual weekly workflow that takes around four hours.

Our automated pipeline completes the technical workflow in approximately **0.70 seconds**, excluding human review.

### 2. What should Marko automate next?

A logical next step would be to schedule the pipeline to run automatically every week and send KPI summaries or alerts when important metrics move outside expected ranges.

### 3. What happens if Supabase is unavailable?

The current pipeline reports the API failure and stops instead of silently producing incomplete results.

A future production improvement would be to add retry logic and a fallback to the latest validated local dataset.

## Main takeaway

The main value of the pipeline is not only speed, but repeatability: the same workflow can be rerun whenever the underlying data changes without repeating the full process manually.

## Demo flow

1. Run `python pipeline.py` on Windows or `python3 pipeline.py` on macOS/Linux.
2. Show the log output and confirm that the pipeline completed successfully.
3. Show the generated CSV and HTML files in the `output/` folder.
4. Briefly explain the time saved and one possible next automation step.
