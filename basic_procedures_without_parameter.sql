
-- basic stored procedure without parameters

DELIMITER //
CREATE PROCEDURE showalldishes()
BEGIN
	SELECT * FROM dishes;
END //
DELIMITER ;

CALL showalldishes();

-- create procedure for menu prices
DROP PROCEDURE IF EXISTS ShowMenuPrices;
 
DELIMITER //
CREATE PROCEDURE ShowMenuPrices()
BEGIN
	SELECT 
		dish_id, dish_name, cuisine_type, price,
        concat(preparation_time, 'mins')
	FROM dishes
    WHERE is_available= False
    ORDER BY category, price;
END
//
DELIMITER ;
CALL ShowMenuPrices();

-- create stored procedure to know table number and capacity
DELIMITER //
CREATE PROCEDURE ShowTableCapacity()
BEGIN
	SELECT table_number, seating_capacity 
    FROM tables
    order by 2;
END
//
DELIMITER ;
CALL ShowTableCapacity();
