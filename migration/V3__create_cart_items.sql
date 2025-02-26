CREATE TABLE IF NOT EXISTS cart_items (
    id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    quantity INT NOT NULL
);

INSERT INTO cart_items (product_name, quantity) VALUES
('來兩客', 2),
('小羊大冰淇淋', 1),
('運動毛巾', 3);
