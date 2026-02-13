-- UPDATE Operations 
-- Simple UPDATE Procedure
-- Scenario: Update dish price.

use restaurent_db;

DELIMITER //
CREATE PROCEDURE UpdateDishPrice(
	IN p_dish_id int,
    IN new_price decimal(10,2)
    )
BEGIN
	update dishes
    set price=new_price
    where dish_id=p_dish_id;
    
    select concat('price updated for dish_id: ', p_dish_id) as message;
END //
DELIMITER ;

call UpdateDishPrice(1, 13.99);

select * from dishes where dish_id=1;

-- UPDATE with Percentage Increase/Decrease
-- Scenario: Apply seasonal price adjustment by percentage.

drop procedure if exists AdjustMenuPrices;
DELIMITER //
CREATE PROCEDURE AdjustMenuPrices(
	in p_category varchar(30),
    in adjust_percent decimal(10,2)
    )
proc_main:
BEGIN
	-- declare variables
    declare updated_dishes int;
    declare result_message varchar(100);
    
    -- declare exit handler 
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			ROLLBACK;
			RESIGNAL;
        END;
    
    -- transactional block
    start transaction;
    if adjust_percent < -30 then
		set result_message='cannot decrease prices by more than 30%';
        signal sqlstate '45000'
        set message_text=result_message;
        leave proc_main;
	
    elseif adjust_percent >50 then
		set result_message='Cannt increase prices by more than 50%';
        signal sqlstate '45000'
        set message_text=result_message;
        leave proc_main;
	
    else
		select count(*) into updated_dishes
        from dishes
        where category=p_category;
        
        update dishes
        set price=(price + price*(adjust_percent/100))
        where category=p_category;
        
	end if;
    
    COMMIT;
    
    SELECT 
		CONCAT(updated_dishes, 'dishes in', p_category, 'updated') as Message,
        concat(adjust_percent, '%') As price_adjustment;   
      
END //
DELIMITER ;

CALL AdjustMenuPrices('Appetizer', 10.00);
CALL AdjustMenuPrices('Appetizer', 55.00);
CALL AdjustMenuPrices('Appetizer', -30.00);


set sql_safe_updates =0;

-- UPDATE with Existence and Stock Check
-- Scenario: Restock an ingredient only if it exists and needs restocking.

drop procedure RestockIngredient;
delimiter //
create procedure RestockIngredient(
	IN p_ingre_name varchar(100),
    IN additional_qty decimal(10,2)
    )
proc_main:
BEGIN
	declare ingredients_exists int;
    declare current_qty decimal(10, 2);
    declare restock_level decimal(10,2);
    declare error_message varchar(100);
    declare new_quantity decimal(10,2);
    
    declare exit handler for sqlexception
	begin
		rollback;
        resignal;
	end;
    
    start transaction;
    
    select count(*) into ingredients_exists
    from ingredients
    where ingredient_name=p_ingre_name;
    
    select quantity_in_stock, reorder_level into current_qty, restock_level
    from ingredients
    where ingredient_name=p_ingre_name;    
    
    if ingredients_exists = 0 then
		set error_message='Error! ingredient not found';
        signal sqlstate '45000'
        set message_text=error_message;
        leave proc_main;
        
	elseif  current_qty > restock_level then
		set error_message='No need to restock';
        signal sqlstate '45000'
        set message_text= error_message;
        leave proc_main;
	
    else 
		set new_quantity= current_qty+additional_qty;
        
        update ingredients
        set quantity_in_stock=new_quantity
        where ingredient_name=p_ingre_name;
        
	end if;    
   
    select concat(p_ingre_name, ' restocked successfully') as message;
    
	commit;

end //
delimiter ;

call RestockIngredient('Tomatoes', 30);
CALL RestockIngredient('Unicorn Powder', 10.0);

update ingredients
set quantity_in_stock=5
where ingredient_name='Tomatoes';

select * from ingredients;

/* 👨‍💻 HANDS-ON PRACTICE:
Create ChangeTableStatus(IN table_num INT, IN new_status VARCHAR(20)) that:
•	Validates the table exists
•	Validates new_status is one of: 'Available', 'Occupied', 'Reserved'
•	Updates the status
•	Returns old status and new status */

drop procedure if exists ChangeTableStatus;
delimiter //
create procedure ChangeTableStatus(
	IN p_table_number int,
    IN p_new_status varchar(30)
    )
proc_main:
Begin
	declare table_exists int;
    declare present_status varchar(20);
    declare error_message varchar(100);
    
    declare exit handler for sqlexception
    begin 	
		rollback;
        resignal;
	end;
    
    start transaction;
    
    select count(*) into table_exists
    from tables
    where table_number=p_table_number;
    
    select status into present_status 
    from tables
    where table_number=p_table_number;
    
    if table_exists=0 then
		set error_message="Table doesn't exist";
        signal sqlstate '45000'
        set message_text=error_message;
        leave proc_main;
        
	elseif p_new_status not in ('Available', 'Occupied', 'Reserved') then
		set error_message="new_status should be 'Available', 'Occupied' or 'Reserved'";
        signal sqlstate '45000'
        set message_text=error_message;
        leave proc_main;
        
	else
        update tables
        set status=p_new_status
        where table_number=p_table_number;
	
    end if;
        
	select p_table_number as 'table_number',
	present_status as 'old_status',
	p_new_status as 'new_status';        
	    
    commit;

end //
delimiter ;
   
call ChangeTableStatus(1, 'Available');
call ChangeTableStatus(1, 'Occupied');