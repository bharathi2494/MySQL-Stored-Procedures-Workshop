CREATE DATABASE restaurent_db;
use restaurent_db;

-- Create dishes table
CREATE TABLE dishes (
dish_id INT PRIMARY KEY AUTO_INCREMENT,
dish_name VARCHAR(100),
cuisine_type VARCHAR(50),
category VARCHAR(30),
price DECIMAL(10,2),
spice_level INT,
preparation_time INT,
is_available BOOLEAN DEFAULT TRUE
);

-- Create tables table
CREATE TABLE tables (
table_id INT PRIMARY KEY AUTO_INCREMENT,
table_number INT UNIQUE,
seating_capacity INT,
location VARCHAR(30),
status VARCHAR(20) DEFAULT 'Available'
);

-- Create orders table
CREATE TABLE orders (
order_id INT PRIMARY KEY AUTO_INCREMENT,
table_id INT,
order_date DATETIME,
total_amount DECIMAL(10,2),
order_status VARCHAR(20),
special_instructions TEXT,
FOREIGN KEY (table_id) REFERENCES tables(table_id)
);

CREATE TABLE order_items (
item_id INT PRIMARY KEY AUTO_INCREMENT,
order_id INT,
dish_id INT,
quantity INT,
item_price DECIMAL(10,2),
FOREIGN KEY (order_id) REFERENCES orders(order_id),
FOREIGN KEY (dish_id) REFERENCES dishes(dish_id)
);
-- Create ingredients table
CREATE TABLE ingredients (
ingredient_id INT PRIMARY KEY AUTO_INCREMENT,
ingredient_name VARCHAR(100),
quantity_in_stock DECIMAL(10,2),
unit VARCHAR(20),
reorder_level DECIMAL(10,2),
last_restock_date DATE
);

