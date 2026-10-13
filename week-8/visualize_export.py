import plotly.express as px
import plotly.graph_objects as go
import os
from datetime import datetime

def create_weekly_chart(df_weekly):
  fig = px.line(df_weekly, x='week', y='revenue', title="Weekly Revenue")
  return fig

def create_kpi_summary(kpis):
  fig = go.Figure(
    data=[go.Table(
    header=dict(values=['KPI', "Value"]), 
    cells=dict(values=[list(kpis.keys()), list(kpis.values())])
    )]
  )
  return fig

def export_results(df, output_dir):
  os.makedirs(output_dir, exist_ok=True)
  date_str = datetime.now().strftime("%Y%m%d")
  file_path = os.path.join(
    output_dir,
    f"results_{date_str}.csv"
  )
  df.to_csv(file_path, index=False)
  return file_path