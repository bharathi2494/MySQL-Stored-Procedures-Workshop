-- Part 2: INSERT Operations 
-- Simple INSERT Procedure
-- scenerio: Add new dish to menu

use restaurent_db;

DROP PROCEDURE AddNewDish;
DELIMITER //
CREATE PROCEDURE AddNewDish(
	IN p_dish_name varchar(50),
    IN p_cuisine_type varchar(30),
    IN p_category VARCHAR (50),
    IN p_price decimal (10,2),
    IN p_spice_level INT,
    IN p_preparation_time INT
    )
BEGIN
	INSERT INTO dishes(dish_name, cuisine_type, category, price, spice_level, preparation_time, is_available)
    VALUES(p_dish_name, p_cuisine_type, p_category, p_price, p_spice_level, p_preparation_time, TRUE);
    
    SELECT
		CONCAT(p_dish_name, ' inserted successfull into the manu') AS Result_Message;
	
END //
DELIMITER ;

CALL AddNewDish('Spaghetti Carbonara', 'Italian', 'Main Course', 14.99, 1, 20);

SELECT * 
FROM dishes 
WHERE dish_name='Spaghetti Carbonara';

-- INSERT WITH VALIDATION
-- scenerion: add dish only if all data is valid

drop procedure AddDishWithValidation;
DELIMITER //
CREATE PROCEDURE AddDishWithValidation(
	IN p_dish_name varchar(50),
    IN p_cuisine_type varchar(30),
    IN p_category VARCHAR (50),
    IN p_price decimal (10,2),
    IN p_spice_level INT,
    IN p_preparation_time INT
    )
BEGIN
	DECLARE dish_exists int;
    DECLARE error_message varchar(100);
    
    	-- check if dishname alreay exists
	SELECT count(*) into dish_exists
	from dishes 
	where dish_name=p_dish_name;
    
    IF p_dish_name > 0 then
		set error_message='ERROR: This dish already exists on the menu';
        SELECT error_message AS Mesasge;
        
	-- validate for price
    ELSEIF p_price < 3.00 then
		set error_message='ERROR: Price must be atleast $3.00';
        SELECT error_message as message;
	
    elseif p_price >100 then
		set error_message='ERROR: price must be less than $100';
        select error_message as message;
	
    -- validate spice level
    elseif p_spice_level <0 or p_spice_level>5 then
		set error_message='Error: spice level must be between 0 and 5';
        select error_message as message;
	
    elseif p_preparation_time <5 or p_preparation_time>120 then
		set error_message='error: preparation time must be between 5 nad 120 min';
        select error_message as message;
        
-- all validations passed insert the dish
	else
		insert into dishes (dish_name, cuisine_type, category, price, spice_level, preparation_time, is_available)
		VALUES(p_dish_name, p_cuisine_type, p_category, p_price, p_spice_level, p_preparation_time, TRUE);
	
    select 'Dish inserted successfully' as message;
    
    END IF;

END //
DELIMITER ;

CALL AddDishWithValidation('Test Dish', 'Test', 'Main Course', 2.00, 2, 15);
CALL AddDishWithValidation('Test Dish', 'Test', 'Main Course', 12.00, 8, 15);
CALL AddDishWithValidation('Fish Tacos', 'Mexican', 'Main Course', 13.99, 2, 18);

select * from dishes where dish_name='Fish Tacos';

-- INSERT and Return Generated ID
-- Scenario: Add an ingredient and get the new ingredient ID.

drop procedure AddIngredientGetID;
DELIMITER //
CREATE PROCEDURE AddIngredientGetID(
	IN p_in_name varchar(100),
    IN p_qty decimal(10,2),
    IN p_unit varchar(20),
    IN p_reorder_level decimal(10,2),
	OUT new_ingredient_ID int
    )    
BEGIN
    
    insert into ingredients (ingredient_name, quantity_in_stock, unit, reorder_level, last_restock_date)
    values(p_in_name, p_qty, p_unit, p_reorder_level, curdate());
    
    -- Get the ID that was just created
    set new_ingredient_ID= last_insert_ID();
    
    select concat('new generated ingredient ID: ', new_ingredient_ID) as message;

END //
DELIMITER ;

call AddIngredientGetID('bell Papers', 20, 'Kg', 5, @new_ID);
select @new_ID as 'New_ingredient_ID';

select * from ingredients;

/* 👨‍💻 HANDS-ON PRACTICE:
Create AddNewTable(IN table_num INT, IN capacity INT, IN location VARCHAR(30)) with validation:
•	Table number must not already exist
•	Capacity must be between 2 and 12
•	Location must be one of: 'Window', 'Indoor', 'Outdoor' */

DROP PROCEDURE AddNewTable;
DELIMITER //
CREATE PROCEDURE AddNewTable(
	in p_table_number int,
    in p_seat_capacity int,
    in p_location varchar(20)
    )
BEGIN
	DECLARE table_no int;
    declare error_message varchar(100);
    
    SELECT count(*) into table_no
    from tables
    where table_number=p_table_number;
    
    if table_no > 0 then
		set error_message = 'Error: Table already exists';
        select error_message as message;
	
    elseif p_seat_capacity <2 or p_seat_capacity>12 then
		set error_message='error: seating capacoty must be between 2 and 12';
        select error_message as message;
        
	elseif p_location not in ('Window', 'Indoor', 'Outdoor') then
		set error_message='Error: location must be window, indoor or outdoor';
        select error_message as message;
	
    else
		insert into tables (table_number, seating_capacity, location, status)
        values (p_table_number, p_seat_capacity, p_location, 'AVAILABLE');    
    
	end if;
END //
DELIMITER ;
    
call AddNewTable(10, 6, 'Window');
call AddNewTable(11, 10, 'Wallside');