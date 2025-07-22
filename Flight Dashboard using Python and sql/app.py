import streamlit as st
import pandas as pd
from dataset import DB
import plotly.express as px
import plotly.graph_objects as go



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
        Source = st.selectbox('Source', sorted(city))
    with col2:
        Destination = st.selectbox('Destination',sorted(city))
        
    if st.button('Search'):
        results = db.fetch_all_flights(Source, Destination)
        st.dataframe(results)



elif user_option == "Analytics":
    Airline, frequency = db.fetch_airline_frequency()
    fig = go.Figure(
        go.Pie(
            labels = Airline,
            values = frequency,
            hoverinfo = "label+percent",
            textinfo= "value"
        )
    )
    st.header("Pie Chart")
    st.plotly_chart(fig)
    
    
    st.header("Bar Chart")
    
    City, frequency1 = db.busy_airport()
    fig = px.bar(
            x = City,
            y=frequency1,
            title= "Bar plot of most busiest Airport"
        )
    
    st.plotly_chart(fig, theme='streamlit', use_container_width=True)
    
    st.header("Line Chart")
    
    Date, frequency2 = db.daily_frequency()
    fig = px.line(
            x = Date,
            y=frequency2,
            title= "Line plot of most busiest Airport"
        )
    
    st.plotly_chart(fig, theme='streamlit', use_container_width=True)
    
else:
    st.title('Tell about the project')
    
    
    
