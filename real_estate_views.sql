use real_estate;

-- список всей доступной недвижимости в читабельном виде (с названиями )

CREATE OR REPLACE VIEW available_properties
AS 
SELECT p.id, p.status, p.price, c.name AS city, cnt.name AS country, pt.name AS 'type',
h.name AS heating, p.rooms, p.bathrooms, p.built_size , p.plot_size, p.description 
	FROM properties p 
	JOIN cities c ON p.city = c.id
	JOIN countries cnt ON c.country_id = cnt.id 
	JOIN property_types pt ON p.property_type = pt.id 
	LEFT JOIN heating_types h ON p.heating_type = h.id 
WHERE p.status = 'sell' OR p.status = 'rent';


-- проверяем
select * FROM available_properties;
select * from properties WHERE status = 'sell' OR status = 'rent';
-- получили одинаковое число строк


CREATE OR REPLACE VIEW current_requirements
AS 
SELECT r.id, pt.name AS 'type', r.wanted, r.price_from ,r.price_to , c.name AS city, cnt.name AS country,
r.rooms_from , r.rooms_to, r.commentaty 
FROM requirements r 
	JOIN cities c ON r.city = c.id
	JOIN countries cnt ON c.country_id = cnt.id 
	JOIN requirements_property_types rpt ON rpt.requirement = r.id
	JOIN property_types pt ON rpt.property_type = pt.id 
WHERE r.wanted = 'sell' OR r.wanted = 'rent'
order by r.id;

-- проверяем
select * from current_requirements;
