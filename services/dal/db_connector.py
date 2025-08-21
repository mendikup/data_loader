import mysql.connector
import os


class DBConnector:
    """
    Class that responsible for the connection to the db
    """

    def __init__(self):
        host = os.getenv("MYSQL_HOST", "localhost")
        user = os.getenv("MYSQL_USER", "root")
        password = os.getenv("MYSQL_PASSWORD", "rootpass123")
        database = os.getenv("MYSQL_DATABASE", "mydb")

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
