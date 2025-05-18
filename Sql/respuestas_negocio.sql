
-- 1. Listar los usuarios que cumplan años el día de hoy cuya cantidad de ventas
-- realizadas en enero 2020 sea superior a 1500.

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    COUNT(oi.order_item_id) AS total_sales
FROM customer c
JOIN item i ON i.seller_id = c.customer_id
JOIN order_item oi ON oi.item_id = i.item_id
JOIN orders o ON o.order_id = oi.order_id
WHERE 
    EXTRACT(MONTH FROM c.birth_date) = EXTRACT(MONTH FROM CURRENT_DATE)
    AND EXTRACT(DAY FROM c.birth_date) = EXTRACT(DAY FROM CURRENT_DATE)
    AND o.order_date BETWEEN '2020-01-01' AND '2020-01-31'
GROUP BY c.customer_id, c.first_name, c.last_name, c.email
HAVING COUNT(oi.order_item_id) > 1500;


-- 2. Por cada mes del 2020, se solicita el top 5 de usuarios que más vendieron($) en la
-- categoría Celulares. Se requiere el mes y año de análisis, nombre y apellido del
-- vendedor, cantidad de ventas realizadas, cantidad de productos vendidos y el monto
-- total transaccionado.

WITH ventas_celulares AS (
    SELECT
        DATE_TRUNC('month', o.order_date) AS mes,
        c.customer_id,
        c.first_name,
        c.last_name,
        COUNT(DISTINCT o.order_id) AS cantidad_ventas,
        SUM(oi.quantity) AS productos_vendidos,
        SUM(oi.total_amount) AS monto_total
    FROM order_item oi
    JOIN item i ON i.item_id = oi.item_id
    JOIN category cat ON i.category_id = cat.category_id
    JOIN orders o ON o.order_id = oi.order_id
    JOIN customer c ON i.seller_id = c.customer_id
    WHERE 
        o.order_date BETWEEN '2020-01-01' AND '2020-12-31'
        AND LOWER(cat.name) LIKE '%celulares%'
    GROUP BY DATE_TRUNC('month', o.order_date), c.customer_id, c.first_name, c.last_name
),

top_5_por_mes AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY mes ORDER BY monto_total DESC) AS ranking
    FROM ventas_celulares
)

SELECT 
    TO_CHAR(mes, 'YYYY-MM') AS mes_analisis,
    first_name,
    last_name,
    cantidad_ventas,
    productos_vendidos,
    monto_total
FROM top_5_por_mes
WHERE ranking <= 5
ORDER BY mes_analisis, ranking;


-- 3. Se solicita poblar una nueva tabla con el precio y estado de los Ítems a fin del día.
-- Tener en cuenta que debe ser reprocesable. Vale resaltar que en la tabla Item,
-- vamos a tener únicamente el último estado informado por la PK definida. (Se puede
-- resolver a través de StoredProcedure)


-- Creamos la tabla si no existe
-- Esta tabla va a guardar, para cada día, el precio y estado de cada ítem
-- La clave primaria (snapshot_date, item_id) asegura que no se dupliquen registros por día

CREATE TABLE item_daily_snapshot (
    snapshot_date DATE NOT NULL,
    item_id INT NOT NULL REFERENCES item(item_id),
    price DECIMAL(10,2),
    status VARCHAR(20),
    PRIMARY KEY (snapshot_date, item_id)
);


-- Insertamos los datos del snapshot del día actual
-- Usamos CURRENT_DATE para tomar la fecha de hoy
-- ON CONFLICT permite que si ya existe el registro para ese item en ese día,
-- simplemente se actualice, evitando duplicados
-- Esto se podria pensar como un ETL, un cronjob que se podria automatizar.

CREATE OR REPLACE FUNCTION snapshot_items_estado()
RETURNS void AS $$
BEGIN
    INSERT INTO item_daily_snapshot (snapshot_date, item_id, price, status)
    SELECT CURRENT_DATE, item_id, price, status
    FROM item
    ON CONFLICT (snapshot_date, item_id) DO UPDATE
    SET price = EXCLUDED.price,
        status = EXCLUDED.status;
END;
$$ LANGUAGE plpgsql;

SELECT snapshot_items_estado();
