
-- Database creation;
DROP DATABASE IF EXISTS serials_base;
CREATE DATABASE serials_base;
USE serials_base;

-- Tables creation;
DROP TABLE IF EXISTS serials;
CREATE TABLE serials (
	id SERIAL PRIMARY KEY,
	name VARCHAR(100),
	country VARCHAR(100),
	genre VARCHAR(100) COMMENT 'Жанр',
	short_description TEXT,
	full_description TEXT,
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	INDEX serials_name_genre_idx (name, genre)
	) comment = 'Serials description table';


DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY,
    firstname VARCHAR(100),
    lastname VARCHAR(100) COMMENT 'Фамилия',
    email VARCHAR(100) UNIQUE,
    password_hash VARCHAR(100),
    phone BIGINT,
    is_deleted bit default 0,
    INDEX users_firstname_lastname_idx(firstname, lastname)
	);
	

DROP TABLE IF EXISTS episodes;
CREATE TABLE episodes (
	id SERIAL PRIMARY KEY,
	serials_id BIGINT UNSIGNED NOT NULL,
	n_season INT,
	n_episode INT,
	name VARCHAR(100),
	duration INT,
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME DEFAULT NOW() ON UPDATE CURRENT_TIMESTAMP,
	FOREIGN KEY (serials_id) REFERENCES serials(id) 
	ON UPDATE CASCADE ON DELETE CASCADE
	);

DROP TABLE IF EXISTS crew;
CREATE TABLE crew (
	id BIGINT UNSIGNED NOT NULL,
	serials_id BIGINT UNSIGNED NOT NULL,
	profession VARCHAR(100),
	firstname VARCHAR(100),
	lastname VARCHAR (100),
	gender CHAR(1),
	birthdate DATE,
	photo_id BIGINT UNSIGNED NULL,
	PRIMARY KEY (id, serials_id),
	FOREIGN KEY (serials_id) REFERENCES serials(id)
	ON UPDATE CASCADE ON DELETE CASCADE
	) comment = 'Сьемочная группа';

DROP TABLE IF EXISTS news;
CREATE TABLE news (
	id SERIAL PRIMARY KEY,
	serials_id BIGINT UNSIGNED NOT NULL,
	message TEXT,
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	FOREIGN KEY (serials_id) REFERENCES serials(id)
	ON UPDATE CASCADE ON DELETE CASCADE	
	);

DROP TABLE IF EXISTS favorities;
CREATE TABLE favorities (
	serials_id BIGINT UNSIGNED NOT NULL,
	users_id BIGINT UNSIGNED NOT NULL,
	is_disliked bit DEFAULT 0,
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (serials_id, users_id),
	FOREIGN KEY (serials_id) REFERENCES serials(id)
	ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (users_id) REFERENCES users(id)
	ON UPDATE CASCADE ON DELETE CASCADE	
	);

DROP TABLE IF EXISTS users_ratings;
CREATE TABLE users_ratings (
	users_id BIGINT UNSIGNED NOT NULL,
	episodes_id BIGINT UNSIGNED NOT NULL,
	rating TINYINT CHECK (rating >0 and rating <6),
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (users_id, episodes_id),
	FOREIGN KEY (users_id) REFERENCES users(id)
	ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (episodes_id) REFERENCES episodes(id)
	ON UPDATE CASCADE ON DELETE CASCADE
	);
	
DROP TABLE IF EXISTS reviews;
CREATE TABLE reviews (
	id SERIAL PRIMARY KEY,
	serials_id BIGINT UNSIGNED NOT NULL,
	users_id BIGINT UNSIGNED NOT NULL,
	review TEXT,
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	FOREIGN KEY (serials_id) REFERENCES serials(id)
	ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (users_id) REFERENCES users(id)
	ON UPDATE CASCADE ON DELETE CASCADE	
	);

DROP TABLE IF EXISTS reviews_ratings;
CREATE TABLE reviews_ratings (
	users_id BIGINT UNSIGNED NOT NULL,
	reviews_id BIGINT UNSIGNED NOT NULL,
	rating TINYINT CHECK (rating >0 and rating <6),
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (users_id, reviews_id),
	FOREIGN KEY (users_id) REFERENCES users(id)
	ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (reviews_id) REFERENCES reviews(id)
	ON UPDATE CASCADE ON DELETE CASCADE
	);

DROP TABLE IF EXISTS view_counter;
CREATE TABLE view_counter (
	id SERIAL PRIMARY KEY,
	users_id BIGINT UNSIGNED NOT NULL,
	episodes_id BIGINT UNSIGNED NOT NULL,
	created_at DATETIME DEFAULT NOW(),
	FOREIGN KEY (users_id) REFERENCES users(id),
	FOREIGN KEY (episodes_id) REFERENCES episodes(id)
	);
