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
    
    
    def fetch_all_flights(self, Source, Destination):
        self.mycursor.execute("""
                SELECT Airline,Route, Dep_Time, Duration, Price FROM flights
    WHERE `Source` = '{}' AND `Destination`='{}'
                            """.format(Source, Destination))
        
        data = self.mycursor.fetchall()
        return pd.DataFrame(data, columns=["Airline", "Route", "Dep_Time", "Duration", "Price"])
    
    
    def fetch_airline_frequency(self):
        Airline = []
        frequency = []
        self.mycursor.execute("""
                    SELECT Airline, COUNT(*) FROM flights
                    GROUP BY `Airline`
                              """)
        
        data = self.mycursor.fetchall()
        for item in data:
            Airline.append(item[0])
            frequency.append(item[1])
        return Airline, frequency
    
    
    def busy_airport(self):
        City = []
        frequency1 = []
        self.mycursor.execute("""
                              SELECT SOURCE, COUNT(*) FROM(SELECT Source FROM flights
                            UNION ALL
                            SELECT `Destination` FROM flights)t
                            GROUP BY t.`Source`
                            ORDER BY COUNT(*) DESC""")
        data = self.mycursor.fetchall()
        for item in data:
            City.append(item[0])
            frequency1.append(item[1])
        return City, frequency1
    
    
    def daily_frequency(self):
        Date = []
        frequency = []
        self.mycursor.execute("""
                              SELECT Date_of_Journey, COUNT(*) FROM flights
                              GROUP BY Date_of_Journey""")
        data = self.mycursor.fetchall()
        for item in data:
            Date.append(item[0])
            frequency.append(item[1])
        return Date, frequency
        
