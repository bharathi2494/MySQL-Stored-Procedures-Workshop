/* Output Parameters 
Ouput parameters allow procedure to RETURN Values back to you */

-- simple output parameter
-- scenerio: get the total number of dishes from menu.

DELIMITER //
CREATE PROCEDURE TotalDishes(OUT total INT)
BEGIN
	select count(*) into total
    from dishes
    where is_available=True;
END //
DELIMITER ;

CALL TotalDishes(@tot_dishes);
select @tot_dishes as available_dishes;

-- Note: The @ symbol creates a user variable that stores the returned value.

-- create procedure to get avaiable tables
DELIMITER //
CREATE PROCEDURE GetAvailableTables(OUT total INT)
BEGIN
	SELECT count(*) into total
    from tables
    where status='available';
END //
DELIMITER ;
    
CALL GetAvailableTables(@tot_available);
SELECT @tot_available AS total_Avaiable_tables;
    
-- Multiple OUT Parameters
-- Scenario: Get minimum and maximum dish prices in one call.

DROP PROCEDURE IF EXISTS GetPriceRange;
DELIMITER //
CREATE PROCEDURE GetPriceRange(
	OUT min_price decimal(10,2),
    OUT max_price decimal(10,2)
    )
BEGIN
	select min(price), max(price) into min_price, max_price
    from dishes where is_available=True;
END //
DELIMITER ;

call GetPriceRange(@min_price, @max_price);
select @min_price as minimumprice, @max_price as maximum_price, round(@max_price-@min_price, 2) as Price_Range;

-- Combining IN and OUT Parameters
-- Scenario: Get average price for dishes in a specific category.

DROP PROCEDURE IF EXISTS GetCategoryAvgPrice;
DELIMITER //
CREATE PROCEDURE GetCategoryAvgPrice(
	INOUT p_category VARCHAR(30),
    OUT Avg_price DECIMAL(10,2)
    )
BEGIN
	SELECT category, avg(price) as Avg_price into p_category, avg_price
    from dishes
    where category=p_category
    and is_available=True;
END //
DELIMITER ;

SET @p_category='Dessert';
call GetCategoryAvgPrice(@p_category, @avg_price);
select @p_category as category, @avg_price as Dish_average_price;


DROP PROCEDURE IF EXISTS GetCategoryAvgPrice1;
DELIMITER //
CREATE PROCEDURE GetCategoryAvgPrice1(
	IN p_category VARCHAR(30),
    OUT p_cat varchar(30),
    OUT Avg_price DECIMAL(10,2)
    )
BEGIN
	SELECT category, avg(price) as Avg_price into p_cat, avg_price
    from dishes
    where category=p_category
    and is_available=True
    group by category;
END //
DELIMITER ;

call GetCategoryAvgPrice1('Dessert', @p_category, @avg_price);
select @p_category as category, @avg_price as Dish_average_price;

-- Get cuisine statistics

DROP PROCEDURE IF EXISTS GetCuisineStats;
DELIMITER //
CREATE PROCEDURE GetCuisineStats(
	INOUT p_cuisine VARCHAR(20),
    OUT total_count INT,
    OUT avg_price DECIMAL(10,2)
    )
BEGIN
	SELECT cuisine_type, count(*), avg(price) into p_cuisine, total_count, avg_price
    from dishes
    where cuisine_type=p_cuisine
    and is_available=True;
END //
DELIMITER ;
       
SET @p_cuisine='American';    
CALL GetCuisineStats(@p_cuisine, @tot_count, @avg_price);
select @p_cuisine as cuisine, @tot_count as total_count, @avg_price as Average_price;

-- count by spicelevel
DROP PROCEDURE IF EXISTS GetCountBySpiceLevel;
DELIMITER //
CREATE PROCEDURE GetCountBySpiceLevel(
	IN p_spice_level INT(10),
    OUT spic_level INT(10),
    OUT tot_count int
    )
BEGIN
	SELECT spice_level, count(*) into spic_level, tot_count
    from dishes
    where spice_level=p_spice_level
    and is_available=True
    group by spice_level;
END //
DELIMITER ;

CALL GetCountBySpiceLevel(1, @spic_level, @tot_count);
select @spic_level as spice_level, @tot_count as dish_count;

-- stock statistics(ingredients stats)
DROP PROCEDURE IF EXISTS GetIngradientsStats;
DELIMITER //
CREATE PROCEDURE GetIngradientsStats(
	OUT total_ingredients INT,
    OUT low_stock_count int
    )
BEGIN
	select count(*) into total_ingredients
    from ingredients;
    select count(*) into low_stock_count 
    from ingredients 
    where quantity_in_stock < reorder_level;
END //
DELIMITER ;

call GetIngradientsStats(@total_ingredients, @low_stock_count);
select @total_ingredients as total_ingredients, @low_stock_count as low_stock_count;

-- GET TABLE STATUS INFO
-- shows total count and sating capacity for the status
DROP PROCEDURE IF EXISTS GetTableStatusInfo;
DELIMITER //
CREATE PROCEDURE GetTableStatusInfo(
	IN p_status varchar(10),
    OUT p_table_count INT,
    OUT p_seat_capacity INT
    )
BEGIN
	select count(*), sum(seating_capacity) into p_table_count, p_seat_capacity
    from tables
    where status=p_status;
END //
DELIMITER ;

call GetTableStatusInfo('Available', @count, @seats);
select @count as table_count, @seats as seating_capacity;

call GetTableStatusInfo('Occupied', @count, @seats);
select @count as table_count, @seats as seating_capacity;

call GetTableStatusInfo('Reserved', @count, @seats);
select @count as table_count, @seats as seating_capacity;