from fastapi import FastAPI, HTTPException
from fastapi.responses import RedirectResponse
from pydantic import BaseModel
import hashlib
import os

app = FastAPI(title="Mini URL Shortener")

urls = {}

class UrlIn(BaseModel):
    url: str

@app.get("/")
def root():
    return {
        "service": "mini-url-shortener",
        "version": os.getenv("APP_VERSION", "dev"),
        "stored": len(urls),
    }

@app.get("/health")
def health():
    return {"status": "ok"}

@app.post("/shorten")
def shorten(payload: UrlIn):
    code = hashlib.sha1(payload.url.encode()).hexdigest()[:6]
    urls[code] = payload.url
    return {"code": code, "short": f"/r/{code}"}

@app.get("/r/{code}")
def redirect(code: str):
    if code not in urls:
        raise HTTPException(404, "Not found")
    return RedirectResponse(urls[code])
