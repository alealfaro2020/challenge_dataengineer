import requests
import csv
import os
import time
import json
from dotenv import load_dotenv
from pathlib import Path

load_dotenv()

QUERIES = ['google home', 'apple tv', 'amazon fire tv']
BASE_DIR = Path(__file__).resolve().parent
TOKEN_FILE = BASE_DIR / 'tokens.json'

def cargar_access_token():
    if TOKEN_FILE.exists():
        with open(TOKEN_FILE, 'r') as f:
            tokens = json.load(f)
            return tokens.get('access_token')
    else:
        raise FileNotFoundError(f"No se encontró el archivo de tokens en: {TOKEN_FILE}")


def buscar_items(query, limit=50, offset=0, headers=None):
    url = f'https://api.mercadolibre.com/sites/MLA/search?q={query}&limit={limit}&offset={offset}'
    print("Headers enviados:", headers)
    response = requests.get(url, headers=headers)
    response.raise_for_status()
    return response.json()


def obtener_item(item_id, headers=None):
    url = f'https://api.mercadolibre.com/items/{item_id}'
    response = requests.get(url, headers=headers)
    response.raise_for_status()
    return response.json()

def main():
    resultados = []

    access_token = cargar_access_token()
    HEADERS = {'Authorization': f'Bearer {access_token}'}

    for query in QUERIES:
        print(f'Buscando productos para: {query}')
        try:
            data = buscar_items(query, headers=HEADERS)
            items = data.get('results', [])
        except Exception as e:
            print(f'Error buscando productos para "{query}": {e}')
            continue
        
        for item in items:
            item_id = item['id']
            try:
                detalle = obtener_item(item_id, headers=HEADERS)
                resultados.append({
                    'query': query,
                    'id': detalle.get('id'),
                    'title': detalle.get('title'),
                    'price': detalle.get('price'),
                    'condition': detalle.get('condition'),
                    'permalink': detalle.get('permalink'),
                    'category_id': detalle.get('category_id'),
                    'seller_id': detalle.get('seller_id'),
                    'currency_id': detalle.get('currency_id'),
                    'available_quantity': detalle.get('available_quantity'),
                    'sold_quantity': detalle.get('sold_quantity'),
                    'listing_type_id': detalle.get('listing_type_id')
                })
                time.sleep(0.1)
            except Exception as e:
                print(f'Error en item {item_id}: {e}')

    if resultados:
        with open('productos.csv', 'w', newline='', encoding='utf-8') as f:
            writer = csv.DictWriter(f, fieldnames=resultados[0].keys())
            writer.writeheader()
            writer.writerows(resultados)
        print("\n Archivo 'productos.csv' generado con éxito.")
    else:
        print("No se encontraron resultados para exportar.")

if __name__ == '__main__':
    main()
