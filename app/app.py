from fastapi import FastAPI
from services.dal.data_loader import DataLoader

app = FastAPI()
loader = DataLoader()

@app.get("/")
def root():
    return {"ok": True}

@app.get("/health")
def health():
    return {"status": "ok"}

@app.get("/get_data")
def get_data():
    return loader.load_data()
