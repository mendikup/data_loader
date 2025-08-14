from services.dal.db_connector import DBConnector
class DataLoader:

    def __init__(self):
        self.connector = DBConnector()



    def load_data(self):
        conn = self.connector.get_conection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM ffffffffffffffffffffffff")
        rows = cursor.fetchall()
        self.connector.close_conection()
        return rows


