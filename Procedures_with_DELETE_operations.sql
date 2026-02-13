-- DELETE Operations
-- EXERCISE 18: Safe DELETE with Validation
-- Scenario: Remove a dish from menu only if it hasn't been ordered recently.

use restaurent_db;

drop procedure if exists RemoveDishFromMenu;
DELIMITER //
CREATE PROCEDURE RemoveDishFromMenu( IN p_dish_id int)
proc_main:
begin 
	declare dish_exists int;
    declare dish_name varchar(30);
    declare recent_orders int;
    declare error_message varchar(100);
    
    declare exit handler for sqlexception
    begin 
		rollback;
        resignal;
	end;
    
    select count(*), max(dish_name) into dish_exists, dish_name
    from dishes
    where dish_id=p_dish_id;
    
    select count(*) into recent_orders
    from order_items oi join orders o 
    on oi.order_id=o.order_id 
    where oi.dish_id=p_dish_id
    and o.order_date >= date_sub(current_date(), interval 30 day);
    
	if dish_exists = 0 theN
		SET error_message='Dish not exists';
        signal sqlstate '45000'
        set message_text=error_message;
        leave proc_main;   
   
   elseif recent_orders > 0 then
		set error_message= concat('cannot delete', dish_name, recent_orders);
        signal sqlstate '45000'
        set message_text=error_message;
        leave proc_main;	   
	
    else 
		delete from dishes 
        where dish_id=p_dish_id;
	
    end if;
    
    select concat(dish_name, 'removed successfully from menu') as message;
    
    commit;
    
end //
delimiter ;

CALL RemoveDishFromMenu(12);

SELECT COUNT(*), MAX(dishes.dish_name)
FROM dishes
WHERE dishes.dish_id = 14;

select * from dishes;

  select count(*)
    from order_items oi join orders o 
    on oi.order_id=o.order_id 
    where oi.dish_id=1
    and o.order_date >= date_sub(current_date(), interval 30 day);
    
/* Final Project - Restaurant Order Management Procedure:
Create a comprehensive procedure called PlaceOrder that:
1.	Takes parameters: IN table_id, IN dish_id, IN quantity, IN special_instructions
2.	Validates table exists and is not "Reserved"
3.	Validates dish exists and is available
4.	Validates quantity is positive
5.	Inserts the order with current date/time
6.	Calculates total based on dish price and quantity
7.	Returns order_id and total_amount */

drop procedure if exists PlaceOrder;
DELIMITER //
CREATE PROCEDURE PlaceOrder(
	IN p_table_id int,
    IN p_dish_id int,
    IN p_qty decimal(10,2),
    IN p_special_insructions varchar(100)
    )
proc_main:
begin
	declare table_exists int;
    declare dish_exists int;
    declare dish_price decimal(10,2);
    declare total_price decimal(10,2);
    declare error_message varchar(100);
    declare order_id int;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
        RESIGNAL;
	END;
    
    select count(*) into table_exists
    from tables
    where table_id=p_table_id
    and status='Available';
    
    select count(*) into dish_exists
    from dishes
    where dish_id = p_dish_id
    and is_available=True;
    
    select price into dish_price
    from dishes 
    where dish_id=p_dish_id;
    
    if table_exists=0 then
		set error_message='table does not exists';
        signal sqlstate '45000'
        set message_text=error_message;
        leave proc_main;
        
	elseif dish_exists=0 then
		set error_message='dish does not exists';
        signal sqlstate '45000'
        set message_text=error_message;
        leave proc_main; 
        
	elseif p_qty <= 0 then
		set error_message='quantity should be positive';
        signal sqlstate '45000'
        set message_text=error_message;
        leave proc_main;
	
    else
		set total_price= p_qty * dish_price;
        set order_id =last_insert_id();
        
        insert into orders (table_id, order_date, total_amount, order_status, special_instructions)
        values(p_table_id, current_date(), total_price, 'Completed', p_special_insructions);
        
        insert into order_items(order_id, dish_id, quantity, item_price)
        values (order_id, p_dish_id, p_qty, dish_price);
        
        select order_id as 'order_id', total_price as total_amount;
        
        commit;
        
        end if; 
    
end //
delimiter ;

call PlaceOrder (5, 4, 10, 'no spicy');

select * from orders;
select * from order_items;


