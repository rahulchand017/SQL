import streamlit as st
import pandas as pd
from dataset import DB

# Page setup
st.set_page_config(page_title="Flight Dashboard", layout="wide")

# Title
st.title("Flight Dashboard")
st.sidebar.title("Flight Analysis")


# Load data
try:
    df = pd.read_excel("flights_data.xlsx")  # Your Excel file
except:
    try:
        df = pd.read_csv("flights_data.csv")  # Try CSV if Excel fails
    except:
        st.error("Data file not found")
        st.stop()

# Show data
st.dataframe(df, use_container_width=True)
db = DB()

user_option = st.sidebar.selectbox('Menu',['Select One','Check Flights','Analytics'])
if user_option == 'Check Flights':
    st.title("Check Flights")
    
    col1, col2 = st.columns(2)
    city = db.fetch_city_names()
    
    with col1:
        st.selectbox('Source', sorted(city))
    with col2:
        st.selectbox('Destination',sorted(city))
    if st.button('Search'):
        pass
elif user_option == "Analytics":
    st.title("Analytics")
else:
    st.title('Tell about the project')
    
    
    
