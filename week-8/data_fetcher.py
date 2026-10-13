from supabase import create_client
import os, pandas as pd
from dotenv import load_dotenv
import plotly.express as px
import logging
from datetime import datetime

load_dotenv()

supabase = create_client(
  os.getenv("SUPABASE_URL"), 
  os.getenv("SUPABASE_KEY")
)

# def load_table(table_name):
#   response = supabase.table(table_name).select("*").execute()
#   return pd.DataFrame(response.data)

# orders_df = load_table("sales")
# customers_df = load_table("customers")

# df = pd.merge(
#     orders_df,
#     customers_df,
#     on="customer_id",
#     how="left"
# )

def fetch_sales(start_date, end_date):
  try:
    response = (
      supabase
      .table('sales')
      .select('*')
      .gte('sale_date', start_date)
      .lte('sale_date', end_date)
      .execute()
    )
    return pd.DataFrame(response.data)
  except Exception as e:
    print(f"Error fetching sales: {e}")
    return pd.DataFrame()

def fetch_customers():
  try:
    response = (
      supabase
      .table('customers')
      .select('*')
      .execute()
    )
    return pd.DataFrame(response.data)
  except Exception as e:
    print(f"Error fetching customers: {e}")
    return pd.DataFrame()

def fetch_products():
  try:
    response = (
      supabase
      .table('products')
      .select('*')
      .execute()
    )
    return pd.DataFrame(response.data)
  except Exception as e:
    print(f"Error fetching products: {e}")
    return pd.DataFrame()

if __name__ == "__main__":
    sales_df = fetch_sales("2023-01-01", "2026-12-31")
    customers_df = fetch_customers()
    products_df = fetch_products()

    print("Sales:", len(sales_df))
    print("Customers:", len(customers_df))
    print("Products:", len(products_df))