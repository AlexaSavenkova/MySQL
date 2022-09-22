use real_estate;

-- проверка заполнения либо размера участка, либо размера жилой полщади
-- что-то одно должно быть не  NULL 

DROP TRIGGER IF EXISTS property_size_check;

DELIMITER //

CREATE TRIGGER property_size_check BEFORE INSERT ON properties
FOR EACH ROW 
BEGIN 
	IF NEW.built_size IS NULL AND NEW.plot_size IS NULL THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSERT canceled. Buil size or plot size must be NOT NULL';
	END IF;
END//

DELIMITER ;

INSERT INTO properties VALUES (101,1,'sell',28379,1,'580 Dayne Lakes',1,1,9,3,NULL,NULL,'Et sed vero ipsum culpa.','2005-11-28 02:28:52','1975-03-08 20:22:40');

-- SQL Error [1644] [45000]: INSERT canceled. Buil size or plot size must be NOT NULL
-- то же самое при обновлении

INSERT INTO properties VALUES (101,1,'sell',28379,1,'580 Dayne Lakes',1,1,9,3,NULL,1234,'Et sed vero ipsum culpa.','2005-11-28 02:28:52','1975-03-08 20:22:40');

--  это работает


DROP TRIGGER IF EXISTS property_size_update_check;

DELIMITER //

CREATE TRIGGER property_size_update_check BEFORE UPDATE ON properties
FOR EACH ROW 
BEGIN 
	IF NEW.built_size IS NULL AND NEW.plot_size IS NULL THEN 
		SET NEW.built_size = COALESCE(NEW.built_size, OLD.built_size);
		SET NEW.plot_size = COALESCE(NEW.plot_size, OLD.plot_size);
	END IF;
END//

DELIMITER ;
--  проверяем
UPDATE properties 
SET plot_size = NULL 
where id = 101;

select plot_size from properties p 
where id = 101;
-- plot_size  остался 1234 


DROP TRIGGER IF EXISTS phone_check;

DELIMITER //

CREATE TRIGGER phone_check BEFORE INSERT ON clients
FOR EACH ROW 
BEGIN 
	IF NEW.phone NOT RLIKE '^[0-9\\(\\)\\+-]*$' THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSERT canceled. Phone must contain only digits and symbols ( ) + - ';
	END IF;
END//

DELIMITER ;

-- проверяем
INSERT into clients (firstname, lastname, email,phone)
VALUES ('Alex', 'Simpson','as@yahoo.com','23abd45-67' );
-- SQL Error [1644] [45000]: INSERT canceled. Phone must contain only digits and symbols ( ) + 

INSERT into clients (firstname, lastname, email,phone)
VALUES ('Alex', 'Simpson','as12@yahoo.com','+1(23)23-4567');
-- это работает

