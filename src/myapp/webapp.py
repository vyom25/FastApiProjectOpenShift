from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def home():
    return {"message": "Hello, World!"}


@app.get("/health")
def health():
    return {"status": "OK"}

@app.get("/version")
def version():
    return {"version": "1.0.0"}

    