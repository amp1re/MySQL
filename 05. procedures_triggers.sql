USE serials_base;

/* Процедура предлагает сериал к просмотру.
 * Критерии выбора:
 * 1) Жанр
 * 2) Страна производства
 */

DROP PROCEDURE IF EXISTS sp_serials_offers;

delimiter //


CREATE PROCEDURE sp_serials_offers(IN for_user_id BIGINT)
BEGIN
-- Жанр
	SELECT s2.name, s2.country
		FROM serials as s1
		JOIN favorities as f
		ON s1.id =f.serials_id
		JOIN serials as s2
		ON s1.genres_id = s2.genres_id
		WHERE f.users_id = for_user_id and f.is_disliked = 0 and s1.id <> s2.id
-- Страна производства
	UNION
	SELECT s2.name, s2.country
		FROM serials as s1
		JOIN favorities as f
		ON s1.id = f.serials_id
		JOIN serials as s2
		ON s1.country = s2.country
		WHERE f.users_id = for_user_id and f.is_disliked = 0 and s1.id <> s2.id
	ORDER BY rand()
	LIMIT 3;
	
END//

delimiter ;

CALL sp_serials_offers(2);

-- Процедура предлагает пользвателю прочитать какую-либо новость об избранном сериале


DROP PROCEDURE IF EXISTS sp_news_offers;

delimiter //


CREATE PROCEDURE sp_news_offers(IN for_user_id BIGINT)
BEGIN
SELECT
	s.name as 'Название сериала',
	n.message 'Сообщение',
	n.created_at as 'Дата'
	FROM news as n
	JOIN serials as s
	ON n.serials_id = s.id
	JOIN favorities as f
	ON f.serials_id = s.id
	WHERE f.users_id = for_user_id and f.is_disliked = 0
	ORDER BY rand()
	LIMIT 1;
	
END//

delimiter ;

CALL sp_news_offers(2);

-- Триггер проверки возраста представителя съемочной команды

drop TRIGGER if exists check_crew_age_before_insert;

DELIMITER //

CREATE TRIGGER check_crew_age_before_insert BEFORE INSERT ON crew
FOR EACH ROW
begin
    IF NEW.birthdate > CURRENT_DATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insert Canceled. Birthday must be in the past!';
    END IF;
END//

DELIMITER ;


LOCK TABLES `crew` WRITE;
INSERT INTO `crew` VALUES (1,'Actor','CheckCrew','Check','f','2031-11-29',0);
UNLOCK TABLES;


-- Триггер  добавляет информацию в таблицу History, когда был изменен сериал и кем

DROP TABLE IF EXISTS History;

CREATE TABLE History (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    serials_id INT NOT NULL,
    operation VARCHAR(200) NOT NULL,
    created_at DATETIME DEFAULT NOW()
);



drop TRIGGER if exists serials_update;

DELIMITER //

CREATE TRIGGER serials_update AFTER UPDATE ON serials
FOR EACH ROW
	begin
	INSERT INTO History(username, serials_id, operation) VALUES (user(), new.id, 'Обновлен');
	end//

DELIMITER ;


UPDATE serials
SET name = 'Check4'
WHERE id = 11;

SELECT * FROM History;

