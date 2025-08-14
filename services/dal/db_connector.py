import mysql.connector
import os
from dotenv import load_dotenv


class DBConnector:
    load_dotenv()

    def __init__(self):

        host = os.getenv("MYSQL_URL")
        user = os.getenv("MYSQL_USER")
        password = os.getenv("MYSQL_PASSWORD")
        database = os.getenv("MYSQL_DATABASE")


        self.conn = mysql.connector.connect(
            host=host,
            user=user,
            password=password,
            database=database
        )

    def get_conection(self):
        return self.conn

    def close_conection(self):
        self.conn.close()
