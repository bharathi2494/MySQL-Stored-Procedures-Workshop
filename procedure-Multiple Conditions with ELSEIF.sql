use restaurent_db;

-- Multiple conditions with elseif
-- Scenario: Categorize dishes by spice level for customers.

DROP PROCEDURE IF EXISTS GetSpiceDescription;
DELIMITER //
CREATE PROCEDURE GetSpiceDescription(
	IN p_dish_name varchar(100)
    )
BEGIN
	DECLARE spice int;
    DECLARE description varchar(50);
    DECLARE recommendation varchar(50);
    
    select spice_level into spice 
    from dishes
    where dish_name=p_dish_name;
    
    if spice=0 then
		set description='Mild- No spice';
        set recommendation= 'Perfect for everyone';
	elseif spice= 1 then
		set description='MILD- Very Light spice';
        set recommendation='Great for kids';
	elseif spice between 2 and 3 then
		set description='MEDIUM- Moderate spice';
        set recommendation='Most popular choice';
	elseif spice=4 then
		set description='HOT- strong spice';
        set recommendation='for spice lovers only';
	else
		set description='Extra Hot- Extreme spice';
        set recommendation='challenge accepted!';
	end if;
    
    select
		p_dish_name as 'Dish',
        spice as 'Spice_level (0-5)',
        description as 'Heat Level',
        recommendation as 'Who should try';    
END //
DELIMITER ;

call GetSpiceDescription('Chicken Tikka Masala');
call GetSpiceDescription('Pad Thai');