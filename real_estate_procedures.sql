use real_estate;

DELIMITER //

DROP PROCEDURE IF EXISTS make_deal;

CREATE PROCEDURE make_deal (IN property BIGINT, IN requirement BIGINT, IN deal_type ENUM ('sold', 'rented'), IN price BIGINT )
BEGIN
	START  TRANSACTION;
		UPDATE properties 
		SET status = deal_type 
		WHERE id = property;
	
	    UPDATE requirements 
		SET wanted = 'closed' 
		WHERE id = requirement;
	
		INSERT INTO deals (status, price, property, requirement, done_at)
		VALUES (deal_type, price, property, requirement, NOW());
	
    COMMIT;
END//

DELIMITER ;

call make_deal (1,1,'sold',200000);

-- проверяем
select * from deals; -- появилась сделка
select * from properties p where id =1; -- статус теперь sold 
SELECT * from requirements r where id=1; -- статус поиска (wanted) теперь closed