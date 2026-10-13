import logging
import time
from data_fetcher import fetch_sales, fetch_customers
from transform import (clean_data, calculate_weekly_aggregates, calculate_kpis, merge_datasets)
from visualize_export import (create_weekly_chart, create_kpi_summary, export_results)

logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")

def run_pipeline():
  logging.info('Pipeline started')
  try:
    # Extract
    sales_df = fetch_sales("2024-01-01", "2024-12-31")
    customers_df = fetch_customers()

    logging.info(f'Fetched {len(sales_df)} sales')
    logging.info(f'Fetched {len(customers_df)} customers')
  except Exception as e:
    logging.error(f"Extract stage failed: {e}")
    return

  try:
    # Transform
    sales_clean = clean_data(sales_df)
    merged_df = merge_datasets(sales_clean, customers_df)

    weekly = calculate_weekly_aggregates(sales_clean)
    kpis = calculate_kpis(sales_clean)

    # Validation
    assert len(sales_clean) > 0, 'Clean sales is empty'
    assert len(merged_df) == len(sales_clean), ('Merge changed row count')
    assert weekly['orders'].sum() == len(sales_clean), ('Weekly orders do not reconcile with cleaned sales')
    
    logging.info("Validation passed")
    logging.info(f"Cleaned sales: {len(sales_clean)} rows")
    logging.info(f"Merged dataset: {len(merged_df)} rows")
  except Exception as e:
    logging.error(f"Transform stage failed: {e}")
    return

  try:
    # Visualize
    weekly_fig = create_weekly_chart(weekly)
    kpi_fig = create_kpi_summary(kpis)

    #Export
    file_path = export_results(weekly, 'week-8/output')
    weekly_fig.write_html("week-8/output/weekly_revenue.html")
    kpi_fig.write_html("week-8/output/kpi_summary.html")

    logging.info(f"Results saved to {file_path}")
  
  except Exception as e:
    logging.error(f"Export stage failed: {e}")
    return
  logging.info("Pipeline completed successfully")

if __name__ == "__main__":
    start_time = time.time()

    run_pipeline()

    elapsed = time.time() - start_time

    print(f"\nPipeline finished in {elapsed:.2f} seconds")