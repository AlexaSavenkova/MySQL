/* 
 * База данных агенства недвижимости.
 * 
 */
DELIMITER ;
DROP DATABASE IF EXISTS real_estate;
CREATE DATABASE real_estate;
USE real_estate;

CREATE TABLE clients (
	id SERIAL PRIMARY KEY, 
    firstname VARCHAR(50) NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    email VARCHAR(120) UNIQUE,
	phone VARCHAR(15) UNIQUE,  
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
	
    INDEX users_firstname_lastname_idx (firstname, lastname)
) COMMENT 'клиенты';

CREATE TABLE countries(
	id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) -- страны с которыми работает агенство
);

CREATE TABLE cities(
	id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    country_id TINYINT UNSIGNED NOT NULL,
    
    FOREIGN KEY (country_id) REFERENCES countries(id),
    UNIQUE KEY city_country_idx (name, country_id)
);


CREATE TABLE property_types(
	id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(60) NOT NULL UNIQUE
);

CREATE TABLE heating_types(
	id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(60) NOT NULL UNIQUE
);

CREATE TABLE security_types(
	id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(60) NOT NULL UNIQUE
);

CREATE TABLE properties(
	id SERIAL,
  	owner BIGINT UNSIGNED NOT NULL,
  	status ENUM('sell', 'rent', 'sold', 'rented', 'canceled'),
  	price BIGINT UNSIGNED NOT NULL,
  	city BIGINT UNSIGNED NOT NULL,
  	adress VARCHAR(255),
  	property_type TINYINT UNSIGNED NOT NULL,
  	heating_type TINYINT UNSIGNED, -- может быть NULL т.е. нет отопления
  	rooms TINYINT UNSIGNED, 
  	bathrooms TINYINT UNSIGNED, 
  	built_size DECIMAL(12,2),
  	plot_size DECIMAL(12,2),
  	description TEXT, -- дополнительная информация 
  	created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
  	
  	FOREIGN KEY (owner) REFERENCES clients(id),
  	FOREIGN KEY (city) REFERENCES cities(id),
  	FOREIGN KEY (property_type) REFERENCES property_types(id),
  	FOREIGN KEY (heating_type) REFERENCES heating_types(id)
);


CREATE TABLE photos(
    filename VARCHAR(60) NOT NULL UNIQUE,
    property BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (property, filename),
    FOREIGN KEY (property) REFERENCES properties(id)
);

/*
 * Каждый объект недвижимости может иметь несколько видов охраны.
 * например охраняемый поселок и сигнализация в доме
 */

CREATE TABLE property_security(
	id SERIAL,
	property BIGINT UNSIGNED NOT NULL,
	security_type TINYINT UNSIGNED NOT NULL,
	
    FOREIGN KEY (property) REFERENCES properties(id),
    FOREIGN KEY (security_type) REFERENCES security_types(id),
    UNIQUE KEY property_security_idx(property, security_type )
);

-- заявки на покупку или аренду
CREATE TABLE requirements(
	id SERIAL,
  	client BIGINT UNSIGNED NOT NULL,
  	wanted ENUM('sell', 'rent', 'closed', 'canceled') COMMENT 'closed - если сделка зарыта, canceled - заявка снята',
  	city BIGINT UNSIGNED NOT NULL,
  	price_from BIGINT UNSIGNED NOT NULL,
  	price_to BIGINT UNSIGNED NOT NULL,
  	rooms_from TINYINT UNSIGNED,
  	rooms_to TINYINT UNSIGNED,
  	bathrooms_from TINYINT UNSIGNED,
  	bathrooms_to TINYINT UNSIGNED,
  	heating BOOL DEFAULT FALSE, -- TRUE - нужно отопление в доме, FALSE - не важно  
  	security_  BOOL DEFAULT FALSE, -- TRUE - нужна  охрана, FALSE - не важно  
  	commentaty TEXT, -- дополнительные пожелания 
  	created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
  	
  	FOREIGN KEY (client) REFERENCES clients(id),
  	FOREIGN KEY (city) REFERENCES cities(id)
  
);

/* В одной заявке может быть несколько типов недвижимости, 
 * например клиент хочет купить дом или таунхаус
 */

CREATE TABLE requirements_property_types(
	id SERIAL,
	requirement BIGINT UNSIGNED NOT NULL,
	property_type TINYINT UNSIGNED NOT NULL,
	
    FOREIGN KEY (requirement) REFERENCES requirements(id),
    FOREIGN KEY (property_type) REFERENCES property_types(id),
    
    UNIQUE KEY requirement_property_types_inx(requirement, property_type )
);


CREATE TABLE deals(
	id SERIAL,
  	status ENUM('sold', 'rented'),
  	price BIGINT UNSIGNED NOT NULL,
  	property BIGINT UNSIGNED NOT NULL,
  	requirement BIGINT UNSIGNED NOT NULL,
  	done_at DATETIME DEFAULT NOW(),
  	
    FOREIGN KEY (requirement) REFERENCES requirements(id),
  	FOREIGN KEY (property) REFERENCES properties(id)
  	
);











