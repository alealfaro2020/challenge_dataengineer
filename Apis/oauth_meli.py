import os
import json
import requests
from flask import Flask, request
from dotenv import load_dotenv

load_dotenv()

CLIENT_ID = os.getenv('CLIENT_ID')
CLIENT_SECRET = os.getenv('CLIENT_SECRET')
REDIRECT_URI = os.getenv('REDIRECT_URI')
TOKEN_FILE = 'tokens.json'

app = Flask(__name__)

def guardar_tokens(tokens):
    with open(TOKEN_FILE, 'w') as f:
        json.dump(tokens, f)

def cargar_tokens():
    if os.path.exists(TOKEN_FILE):
        with open(TOKEN_FILE) as f:
            return json.load(f)
    return None

def intercambiar_code_por_token(code):
    url = "https://api.mercadolibre.com/oauth/token"
    data = {
        "grant_type": "authorization_code",
        "client_id": CLIENT_ID,
        "client_secret": CLIENT_SECRET,
        "code": code,
        "redirect_uri": REDIRECT_URI
    }
    r = requests.post(url, data=data)
    r.raise_for_status()
    tokens = r.json()
    guardar_tokens(tokens)
    return tokens

def refrescar_token(refresh_token):
    url = "https://api.mercadolibre.com/oauth/token"
    data = {
        "grant_type": "refresh_token",
        "client_id": CLIENT_ID,
        "client_secret": CLIENT_SECRET,
        "refresh_token": refresh_token
    }
    r = requests.post(url, data=data)
    r.raise_for_status()
    tokens = r.json()
    guardar_tokens(tokens)
    return tokens

@app.route('/')
def home():
    url = (f"https://auth.mercadolibre.com.ar/authorization?response_type=code"
           f"&client_id={CLIENT_ID}&redirect_uri={REDIRECT_URI}")
    return f'<a href="{url}">Iniciar sesión con Mercado Libre</a>'

@app.route('/callback')
def callback():
    code = request.args.get('code')
    if not code:
        return "No se recibió el code", 400

    tokens = intercambiar_code_por_token(code)
    return ("Token obtenido y guardado correctamente. Cerrá esta pestaña.")

if __name__ == '__main__':
    app.run(port=5000)
