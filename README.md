# Challenge Data Engineer 

# Parte 1 - Marketplace

Este repositorio contiene la estructura de base de datos y consultas SQL para un sistema de marketplace simplificado, incluyendo ventas de ítems, clientes, órdenes y categorías.

---

## 📌 Estructura de la Base de Datos

La base de datos está compuesta por las siguientes tablas:

- `customer`: Información de los usuarios (compradores y vendedores).
- `category`: Categorías jerárquicas de los productos.
- `item`: Productos publicados por los vendedores.
- `orders`: Órdenes de compra realizadas por los clientes.
- `order_item`: Detalle de cada producto dentro de una orden.
- `item_daily_snapshot`: Tabla de snapshots diarios de estado y precio de cada ítem (pensado para reprocesos/ETL).


---

## 📁 Archivos Principales

### `create_tables.sql`

Contiene todas las instrucciones necesarias para crear la base de datos en PostgreSQL. Incluye relaciones foráneas, claves primarias y restricciones.

### `respuestas_negocio.sql`

Contiene consultas SQL que responden a necesidades de negocio como:

1. **Clientes que cumplen años hoy y hayan vendido más de 1500 productos en enero 2020.**
2. **Top 5 vendedores mensuales en 2020 para la categoría "Celulares", con detalle de ventas y monto transaccionado.**
3. **Creación y ejecución de una función (`snapshot_items_estado`) para registrar el estado y precio diario de los ítems.**

---

## 🧰 Tecnologías

- PostgreSQL
- SQL (estándar con extensiones PL/pgSQL)
- Visualización del modelo: [dbdiagram.io](https://dbdiagram.io)


# Parte 2 - Apis

1. Prerrequisitos
Tener una cuenta creada en Mercado Libre Developers (Development)

Obtener Client ID y Client Secret desde tu aplicación en el dashboard de ML 

Instalar Python 3.8+ y dependencias del proyecto (Flask, requests,pandas)

2. Flujo de autenticación (OAuth2)

- Redirigir al usuario a:

https://auth.mercadolibre.com.ar/authorization?response_type=code
&client_id=<TU_CLIENT_ID>&redirect_uri=<TU_REDIRECT_URI>

- Capturar el parámetro code al volver a tu servidor Flask.

- Intercambiar code por access_token vía POST

- Almacenar access_token para futuras llamadas

3. Mercado Libre requiere que las redirect_uri usen HTTPS, por lo que no es posible apuntar directamente a http://localhost:5000 
  Para sortear esto, utilizamos ngrok, que proporciona una URL pública y segura (HTTPS) hacia tu servidor local

4. Endpoints intentados

GET /sites/MLA/search 403 Forbidden

GET /items/{Item_Id} 403 Forbidden


No se pudo acceder a los endpoints por un cambio en la politica de MELI, ya no son publicos estos endpoints y estan deprecados
Basta con probar lo siguiente: curl "https://api.mercadolibre.com/sites/MLA/search?q=google%20home"

Devuelve el siguiente error: 

{"code":"unauthorized","message":"authorization value not present"}
