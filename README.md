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

Puedes visualizar el DER en [dbdiagram.io](https://dbdiagram.io) usando el archivo `der.dbml`.

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

