import mysql.connector
import streamlit as st
import pandas as pd
 
import mysql.connector

class DB:
    def __init__(self):
        try:
            self.conn = mysql.connector.connect(
                host='localhost',
                user='root',
                password='1234',
                database='flights_db'
            )
            self.mycursor = self.conn.cursor()
            print('Connection established')
        except:
            print("Connection error")
            self.conn = None
            self.mycursor = None
    
    def fetch_city_names(self):
        if not self.conn:
            return []
        
        self.mycursor.execute("""
            SELECT DISTINCT(Destination) FROM flights
            UNION
            SELECT DISTINCT(Source) FROM flights
        """)
        data = self.mycursor.fetchall()
        city_names = [row[0] for row in data]
        return city_names