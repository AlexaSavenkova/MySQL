use real_estate;

-- выбираем из представления недвижимость только на продажу или только аренду

select * FROM available_properties
WHERE status = 'sell';


select * FROM available_properties
WHERE status = 'rent';


-- выбираем для конкретной заявки (3) по типу недвижимости и типу сделки (продажа/аренда)

select * from properties 
where property_type in 
	(select property_type from requirements_property_types 
	where requirement =3)
and status = 
   (select wanted from requirements 
	where id =3);

-- выбираем для конкретной заявки (3) по типу недвижимости и типу сделки (продажа/аренда) и по цене заявки
-- для проверки обновим диапазон цен в заявке 3 ( )
UPDATE requirements 
SET price_from = 200000, price_to = 400000
WHERE id =3;

select * from properties 
where property_type in 
	(select property_type from requirements_property_types 
	where requirement =3)
and status = 
	(select wanted from requirements 
	where id =3)
and price >= 
	(select price_from FROM requirements r WHERE id=3)
and price <= 
	(select price_to FROM requirements r WHERE id=3)
;



	
-- выбираем  количество разных типов недвижимости на продажу
select pt.name , COUNT(*) 
FROM properties p 
JOIN property_types pt ON p.property_type = pt.id 
WHERE p.status = 'sell'
GROUP BY pt.name;


-- средняя цена аренды  по типам недвижимости 
select pt.name , AVG(p.price) 
FROM properties p 
JOIN property_types pt ON p.property_type = pt.id 
WHERE p.status = 'rent'
GROUP BY pt.name;


-- список клиентов в работе, как владелцев, так и желающих купить/арендовать

-- для проверки уникальности данных добавим клиента 1 (который есть в таблице properties) в таблицу requirements
INSERT INTO requirements VALUES (101,1,'rent',1,1755,135,1,1,1,4,0,1,NULL,'2011-01-18 02:49:14','1981-07-05 05:48:34');

(SELECT c.id AS id, CONCAT(firstname, ' ', lastname) AS name , phone, email 
FROM clients c 
JOIN properties p ON p.owner = c.id 
UNION
SELECT c.id AS id, CONCAT(firstname, ' ', lastname) AS name, phone, email 
FROM clients c 
JOIN requirements r ON r.client = c.id)
ORDER BY id;


-- список потенциальных клиентов, которые пока не оформили ни одной заявки
-- (их нет в таблицах)

SELECT id, CONCAT(firstname, ' ', lastname) AS name , phone, email
FROM clients
WHERE id NOT IN 
	(SELECT c.id AS id
	FROM clients c 
	JOIN properties p ON p.owner = c.id 
	UNION
	SELECT c.id AS id
	FROM clients c 
	JOIN requirements r ON r.client = c.id)
;	


 



