import streamlit as st
import pandas as pd

df = pd.read_csv(r'C:\Users\rahul\OneDrive\SQL\Flight Dashboard using Python and sql\flights_cleaned - flights_cleaned.csv')

# Sidebar
st.sidebar.title('Flight Analytics')

# Main
st.title('Flight Dashboard')
st.subheader('Flight Data Table')

# Show dataframe
st.dataframe(df)
