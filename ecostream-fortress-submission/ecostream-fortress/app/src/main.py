from fastapi import FastAPI

app = FastAPI(title="EcoStream Fortress Hello World")

@app.get("/health")
def health():
    return {"status": "ok"}

@app.get("/")
def root():
    return {"message": "Hello from EcoStream Fortress (EKS-ready)"}
