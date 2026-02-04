-- create procedure using IN parameter
-- find dishes by cuisine
DROP PROCEDURE GetDishesByCuisine;
DELIMITER //
CREATE PROCEDURE GetDishesByCuisine (IN cuisine varchar(50))
BEGIN
	SELECT dish_id, dish_name, cuisine_type, category, price, spice_level
    FROM dishes
    WHERE cuisine_type= cuisine
    and is_available= TRUE;
END
//
DELIMITER ;

call GetDishesByCuisine('Italian');
call GetDishesByCuisine('Thai');
call GetDishesByCuisine('Indian');
call GetDishesByCuisine('Tiramisu'); -- dish name

-- create stored procedure using IN parameter
-- find tables by location
DELIMITER $$
CREATE PROCEDURE GetTablesByLocation(IN loc VARCHAR(10))
BEGIN
	select table_number, seating_capacity, location, status from tables
    WHERE location=loc;
END $$
DELIMITER ;

CALL GetTablesByLocation('Window');
CALL GetTablesByLocation('Outdoor');
CALL GetTablesByLocation('Indoor');

-- Multiple IN Parameters

-- Find dishes by cuisine type and maximum price.
DROP PROCEDURE IF EXISTS DishesByCuisinePrice;
DELIMITER //
CREATE PROCEDURE DishesByCuisinePrice(
	IN cuisine VARCHAR(10),
    IN max_price decimal(10,2)
    )
BEGIN
	SELECT dish_id, dish_name, cuisine_type, category, price, preparation_time, spice_level
    from dishes
    where cuisine_type= cuisine
    and price <= max_price
    and is_available= True
    order by price ASC;
END //
DELIMITER //

-- Italian dishes under $10
CALL DishesByCuisinePrice('Italian', 10.00);

-- Thai dishes under $15
CALL DishesByCuisinePrice('Thai', 15.00);
    
-- find tables by capacity range
DROP PROCEDURE IF EXISTS GetTablesByCapacityRange;
DELIMITER //
CREATE PROCEDURE GetTablesByCapacityRange(
	IN min_seats INT,
    IN max_seats int
)
BEGIN
	SELECT table_id, table_number, seating_capacity, location, status 
    from tables
    where seating_capacity >= min_seats 
    and seating_capacity <=max_seats;
END //
DELIMITER ;

CALL GetTablesByCapacityRange(2,4);

-- Parameters with Calculations
-- Show dishes with discounted prices. 
DROP PROCEDURE IF EXISTS ShowHappyHourPrices;
DELIMITER //
CREATE PROCEDURE ShowHappyHourPrices(
	IN category varchar(30),
    IN discount_percent decimal(10,2)
    )
BEGIN
	SELECT dish_id, dish_name, cuisine_type, category, 
    price AS regular_price,
    round((1-discount_percent/100)*price, 2) as happy_our_price,
    round((discount_percent)/100*price, 2) as savings
    from dishes
    where category=category
    and is_available=True;
END //
DELIMITER ;

CALL ShowHappyHourPrices('Italian', 15);
CALL ShowHappyHourPrices('Appetizer', 25);