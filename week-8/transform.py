import pandas as pd

def clean_data(df):
  try:
    df_clean = df.copy()
    df_clean = df_clean.drop_duplicates()
    df_clean = df_clean.dropna(
      subset=['customer_id', 'sale_date', 'total_price']
    )
    df_clean['sale_date'] = pd.to_datetime(df_clean['sale_date'])
    return df_clean
  except Exception as e:
    print(f"Error cleaning data: {e}")
    raise

def calculate_weekly_aggregates(df):
  try:
    weekly = (
      df
      .resample('W', on='sale_date')
      .agg(
        revenue=('total_price', 'sum'),
        orders=('sale_id', 'count'),
        avg_order_value=('total_price', 'mean')
      )
      .reset_index()
    )
    weekly = weekly.rename(columns={"sale_date": "week"})
    return weekly
  except Exception as e:
    print(f"Error calculating weekly aggregates: {e}")
    raise

def calculate_kpis(df):
  try:
    kpis = {
        'total_revenue': df['total_price'].sum(),
        'unique_customers': df['customer_id'].nunique(),
        'avg_order_value': df['total_price'].mean()
    }
    return kpis
  except Exception as e:
      print(f"Error calculating kpis: {e}")
      raise

def merge_datasets(df_sales, df_customers):
   try:
    merged = pd.merge(
        df_sales,
        df_customers,
        on='customer_id',
        how='left'
    )
    return merged
   except Exception as e:
       print(f"Error merging databases: {e}")
       raise