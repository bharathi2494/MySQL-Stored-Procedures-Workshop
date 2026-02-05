use restaurent_db;

/* 1. Variables and conditional logic
	variable are like temporary storage boxes inside procedure.
    
    syntax:
		DECLARE variable_name DATATYPY;
        SET variable_name=value; */

-- using variables
-- scenario: calculate total cooking time for multi dish order

DROP PROCEDURE IF EXISTS CalculateOrderTime;
DELIMITER //
CREATE PROCEDURE CalculateOrderTime(
	IN dish1_id VARCHAR(30),
    IN dish2_id VARCHAR(30)
)
BEGIN
	DECLARE time1 int;
    DECLARE time2 int;
    DECLARE total_time int;
    DECLARE max_time int;
    
    select preparation_time into time1 
    from dishes
    where dish_id=dish1_id;
    select preparation_time into time2 
    from dishes 
    where dish_id=dish2_id;
    
    SET total_time= time1 + time2;
    
    IF time1 > time2 THEN
		SET max_time= time1;
	ELSE 
		SET max_time = time2;
	END IF;
    
    -- DISPLAY RESULTS
    SELECT
		'Order summary' as info,
        time1 as 'dish 1 Time(mins)',
        time2 as 'dish 1 Time(mins)',
        max_time as 'Ready in (parallel cooking)',
        total_time as 'total Time(sequential)'; 
END //
DELIMITER ;
        
        
call CalculateOrderTime(1,2);

-- Scenario: Check if an ingredient needs reordering.

DROP PROCEDURE IF EXISTS CheckIngradientStock;
DELIMITER //
CREATE PROCEDURE CheckIngradientStock(
	IN ingredient varchar(10)
    )
BEGIN
	DECLARE current_stock DECIMAL(10,2);
    DECLARE reorder_threshold DECIMAL(10,2);
    DECLARE STOCK_STATUS VARCHAR(50);
    
    select quantity_in_stock, reorder_level into current_stock, reorder_threshold
    FROM ingredients
    where ingredient_name= ingredient;
    
    IF current_stock <= reorder_threshold THEN
		 set STOCK_STATUS ='Yes, Reorder needed';
	else
		set STOCK_STATUS ='No, Reorder not needed';
	end if;
	
    select
		ingredient as Ingredient,
        current_stock AS available_quantity,
        reorder_threshold as reorder_level,
        STOCK_STATUS as status;     
end //
delimiter ;
         
         
CALL CheckIngradientStock('Tomatoes');
CALL CheckIngradientStock('Chocolate');