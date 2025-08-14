import mysql.connector
import os
from dotenv import load_dotenv


class DBConnector:
    load_dotenv()

    def __init__(self):

        host = os.getenv("MYSQL_HOST")
        user = os.getenv("MYSQL_USER")
        port_str = os.getenv("MYSQL_PORT")
        password = os.getenv("MYSQL_PASSWORD")
        database = os.getenv("MYSQL_DB")

        try:
            port = int(port_str)
        except (ValueError, TypeError):
            raise ValueError(f"Invalid port: {port_str}. Make sure MYSQL_PORT is a valid number in your .env file.")

        self.conn = mysql.connector.connect(
            host=host,
            user=user,
            port=port,
            password=password,
            database=database
        )

    def get_conection(self):
        return self.conn

    def close_conection(self):
        self.conn.close()
