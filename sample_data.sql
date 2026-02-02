use restaurent_db;

-- Insert sample data
INSERT INTO dishes (dish_name, cuisine_type, category, price, spice_level, preparation_time, is_available) VALUES
('Margherita Pizza', 'Italian', 'Main Course', 12.99, 1, 15, TRUE),
('Chicken Tikka Masala', 'Indian', 'Main Course', 15.99, 4, 25, TRUE),
('Caesar Salad', 'American', 'Appetizer', 8.99, 1, 10, TRUE),
('Pad Thai', 'Thai', 'Main Course', 13.99, 3, 20, TRUE),
('Chocolate Lava Cake', 'French', 'Dessert', 7.99, 0, 12, TRUE),
('Tom Yum Soup', 'Thai', 'Appetizer', 6.99, 4, 15, TRUE),
('Beef Burger', 'American', 'Main Course', 11.99, 2, 18, TRUE),
('Tiramisu', 'Italian', 'Dessert', 8.99, 0, 5, FALSE),
('Spring Rolls', 'Chinese', 'Appetizer', 5.99, 1, 12, TRUE),
('Grilled Salmon', 'Mediterranean', 'Main Course', 18.99, 1, 22, TRUE);

INSERT INTO tables (table_number, seating_capacity, location, status) VALUES
(1, 2, 'Window', 'Available'),
(2, 4, 'Window', 'Occupied'),
(3, 2, 'Indoor', 'Available'),
(4, 6, 'Indoor', 'Reserved'),
(5, 4, 'Outdoor', 'Available'),
(6, 8, 'Indoor', 'Occupied'),
(7, 2, 'Window', 'Available'),
(8, 4, 'Outdoor', 'Available');

INSERT INTO orders (table_id, order_date, total_amount, order_status, special_instructions) VALUES
(2, '2024-01-23 12:30:00', 45.97, 'Completed', 'No onions'),
(6, '2024-01-23 13:15:00', 62.95, 'In Progress', 'Extra spicy'),
(2, '2024-01-23 18:45:00', 38.96, 'In Progress', NULL);

INSERT INTO ingredients (ingredient_name, quantity_in_stock, unit, reorder_level, last_restock_date) VALUES
('Tomatoes', 25.5, 'kg', 10.0, '2024-01-20'),
('Chicken Breast', 18.0, 'kg', 15.0, '2024-01-22'),
('Mozzarella Cheese', 12.5, 'kg', 8.0, '2024-01-21'),
('Rice Noodles', 8.0, 'kg', 5.0, '2024-01-19'),
('Salmon Fillet', 10.5, 'kg', 8.0, '2024-01-23'),
('Lettuce', 15.0, 'kg', 5.0, '2024-01-22'),
('Chocolate', 6.0, 'kg', 4.0, '2024-01-18');

-- check inserted data from all tables
select * from dishes;
select * from ingredients;
select * from order_items;
select * from orders;
select * from tables;

-- count rows
select count(*) from dishes;
select count(*) from ingredients;
select count(*) from order_items;
select count(*) from orders;
select count(*) from tables;	
