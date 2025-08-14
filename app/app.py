from fastapi import FastAPI
from services.dal.data_loader import DataLoader

app = FastAPI()

@app.get("/get_data")
def get_data():
    return DataLoader.load_data()