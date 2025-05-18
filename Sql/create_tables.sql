CREATE TABLE customer (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    gender VARCHAR(10),
    birth_date DATE,
    address TEXT,
    phone_number VARCHAR(20),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE category (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    path TEXT
);

CREATE TABLE item (
    item_id SERIAL PRIMARY KEY,
    title VARCHAR(255),
    price DECIMAL(10, 2),
    status VARCHAR(20) CHECK (status IN ('activo', 'inactivo', 'vendido', 'pausado')),
    deactivation_date DATE,
    seller_id INT REFERENCES customer(customer_id),
    category_id INT REFERENCES category(category_id),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE "order" (
    order_id SERIAL PRIMARY KEY,
    buyer_id INT REFERENCES customer(customer_id),
    order_date DATE,
    quantity INT,
    total_amount DECIMAL(10, 2)
);

CREATE TABLE order_item (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES "order"(order_id),
    item_id INT REFERENCES item(item_id),
    quantity INT,
    unit_price DECIMAL(10, 2),
    total_amount DECIMAL(10, 2)
);

